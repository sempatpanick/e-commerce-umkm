import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/styles.dart';
import '../data/model/form_product.dart';
import '../data/model/products_user_result.dart';
import '../data/model/recommended_product_result.dart';
import '../screen/seller/cart/cart_view_model.dart';
import '../screen/seller/product/product_view_model.dart';
import '../utils/get_formatted.dart';
import 'custom_alert_dialog.dart';
import 'custom_notification_snackbar.dart';

class CustomItemProduct extends StatefulWidget {
  final int index;
  final Products product;
  final ProductViewModel productViewModel;
  const CustomItemProduct(
      {Key? key, required this.index, required this.product, required this.productViewModel})
      : super(key: key);

  @override
  State<CustomItemProduct> createState() => _CustomItemProductState();
}

class _CustomItemProductState extends State<CustomItemProduct> {
  bool _isLoadingDelete = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FormProduct formProduct = FormProduct(title: "Update Product", type: "update_product");
        RecommendedProduct recommendedProduct = RecommendedProduct(
            id: widget.product.idProduk,
            nama: widget.product.nama,
            keterangan: widget.product.keterangan,
            harga: widget.product.harga,
            stok: widget.product.stok,
            gambar: widget.product.gambar ?? "");
        widget.productViewModel.setIsFormInputProduct(true);
        widget.productViewModel.setRecommendedProduct(recommendedProduct);
        widget.productViewModel.setFormProduct(formProduct);
      },
      child: Container(
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: textColorWhite, borderRadius: BorderRadius.circular(30.0)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: primaryColor,
                  ),
                  child: widget.product.gambar != null
                      ? widget.product.gambar != ""
                          ? Image.network(
                              "https://e-warung.my.id/assets/users/${widget.product.gambar}",
                              fit: BoxFit.fill,
                              errorBuilder:
                                  (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 70.0,
                                  color: textColorWhite,
                                );
                              },
                              loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                          : const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 50,
                            )
                      : const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        widget.product.nama,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: textColorBlue, fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      AutoSizeText(
                        "Rp. ${GetFormatted.number(int.parse(widget.product.harga != "" ? widget.product.harga : "0"))}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: textFieldColorGrey, fontSize: 15.0),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          AutoSizeText(
                            "Qty:",
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: textColorBlue, fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          AutoSizeText(
                            GetFormatted.number(
                                int.parse(widget.product.stok != "" ? widget.product.stok : "0")),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: textFieldColorGrey, fontSize: 15.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    verticalDirection: VerticalDirection.up,
                    children: [
                      Tooltip(
                        message: "Add to cart",
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            primary: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              final CartViewModel cartViewModel =
                                  Provider.of<CartViewModel>(context, listen: false);
                              cartViewModel.addResultBarcode(widget.product.idProduk);
                              CustomNotificationSnackbar(
                                  context: context,
                                  message: "${widget.product.nama} has added to cart");
                            });
                          },
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 20.0,
                            color: textColorWhite,
                          ),
                        ),
                      ),
                      Tooltip(
                        message: "Remove product from store",
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            primary: colorRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                      title: Center(
                                        child: Text(
                                          "Remove Product",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorBlue,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      content: Text(
                                        "Are you sure to remove this product from your store?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(color: colorBlack, fontSize: 14.0),
                                      ),
                                      submit: () async {
                                        setState(() {
                                          _isLoadingDelete = true;
                                        });

                                        final result = await widget.productViewModel
                                            .deleteProductById(widget.product.idProduk);
                                        setState(() {
                                          _isLoadingDelete = false;
                                        });
                                        CustomNotificationSnackbar(
                                            context: context, message: result.message);
                                        Navigator.pop(context);
                                      });
                                });
                          },
                          child: const Icon(
                            Icons.highlight_remove,
                            size: 20.0,
                            color: textColorWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isLoadingDelete
                ? Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: const LinearProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
