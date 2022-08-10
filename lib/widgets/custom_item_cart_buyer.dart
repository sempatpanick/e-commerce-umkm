import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_warung/data/model/list_store_result.dart';
import 'package:e_warung/screen/buyer/cart/cart_buyer_view_model.dart';
import 'package:e_warung/widgets/custom_image_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../common/styles.dart';
import '../utils/get_formatted.dart';

class CustomItemCartBuyer extends StatefulWidget {
  final int indexStore;
  final int indexProduct;
  final ProductStore itemProduct;
  const CustomItemCartBuyer(
      {Key? key, required this.indexStore, required this.indexProduct, required this.itemProduct})
      : super(key: key);

  @override
  State<CustomItemCartBuyer> createState() => _CustomItemCartBuyerState();
}

class _CustomItemCartBuyerState extends State<CustomItemCartBuyer> {
  final TextEditingController _valueTextController = TextEditingController();

  @override
  void dispose() {
    _valueTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartBuyerViewModel>(builder: (context, model, child) {
      _valueTextController.text =
          model.productsCart[widget.indexStore].products[widget.indexProduct].amount.toString();

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: primaryColor,
              ),
              child: widget.itemProduct.image != null
                  ? widget.itemProduct.image != ""
                      ? GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  CustomImageDialog(image: widget.itemProduct.image!)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20), // Image border
                            child: SizedBox.fromSize(
                                size: const Size.fromRadius(48), // Image radius
                                child: Image.network(
                                  "https://e-warung.my.id/assets/users/${widget.itemProduct.image}",
                                  fit: BoxFit.fill,
                                  errorBuilder: (BuildContext context, Object exception,
                                      StackTrace? stackTrace) {
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
                                )),
                          ),
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
              width: 8.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.itemProduct.name,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: textColorBlue, fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  AutoSizeText(
                    "Rp. ${GetFormatted.number(widget.itemProduct.price)}",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: colorGreyBlack, fontSize: 11.0),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  AutoSizeText(
                    "Sisa: ${GetFormatted.number(widget.itemProduct.stock)}",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: 11,
                          color: colorGreyBlack,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        model.decreaseAmount(widget.indexStore, widget.indexProduct);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: textColorGrey,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "-",
                            style: TextStyle(
                              color: colorBlack,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.symmetric(
                          horizontal: BorderSide(color: textColorGrey),
                        ),
                      ),
                      child: Center(
                          child: TextField(
                        controller: _valueTextController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        readOnly: true,
                        decoration: const InputDecoration(counterText: ''),
                        onSubmitted: (value) {},
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        model.increaseAmount(
                            widget.indexStore, widget.indexProduct, widget.itemProduct);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: textColorGrey,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "+",
                            style: TextStyle(
                              color: colorBlack,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    model.removeProductFromCart(widget.indexStore, widget.indexProduct);
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: colorRed,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
