import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../common/styles.dart';
import '../data/model/products_user_result.dart';
import '../screen/seller/cart/cart_view_model.dart';
import '../utils/get_formatted.dart';
import 'custom_image_dialog.dart';

class CustomItemCart extends StatefulWidget {
  final int index;
  final Products product;
  const CustomItemCart({
    Key? key,
    required this.index,
    required this.product,
  }) : super(key: key);

  @override
  State<CustomItemCart> createState() => _CustomItemCartState();
}

class _CustomItemCartState extends State<CustomItemCart> {
  final TextEditingController _valueTextController = TextEditingController();

  void calculatePrice() {
    final CartViewModel cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    cartViewModel.setTotalPrice(widget.index);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calculatePrice();
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _valueTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(builder: (context, model, child) {
      _valueTextController.text = model.amountProduct[widget.index].toString();
      return Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(color: textColorWhite, borderRadius: BorderRadius.circular(30.0)),
        child: Row(
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
                      ? GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  CustomImageDialog(image: widget.product.gambar!)),
                          child: Image.network(
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            final CartViewModel cartViewModel =
                                Provider.of<CartViewModel>(context, listen: false);

                            if (int.parse(_valueTextController.text) > 1) {
                              cartViewModel.decreaseAmount(widget.index);
                            } else if (_valueTextController.text.isEmpty) {
                              cartViewModel.changeAmount(widget.index, 1);
                            }
                            calculatePrice();
                          });
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
                          decoration: const InputDecoration(counterText: ''),
                          onSubmitted: (value) {
                            final CartViewModel cartViewModel =
                                Provider.of<CartViewModel>(context, listen: false);

                            if (isNumeric(value)) {
                              if (int.parse(value) < 1) {
                                cartViewModel.changeAmount(widget.index, 1);
                              } else if (int.parse(value) > int.parse(widget.product.stok)) {
                                cartViewModel.changeAmount(
                                    widget.index, int.parse(widget.product.stok));
                              } else {
                                cartViewModel.changeAmount(widget.index, int.parse(value));
                              }
                            } else {
                              cartViewModel.changeAmount(widget.index, 1);
                            }
                            calculatePrice();
                          },
                        )),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            final CartViewModel cartViewModel =
                                Provider.of<CartViewModel>(context, listen: false);

                            if (_valueTextController.text.isEmpty) {
                              cartViewModel.changeAmount(widget.index, 1);
                            } else {
                              cartViewModel.increaseAmount(widget.index);
                            }
                            calculatePrice();
                          });
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
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  onPressed: () {
                    final CartViewModel cartViewModel =
                        Provider.of<CartViewModel>(context, listen: false);

                    cartViewModel.removeResultBarcode(widget.index);
                  },
                  icon: const Icon(
                    Icons.remove_shopping_cart_outlined,
                    color: colorBlack,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
