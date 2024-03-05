import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:e_warung/screen/seller/online_order/online_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/styles.dart';
import '../../../data/model/general_result.dart';
import '../../../data/model/product_transaction.dart';
import '../../../data/model/products_user_result.dart';
import '../../../utils/get_formatted.dart';
import '../../../utils/result_state.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_item_cart.dart';
import '../../../widgets/custom_notification_snackbar.dart';
import '../../history_transaction/history_transaction_screen.dart';
import '../../history_transaction/history_transaction_view_model.dart';
import '../home/home_view_model.dart';
import '../product/product_view_model.dart';
import 'cart_view_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  final TextEditingController _textPaidController = TextEditingController();

  bool _isLoadingProduct = true;

  void checkout() {
    showDialog(
        context: context,
        builder: (context) {
          final CartViewModel cartViewModel =
              Provider.of<CartViewModel>(context, listen: false);

          return Form(
            key: _formKey,
            child: CustomAlertDialog(
                title: Center(
                  child: Text(
                    "Checkout",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: textColorBlue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _textPaidController,
                      decoration: const InputDecoration(
                          labelText: "Money", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (int.parse(value!) < cartViewModel.totalPrice.sum) {
                          return "money is not enough";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (_) {
                        _formKey.currentState!.validate();
                      },
                    ),
                  ],
                ),
                submit: () {
                  final isValid = _formKey.currentState!.validate();

                  if (isValid) {
                    _formKey.currentState!.save();
                    transaction();

                    Navigator.pop(context);
                  }
                }),
          );
        });
  }

  void transaction() async {
    try {
      final HomeViewModel homeViewModel =
          Provider.of<HomeViewModel>(context, listen: false);
      final ProductViewModel productViewModel =
          Provider.of<ProductViewModel>(context, listen: false);
      final CartViewModel cartViewModel =
          Provider.of<CartViewModel>(context, listen: false);
      final HistoryTransactionViewModel historyTransactionViewModel =
          Provider.of<HistoryTransactionViewModel>(context, listen: false);

      int paid = int.parse(_textPaidController.text);
      int chargeBack = paid - cartViewModel.totalPrice.sum;
      List<Map<String, dynamic>> listProduct = [];

      cartViewModel.resultBarcode.asMap().forEach((index, element) {
        var dataProduct = productViewModel.products
            .where((product) => product.idProduk == element);
        listProduct.add(ProductTransaction(
                idProduct: element,
                amount: cartViewModel.amountProduct[index],
                price: int.parse(dataProduct.first.harga))
            .toJson());
      });

      final Future<GeneralResult> responseProducts =
          cartViewModel.fetchTransaction(paid, chargeBack, listProduct);
      responseProducts.then((value) {
        if (value.status) {
          homeViewModel.fetchSummaryStore();
          productViewModel.fetchProductUser();
          historyTransactionViewModel.fetchHistoryTransaction();
          cartViewModel.clear();

          CustomNotificationSnackbar(context: context, message: value.message);
        } else {
          CustomNotificationSnackbar(context: context, message: value.message);
        }
      });
    } catch (e) {
      CustomNotificationSnackbar(context: context, message: "Error : $e");
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final CartViewModel cartViewModel =
          Provider.of<CartViewModel>(context, listen: false);

      if (cartViewModel.indexTab != 0) {
        _tabController.animateTo(cartViewModel.indexTab);
        cartViewModel.setIndexTabToOnlineOrder(0);
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textPaidController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            labelColor: textColorWhite,
            indicatorColor: textColorWhite,
            unselectedLabelColor: Colors.white54,
            isScrollable: true,
            tabs: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Tab(text: 'Cart'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Tab(
                  text: "Online Order",
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Tab(
                  text: "History Transaction",
                ),
              )
            ]),
        body: Container(
          color: colorWhiteBlue,
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Consumer2<CartViewModel, ProductViewModel>(
                    builder: (context, modelCart, modelProduct, child) {
                  return Container(
                    margin: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        modelCart.stateTransaction == ResultState.loading
                            ? const LinearProgressIndicator()
                            : Container(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: modelCart.resultBarcode.length,
                          itemBuilder: (context, index) {
                            var id = modelCart.resultBarcode[index];
                            var dataProduct = modelProduct.products
                                .where((element) => element.idProduk == id);
                            if (dataProduct.isNotEmpty) {
                              final Products product = Products(
                                  id: dataProduct.first.id,
                                  idUsers: dataProduct.first.idUsers,
                                  idProduk: dataProduct.first.idProduk,
                                  nama: dataProduct.first.nama,
                                  keterangan: dataProduct.first.keterangan,
                                  harga: dataProduct.first.harga,
                                  stok: dataProduct.first.stok,
                                  gambar: dataProduct.first.gambar);
                              _isLoadingProduct = false;
                              return _isLoadingProduct
                                  ? const SizedBox(
                                      height: 70.0,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ))
                                  : CustomItemCart(
                                      index: index, product: product);
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  "Total",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: primaryColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                ),
                                AutoSizeText(
                                  "Rp. ${GetFormatted.number(modelCart.totalPrice.sum)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: colorBlack,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: modelCart.resultBarcode.isEmpty
                                  ? null
                                  : modelCart.stateTransaction ==
                                          ResultState.loading
                                      ? null
                                      : () {
                                          checkout();
                                        },
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: modelCart.stateTransaction ==
                                        ResultState.loading
                                    ? Colors.transparent
                                    : textColorWhite,
                              ),
                              label: modelCart.stateTransaction ==
                                      ResultState.loading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      "Checkout",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: textColorWhite,
                                              fontSize: 17.0),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const OnlineOrderScreen(),
              const HistoryTransactionScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
