import 'package:e_warung/common/styles.dart';
import 'package:e_warung/data/model/cart_buyer_model.dart';
import 'package:e_warung/screen/buyer/cart/cart_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/home/home_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/main/main_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/transaction/transaction_buyer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../data/model/product_transaction.dart';
import '../../history_transaction/history_transaction_view_model.dart';
import '../order_status/order_status_view_model.dart';

class TransactionBuyerScreen extends StatefulWidget {
  static const String routeName = '/transaction_buyer';
  const TransactionBuyerScreen({Key? key}) : super(key: key);

  @override
  State<TransactionBuyerScreen> createState() => _TransactionBuyerScreenState();
}

class _TransactionBuyerScreenState extends State<TransactionBuyerScreen>
    with TickerProviderStateMixin {
  late AnimationController _successController;

  bool _isSuccess = false;

  void transaction() async {
    final MainBuyerViewModel mainBuyerViewModel =
        Provider.of<MainBuyerViewModel>(context, listen: false);
    final HomeBuyerViewModel homeBuyerViewModel =
        Provider.of<HomeBuyerViewModel>(context, listen: false);
    final CartBuyerViewModel cartBuyerViewModel =
        Provider.of<CartBuyerViewModel>(context, listen: false);
    final TransactionBuyerViewModel transactionBuyerViewModel =
        Provider.of<TransactionBuyerViewModel>(context, listen: false);
    final OrderStatusViewModel orderStatusViewModel =
        Provider.of<OrderStatusViewModel>(context, listen: false);
    final HistoryTransactionViewModel historyTransactionViewModel =
        Provider.of<HistoryTransactionViewModel>(context, listen: false);

    List<int> indexStoreSuccess = [];

    for (int i = 0; i < cartBuyerViewModel.productsCart.length; i++) {
      final CartBuyerModel cart = cartBuyerViewModel.productsCart[i];
      final searchStore =
          homeBuyerViewModel.stores.where((store) => store.id == cart.idStore).toList();

      if (searchStore.isNotEmpty) {
        final totalProductsPrice = cartBuyerViewModel.totalStorePrices[i];
        final shippingCost = cartBuyerViewModel.shippingCost[i];
        final totalStorePrice = totalProductsPrice + shippingCost;
        final store = searchStore.first;
        List<Map<String, dynamic>> listProduct = [];

        cart.products.asMap().forEach((index, element) {
          final searchProduct =
              store.products.where((product) => product.idProduct == element.idProduct).toList();

          if (searchProduct.isNotEmpty) {
            listProduct.add(ProductTransaction(
                    idProduct: "${element.idProduct}", amount: element.amount, price: element.price)
                .toJson());
          }
        });

        final result = await transactionBuyerViewModel.transaction(
            "${cart.idStore}", shippingCost, totalStorePrice, listProduct);

        if (result.status) {
          indexStoreSuccess.add(i);
        }
      }
    }
    homeBuyerViewModel.getListStore();
    cartBuyerViewModel.removeStoreFromCart(indexStoreSuccess);
    mainBuyerViewModel.setIndexBottomNav(2);
    await orderStatusViewModel.getOrderStatus();
    historyTransactionViewModel.fetchHistoryTransaction();

    setState(() {
      _isSuccess = true;
    });
  }

  @override
  void initState() {
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // _packagingController.addStatusListener((status) async {
    //
    //   if (status == AnimationStatus.completed) {
    //     setState(() {
    //       _isSuccess = true;
    //     });
    //   }
    // });

    _successController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      transaction();
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _successController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: SafeArea(
        child: Center(
          child: _isSuccess
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/json/lottie_success.json',
                      controller: _successController,
                      onLoaded: (composition) {
                        _successController.forward();
                      },
                      repeat: true,
                    ),
                    Text("Pesanan anda segera diproses",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: primaryColor,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            )),
                  ],
                )
              : Lottie.asset(
                  'assets/json/lottie_packaging.json',
                  repeat: true,
                ),
        ),
      ),
    );
  }
}
