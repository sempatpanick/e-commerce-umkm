import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/styles.dart';
import '../../../data/model/products_user_result.dart';
import '../../../widgets/custom_item_product.dart';
import '../../../widgets/expandable_fab.dart';
import 'product_form_page.dart';
import 'product_view_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isSearch = false;
  List<Products> listSearch = [];
  late Products product;

  final TextEditingController _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () {
          Provider.of<ProductViewModel>(context, listen: false)
              .fetchProductUser();
        });
      },
      child: Scaffold(
        backgroundColor: colorWhiteBlue,
        floatingActionButton: const ExpandableFab(),
        body: Consumer<ProductViewModel>(builder: (context, model, child) {
          if (model.isFormInputProduct) {
            return ProductFormPage(
              productViewModel: model,
            );
          } else {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 24.0, top: 24.0, right: 24.0, bottom: 60.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _searchTextController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: textFieldColorGrey,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Search..',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 20,
                            color: textFieldColorGrey,
                          ),
                        ),
                        onChanged: (value) {
                          if (value == "") {
                            setState(() {
                              _isSearch = false;
                            });
                          } else {
                            listSearch.clear();
                            listSearch.addAll(model.products.where((element) =>
                                element.nama
                                    .toLowerCase()
                                    .contains(value.toLowerCase())));
                            setState(() {
                              _isSearch = true;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _isSearch
                            ? listSearch.length
                            : model.products.length,
                        itemBuilder: (context, index) {
                          var product = _isSearch
                              ? listSearch[index]
                              : model.products[index];
                          return CustomItemProduct(
                            index: index,
                            product: product,
                            productViewModel: model,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
