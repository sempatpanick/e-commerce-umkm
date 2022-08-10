import 'package:e_warung/screen/buyer/home/home_buyer_view_model.dart';
import 'package:e_warung/widgets/custom_item_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/styles.dart';

class HomeBuyerScreen extends StatefulWidget {
  const HomeBuyerScreen({Key? key}) : super(key: key);

  @override
  State<HomeBuyerScreen> createState() => _HomeBuyerScreenState();
}

class _HomeBuyerScreenState extends State<HomeBuyerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: Consumer<HomeBuyerViewModel>(builder: (context, model, child) {
        return ListView.builder(
            itemCount: model.stores.length,
            itemBuilder: (context, index) {
              final store = model.stores[index];

              return CustomItemStore(
                store: store,
              );
            });
      }),
    );
  }
}
