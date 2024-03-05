import 'dart:ui';

import 'package:e_warung/common/styles.dart';
import 'package:e_warung/data/model/cart_buyer_model.dart';
import 'package:e_warung/data/model/list_store_result.dart';
import 'package:e_warung/screen/buyer/cart/cart_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/detail_store/detail_store_buyer_view_model.dart';
import 'package:e_warung/utils/get_formatted.dart';
import 'package:e_warung/widgets/custom_notification_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/result_state.dart';
import '../../../widgets/custom_image_dialog.dart';

class DetailStoreBuyerScreen extends StatefulWidget {
  static const String routeName = '/detail_store_buyer';
  final Store store;
  const DetailStoreBuyerScreen({Key? key, required this.store})
      : super(key: key);

  @override
  State<DetailStoreBuyerScreen> createState() => _DetailStoreBuyerScreenState();
}

class _DetailStoreBuyerScreenState extends State<DetailStoreBuyerScreen> {
  @override
  void initState() {
    final DetailStoreBuyerViewModel detailStoreBuyerViewModel =
        Provider.of<DetailStoreBuyerViewModel>(context, listen: false);
    detailStoreBuyerViewModel.setIsExpandableAppBar(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final DetailStoreBuyerViewModel detailStoreBuyerViewModel =
          Provider.of<DetailStoreBuyerViewModel>(context, listen: false);

      detailStoreBuyerViewModel.fetchProductStore(widget.store.id);
    });
    super.didChangeDependencies();
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
                  automaticallyImplyLeading: true,
                  floating: true,
                  pinned: true,
                  snap: true,
                  expandedHeight: 200,
                  flexibleSpace: Consumer<DetailStoreBuyerViewModel>(
                      builder: (context, model, child) {
                    return LayoutBuilder(builder: (context, constraints) {
                      if (constraints.biggest.height <= 60) {
                        model.setIsExpandableAppBar(false);
                      } else {
                        model.setIsExpandableAppBar(true);
                      }
                      return FlexibleSpaceBar(
                        title: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Text(
                            widget.store.name!,
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: model.isExpandableAppBar
                                          ? Colors.white
                                          : colorMenu,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        background: Image.network(
                          widget.store.image ??
                              "https://mmc.tirto.id/image/otf/500x0/2021/03/16/header-src_ratio-16x9.jpeg",
                          fit: BoxFit.cover,
                        ),
                      );
                    });
                  }),
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: colorMenu,
                    ),
                  ),
                )
              ],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Produk",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: colorMenu,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const Divider(
                  color: primaryColor,
                ),
                Consumer<DetailStoreBuyerViewModel>(
                    builder: (context, model, child) {
                  if (model.stateProduct == ResultState.none) {
                    return const SizedBox();
                  }
                  if (model.stateProduct == ResultState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (model.stateProduct == ResultState.notConnected) {
                    return const Center(
                      child: Text("Tidak ada koneksi internet"),
                    );
                  }
                  if (model.stateProduct == ResultState.noData) {
                    return const Center(
                      child: Text("Tidak ada produk pada toko ini"),
                    );
                  }
                  if (model.stateProduct == ResultState.error) {
                    return const Center(
                      child: Text("Terjadi kesahalan"),
                    );
                  }
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: model.products.length,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        final product = model.products[index];

                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              product.image != null
                                  ? GestureDetector(
                                      onTap: () => showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CustomImageDialog(
                                                  image: product.image!)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            20), // Image border
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(
                                              35), // Image radius
                                          child: Image.network(
                                            "https://e-warung.my.id/assets/users/${product.image!}",
                                            fit: BoxFit.fill,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Container(
                                                width: 35,
                                                height: 35,
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                decoration: const BoxDecoration(
                                                    color: primaryColor),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 40.0,
                                                    color: textColorWhite,
                                                  ),
                                                ),
                                              );
                                            },
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 35,
                                      height: 35,
                                      decoration: const BoxDecoration(
                                          color: primaryColor),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40.0,
                                          color: textColorWhite,
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontSize: 13,
                                              color: colorBlack,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: product.description !=
                                                  null &&
                                              product.description!.isNotEmpty
                                          ? MainAxisAlignment.spaceBetween
                                          : MainAxisAlignment.end,
                                      children: [
                                        if (product.description != null &&
                                            product.description!.isNotEmpty)
                                          Expanded(
                                            child: Text(
                                              product.description!,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    fontSize: 11,
                                                    color: colorGreyBlack,
                                                  ),
                                            ),
                                          ),
                                        Text(
                                          "Sisa: ${GetFormatted.number(product.stock)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                fontSize: 11,
                                                color: colorGreyBlack,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            GetFormatted.number(product.price),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontSize: 11,
                                                    color: colorBlack,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        OutlinedButton(
                                            onPressed: () {
                                              final CartBuyerViewModel
                                                  cartBuyerViewModel = Provider
                                                      .of<CartBuyerViewModel>(
                                                          context,
                                                          listen: false);
                                              final productCart = ProductCart(
                                                  idProduct: product.idProduct,
                                                  price: product.price,
                                                  amount: 1,
                                                  description: "");
                                              cartBuyerViewModel
                                                  .addProductToCart(
                                                      widget.store.id,
                                                      productCart);
                                              CustomNotificationSnackbar(
                                                  context: context,
                                                  message:
                                                      "Produk telah ditambahkan ke keranjang");
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: primaryColor),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                            ),
                                            child: Text(
                                              "Tambah",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      fontSize: 11,
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                })
              ],
            ),
          )),
    );
  }
}
