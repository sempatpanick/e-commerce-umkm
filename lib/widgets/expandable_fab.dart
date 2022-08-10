import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../common/styles.dart';
import '../data/model/form_product.dart';
import '../data/model/recommended_product_result.dart';
import '../screen/seller/product/product_view_model.dart';
import 'custom_alert_dialog.dart';
import 'custom_notification_snackbar.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({Key? key}) : super(key: key);

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _textIdProductController = TextEditingController();
  bool _isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: primaryColor,
      end: colorRed,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  animate() {
    if (!_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isOpened = !_isOpened;
  }

  Widget addProductBarcode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _isOpened
            ? Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: textColorBlue,
                  border: Border.all(color: textColorGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  "Add Product",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: textColorWhite, fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              )
            : Container(),
        FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            scanBarcodeNormal();
          },
          tooltip: 'Add Product',
          child: const Icon(Icons.document_scanner_outlined),
        ),
      ],
    );
  }

  Widget addProductManual() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _isOpened
            ? Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: textColorBlue,
                  border: Border.all(color: textColorGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  "Add Product Manually",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: textColorWhite, fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              )
            : Container(),
        FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Form(
                    key: formKey,
                    child: CustomAlertDialog(
                        title: Center(
                          child: Text(
                            "Add New Product",
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: textColorBlue, fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _textIdProductController,
                              decoration: const InputDecoration(
                                  labelText: "ID Product", border: OutlineInputBorder()),
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),
                        submit: () {
                          final isValid = formKey.currentState!.validate();

                          if (isValid) {
                            formKey.currentState!.save();
                            processAdd(_textIdProductController.text, "manual");
                          }
                        }),
                  );
                });
          },
          tooltip: 'Add stock',
          child: const Icon(Icons.onetwothree),
        ),
      ],
    );
  }

  Widget toggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: _buttonColor.value,
          onPressed: animate,
          tooltip: _isOpened ? 'Close Menu' : 'Open Menu',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animateIcon,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: addProductBarcode(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: addProductManual(),
        ),
        toggle(),
      ],
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes != "-1") {
      processAdd(barcodeScanRes, "scan");
    }
  }

  void processAdd(String idProduct, String type) async {
    final ProductViewModel productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    if (!productViewModel.products.any((element) => element.idProduk == idProduct)) {
      try {
        final Future<RecommendedProductResult> response =
            productViewModel.fetchRecommendedProduct(idProduct);

        response.then((value) {
          RecommendedProduct recommendedProduct =
              RecommendedProduct(id: idProduct, nama: "", keterangan: "", harga: "", gambar: "");
          FormProduct formProduct = FormProduct(title: "Add Product", type: "add_product");
          if (type == "manual") {
            setState(() {
              Navigator.pop(context);
            });
          }
          if (value.status) {
            setState(() {
              productViewModel.setIsFormInputProduct(true);
              productViewModel.setRecommendedProduct(value.data ?? recommendedProduct);
              productViewModel.setFormProduct(formProduct);
            });
            CustomNotificationSnackbar(
                context: context, message: "There are recommendations for the same product");
          } else {
            setState(() {
              productViewModel.setIsFormInputProduct(true);
              productViewModel.setRecommendedProduct(recommendedProduct);
              productViewModel.setFormProduct(formProduct);
            });
          }
        });
      } catch (e) {
        setState(() {
          productViewModel.setIsFormInputProduct(false);
        });

        CustomNotificationSnackbar(context: context, message: "Error : $e");
      }
    } else {
      setState(() {
        productViewModel.setIsFormInputProduct(false);
      });

      CustomNotificationSnackbar(
          context: context, message: "Produk tersebut sudah terdaftar di toko anda");
    }
  }

  @override
  dispose() {
    _textIdProductController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
