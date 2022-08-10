import 'package:collection/collection.dart';
import 'package:e_warung/screen/seller/product/product_view_model.dart';
import 'package:e_warung/utils/result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/general_result.dart';
import '../../../data/preferences/preferences_helper.dart';
import '../../../utils/get_connection.dart';

class CartViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final _getConnection = GetConnection();

  final BuildContext context;
  CartViewModel({required this.context});

  int _indexTab = 0;
  int get indexTab => _indexTab;

  ResultState _stateTransaction = ResultState.none;
  ResultState get stateTransaction => _stateTransaction;

  final List<String> _cartBarcode = ["Nasi GOreng"];
  final List<int> _amountProduct = [1];
  final List<int> _totalPrice = [10000];

  List<String> get resultBarcode => _cartBarcode;
  List<int> get amountProduct => _amountProduct;
  List<int> get totalPrice => _totalPrice;

  Future<GeneralResult> fetchTransaction(int paid, int changeBill, List<Map> products) async {
    changeStateTransaction(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        changeStateTransaction(ResultState.hasData);
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await _apiService.saveTransaction(
            userLogin.id, userLogin.id, 0, totalPrice.sum, paid, changeBill, products);
        return result;
      } else {
        changeStateTransaction(ResultState.notConnected);
        return GeneralResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      changeStateTransaction(ResultState.error);
      return GeneralResult(status: false, message: "Transaction failed, $e");
    }
  }

  void addResultBarcode(String barcode) {
    if (_cartBarcode.contains(barcode)) {
      int index = _cartBarcode.indexOf(barcode);
      increaseAmount(index);
      setTotalPrice(index);
    } else {
      _cartBarcode.add(barcode);
      _amountProduct.add(1);
      _totalPrice.add(0);
    }

    notifyListeners();
  }

  void removeResultBarcode(int index) {
    _cartBarcode.removeAt(index);
    _amountProduct.removeAt(index);
    _totalPrice.removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    _cartBarcode.clear();
    _amountProduct.clear();
    _totalPrice.clear();
    notifyListeners();
  }

  void clear() {
    _cartBarcode.clear();
    _amountProduct.clear();
    _totalPrice.clear();
    notifyListeners();
  }

  void increaseAmount(int index) {
    final ProductViewModel productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    var id = resultBarcode[index];
    var dataProduct = productViewModel.products.where((element) => element.idProduk == id);
    if (_amountProduct[index] >= int.parse(dataProduct.first.stok)) {
      _amountProduct[index] = int.parse(dataProduct.first.stok);
    } else if (_amountProduct[index] >= 999) {
      _amountProduct[index] = 999;
    } else {
      _amountProduct[index] += 1;
    }
    notifyListeners();
  }

  void decreaseAmount(int index) {
    _amountProduct[index] -= 1;
    notifyListeners();
  }

  void changeAmount(int index, int value) {
    _amountProduct[index] = value;
    notifyListeners();
  }

  void setTotalPrice(int index) {
    final ProductViewModel productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    var id = resultBarcode[index];
    var dataProduct = productViewModel.products.where((element) => element.idProduk == id);
    _totalPrice[index] = _amountProduct[index] * int.parse(dataProduct.first.harga);
    notifyListeners();
  }

  void setIndexTabToOnlineOrder(int index) {
    _indexTab = index;
    notifyListeners();
  }

  void changeStateTransaction(ResultState s) {
    _stateTransaction = s;
    notifyListeners();
  }
}
