import 'package:e_warung/screen/auth/auth_view_model.dart';
import 'package:e_warung/screen/buyer/cart/cart_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/home/home_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/transaction/transaction_buyer_screen.dart';
import 'package:e_warung/screen/profile_location/profile_location_screen.dart';
import 'package:e_warung/screen/profile_update/profile_update_view_model.dart';
import 'package:e_warung/utils/get_formatted.dart';
import 'package:e_warung/utils/result_state.dart';
import 'package:e_warung/widgets/custom_item_cart_buyer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../common/styles.dart';

class CartBuyerScreen extends StatefulWidget {
  const CartBuyerScreen({Key? key}) : super(key: key);

  @override
  State<CartBuyerScreen> createState() => _CartBuyerScreenState();
}

class _CartBuyerScreenState extends State<CartBuyerScreen> {
  @override
  void initState() {
    final CartBuyerViewModel cartBuyerViewModel =
        Provider.of<CartBuyerViewModel>(context, listen: false);

    cartBuyerViewModel.getCartList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            title: Text(
              "Cart",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: colorMenu,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        ],
        body: Stack(
          children: [
            Consumer2<CartBuyerViewModel, HomeBuyerViewModel>(
                builder: (context, modelCart, modelHome, child) {
              modelCart.setStores(modelHome.stores);
              if (modelCart.state == ResultState.loading &&
                  modelCart.stateStore == ResultState.loading) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (modelCart.productsCart.isNotEmpty &&
                  modelCart.totalStorePrices.isEmpty &&
                  modelCart.shippingCost.isEmpty) {
                return const SizedBox();
              }

              return ListView.builder(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 68.0),
                  itemCount: modelCart.productsCart.length,
                  itemBuilder: (context, index) {
                    final stores = modelHome.stores
                        .where((store) => store.id == modelCart.productsCart[index].idStore);
                    if (stores.isNotEmpty) {
                      final store = stores.first;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(25.0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/market.svg',
                                    color: colorMenu,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    store.name ?? "",
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                          color: colorMenu,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: modelCart.productsCart[index].products.length,
                                separatorBuilder: (context, index) => const Divider(),
                                itemBuilder: (context, indexProduct) {
                                  final itemProducts = store.products.where((product) =>
                                      product.idProduct ==
                                      modelCart
                                          .productsCart[index].products[indexProduct].idProduct);
                                  if (itemProducts.isNotEmpty) {
                                    final itemProduct = itemProducts.first;
                                    return CustomItemCartBuyer(
                                        indexStore: index,
                                        indexProduct: indexProduct,
                                        itemProduct: itemProduct);
                                  } else {
                                    return const SizedBox();
                                  }
                                }),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Total: Rp. ${GetFormatted.number(modelCart.totalStorePrices[index])}",
                                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                          color: textColorBlue,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  });
            }),
            Consumer<CartBuyerViewModel>(builder: (context, model, child) {
              if (model.productsCart.isNotEmpty) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      final CartBuyerViewModel cartBuyerViewModel =
                          Provider.of<CartBuyerViewModel>(context, listen: false);
                      final AuthViewModel authViewModel =
                          Provider.of<AuthViewModel>(context, listen: false);
                      if (authViewModel.userLogin.alamat!.isNotEmpty) {
                        await cartBuyerViewModel.calculateShippingCost();
                      }
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                        ),
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) {
                            return SingleChildScrollView(
                              child: Consumer4<CartBuyerViewModel, HomeBuyerViewModel,
                                  AuthViewModel, ProfileUpdateViewModel>(
                                builder: (context, modelCart, modelHome, modelAuth,
                                    modelProfileUpdate, child) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0, bottom: 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                            child: Icon(
                                          Icons.drag_handle,
                                          color: colorGreyBlack,
                                          size: 35,
                                          shadows: [
                                            Shadow(
                                                color: textFieldColorGrey,
                                                offset: Offset(1, 1),
                                                blurRadius: 5)
                                          ],
                                        )),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Alamat",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
                                                      .copyWith(
                                                          color: colorBlack,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  modelAuth.userLogin.alamat!.isNotEmpty
                                                      ? modelAuth.userLogin.alamat!
                                                      : "Alamat belum ditentukan",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
                                                      .copyWith(
                                                        color: colorBlack,
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                              ],
                                            )),
                                            OutlinedButton(
                                              onPressed: () async {
                                                final AuthViewModel authViewModel =
                                                    Provider.of<AuthViewModel>(context,
                                                        listen: false);
                                                final ProfileUpdateViewModel
                                                    profileUpdateViewModel =
                                                    Provider.of<ProfileUpdateViewModel>(context,
                                                        listen: false);

                                                var result = await Navigator.pushNamed(
                                                    context, ProfileLocationScreen.routeName);
                                                final Map? address = result as Map?;

                                                if (address != null) {
                                                  final update = await profileUpdateViewModel
                                                      .updateProfileAddress(
                                                    address['address'] ?? "",
                                                    address['latitude'] ?? 0.0,
                                                    address['longitude'] ?? 0.0,
                                                  );

                                                  if (update.status) {
                                                    await authViewModel.getUserFromPreferences();
                                                    if (authViewModel
                                                        .userLogin.alamat!.isNotEmpty) {
                                                      await cartBuyerViewModel
                                                          .calculateShippingCost();
                                                    }
                                                  }
                                                }
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(color: primaryColor)),
                                              child: Text(
                                                "Ganti",
                                                style:
                                                    Theme.of(context).textTheme.subtitle1!.copyWith(
                                                          color: primaryColor,
                                                          fontSize: 12.0,
                                                        ),
                                              ),
                                            )
                                          ],
                                        ),
                                        if (modelProfileUpdate.stateAddress == ResultState.loading)
                                          const LinearProgressIndicator(),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          "Ringkasan Pembayaran",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                                color: colorBlack,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        if (modelAuth.userLogin.alamat!.isEmpty)
                                          Center(
                                            child: Text(
                                              "Tidak dapat menampilkan ringkasan pembayaran, pastikan alamat sudah ada",
                                              textAlign: TextAlign.center,
                                              style:
                                                  Theme.of(context).textTheme.subtitle2!.copyWith(
                                                        color: colorGreyBlack,
                                                        fontSize: 12.0,
                                                      ),
                                            ),
                                          ),
                                        if (modelAuth.userLogin.alamat!.isNotEmpty)
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(16.0),
                                            itemCount: modelCart.productsCart.length,
                                            separatorBuilder: (context, index) => const Divider(),
                                            itemBuilder: (context, index) {
                                              final idStore = modelCart.productsCart[index].idStore;
                                              final searchStore = modelHome.stores
                                                  .where((store) => store.id == idStore)
                                                  .toList();

                                              if (searchStore.isEmpty) {
                                                return const SizedBox();
                                              }
                                              final totalProductsPrice =
                                                  modelCart.totalStorePrices[index];
                                              final shippingCost = modelCart.shippingCost[index];
                                              final totalStorePrice =
                                                  totalProductsPrice + shippingCost;
                                              final store = searchStore.first;

                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          store.name ?? "",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                  color: colorBlack,
                                                                  fontSize: 12.0,
                                                                  fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          GetFormatted.number(totalProductsPrice),
                                                          textAlign: TextAlign.end,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                  color: colorBlack,
                                                                  fontSize: 12.0,
                                                                  fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "Ongkos Kirim",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                color: colorBlack,
                                                                fontSize: 12.0,
                                                              ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          GetFormatted.number(shippingCost),
                                                          textAlign: TextAlign.end,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                  color: colorBlack,
                                                                  fontSize: 12.0,
                                                                  fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "Total",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                color: colorBlack,
                                                                fontSize: 12.0,
                                                              ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          GetFormatted.number(totalStorePrice),
                                                          textAlign: TextAlign.end,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                  color: colorBlack,
                                                                  fontSize: 12.0,
                                                                  fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "Pembayaran",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                color: colorBlack,
                                                                fontSize: 12.0,
                                                              ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.all(4.0),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 2, color: textColorBlue)),
                                                        child: Text(
                                                          "COD (Cash)",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .copyWith(
                                                                color: textColorBlue,
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: modelAuth.userLogin.alamat!.isEmpty
                                                ? null
                                                : () {
                                                    Navigator.pop(context);
                                                    Navigator.pushNamed(
                                                        context, TransactionBuyerScreen.routeName);
                                                  },
                                            style: ElevatedButton.styleFrom(
                                                primary: primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25))),
                                            child: Text("Pesan Sekarang",
                                                style:
                                                    Theme.of(context).textTheme.subtitle1!.copyWith(
                                                          color: textColorWhite,
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryColor, colorMenu],
                          ),
                          borderRadius: BorderRadius.circular(35)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Icon(
                                Icons.shopping_basket_outlined,
                                color: textColorWhite,
                                shadows: [
                                  Shadow(
                                      color: textColorWhite, offset: Offset(-1, -1), blurRadius: 5),
                                  Shadow(
                                      color: textColorWhite, offset: Offset(1, 1), blurRadius: 5),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                child: Text(
                                  GetFormatted.number(model.totalPrice),
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: textColorWhite,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(right: 12.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: textColorWhite,
                                shadows: [
                                  Shadow(
                                      color: textColorWhite, offset: Offset(-1, -1), blurRadius: 5),
                                  Shadow(
                                      color: textColorWhite, offset: Offset(1, 1), blurRadius: 5),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            })
          ],
        ),
      ),
    );
  }
}
