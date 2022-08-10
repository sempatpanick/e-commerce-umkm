import 'package:e_warung/data/preferences/cart_buyer_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/model/cart_buyer_model.dart';
import '../../../data/model/list_store_result.dart';
import '../../../data/preferences/preferences_helper.dart';
import '../../../utils/result_state.dart';

class CartBuyerViewModel extends ChangeNotifier {
  final CartBuyerHelper _cartBuyerHelper = CartBuyerHelper();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  ResultState _stateStore = ResultState.none;
  ResultState get stateStore => _stateStore;

  final List<Store> _stores = [];

  final List<CartBuyerModel> _productsCart = [];
  List<CartBuyerModel> get productsCart => _productsCart;

  final List<int> _totalStorePrices = [];
  List<int> get totalStorePrices => _totalStorePrices;

  final List<int> _shippingCost = [];
  List<int> get shippingCost => _shippingCost;

  int _totalPrice = 0;
  int get totalPrice => _totalPrice;

  void setStores(List<Store> listStore) {
    changeStateStore(ResultState.loading);
    _stores.clear();
    _stores.addAll(listStore);
    changeStateStore(ResultState.hasData);
  }

  void getCartList() async {
    changeState(ResultState.loading);

    final List<CartBuyerModel> cartList = await _cartBuyerHelper.getCartList;
    _productsCart.clear();
    _productsCart.addAll(cartList);
    setTotalPrice();

    changeState(ResultState.hasData);
  }

  void addProductToCart(int idStore, ProductCart product) {
    int indexStore = _productsCart.indexWhere((store) => store.idStore == idStore);

    if (indexStore != -1) {
      int indexProduct = _productsCart[indexStore]
          .products
          .indexWhere((productItem) => productItem.idProduct == product.idProduct);

      if (indexProduct != -1) {
        _productsCart[indexStore].products[indexProduct].amount += 1;
      } else {
        _productsCart[indexStore].products.add(product);
      }
    } else {
      _productsCart.add(CartBuyerModel(idStore: idStore, products: [product]));
    }

    _cartBuyerHelper.setCartList(_productsCart);
    getCartList();
  }

  void removeProductFromCart(int indexStore, int indexProduct) {
    _productsCart[indexStore].products.removeAt(indexProduct);

    if (_productsCart[indexStore].products.isEmpty) {
      _productsCart.removeAt(indexStore);
    }

    _cartBuyerHelper.setCartList(_productsCart);
    getCartList();
  }

  void removeStoreFromCart(List<int> indexStore) {
    indexStore.sort((a, b) => b.compareTo(a));
    for (var index in indexStore) {
      _productsCart.removeAt(index);
    }

    _cartBuyerHelper.setCartList(_productsCart);
    getCartList();
  }

  void increaseAmount(int indexStore, int indexProduct, ProductStore product) {
    int stockProductStore = product.stock;

    if (_productsCart[indexStore].products[indexProduct].amount >= stockProductStore) {
      _productsCart[indexStore].products[indexProduct].amount = stockProductStore;
    } else if (_productsCart[indexStore].products[indexProduct].amount >= 999) {
      _productsCart[indexStore].products[indexProduct].amount = 999;
    } else {
      _productsCart[indexStore].products[indexProduct].amount += 1;
    }

    _cartBuyerHelper.setCartList(_productsCart);
    getCartList();
  }

  void decreaseAmount(int indexStore, int indexProduct) {
    if (_productsCart[indexStore].products[indexProduct].amount > 1) {
      _productsCart[indexStore].products[indexProduct].amount -= 1;

      _cartBuyerHelper.setCartList(_productsCart);
      getCartList();
    } else {
      removeProductFromCart(indexStore, indexProduct);
    }
  }

  void setTotalPrice() {
    _totalPrice = 0;
    _totalStorePrices.clear();

    if (_productsCart.isNotEmpty && _stores.isEmpty) {
      return;
    }

    for (var cart in _productsCart) {
      final searchStore = _stores.where((store) => store.id == cart.idStore).toList();

      if (searchStore.isNotEmpty) {
        int storePrices = 0;
        for (var product in cart.products) {
          storePrices += product.price * product.amount;
          _totalPrice += product.price * product.amount;
        }
        _totalStorePrices.add(storePrices);
      }
    }
  }

  Future<void> calculateShippingCost() async {
    _shippingCost.clear();
    final userLogin = await _preferencesHelper.getUserLogin;

    for (var cart in _productsCart) {
      final searchStore = _stores.where((store) => store.id == cart.idStore).toList();

      if (searchStore.isNotEmpty) {
        final store = searchStore.first;

        double distance = Geolocator.distanceBetween(
            double.parse(userLogin.latitude ?? "0.0"),
            double.parse(userLogin.longitude ?? "0.0"),
            store.address.latitude ?? 0,
            store.address.longitude ?? 0);

        int roundingDistance = distance.round();
        int shipping = 0;

        if (roundingDistance <= 100) {
          shipping = 1000;
        } else if (roundingDistance > 100 && roundingDistance <= 300) {
          shipping = 2000;
        } else if (roundingDistance > 300 && roundingDistance <= 500) {
          shipping = 3000;
        } else if (roundingDistance > 500 && roundingDistance <= 700) {
          shipping = 4000;
        } else {
          shipping = 5000;
        }

        _shippingCost.add(shipping);
      }
    }
  }

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }

  void changeStateStore(ResultState s) {
    _stateStore = s;
    notifyListeners();
  }
}
