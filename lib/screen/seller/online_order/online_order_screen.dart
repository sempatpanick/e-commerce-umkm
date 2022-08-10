import 'package:e_warung/common/styles.dart';
import 'package:e_warung/data/model/online_order_model.dart';
import 'package:e_warung/screen/seller/online_order/online_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/result_state.dart';
import '../../../widgets/custom_item_online_order.dart';

class OnlineOrderScreen extends StatefulWidget {
  const OnlineOrderScreen({Key? key}) : super(key: key);

  @override
  State<OnlineOrderScreen> createState() => _OnlineOrderScreenState();
}

class _OnlineOrderScreenState extends State<OnlineOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: RefreshIndicator(
        onRefresh: () async {
          final OnlineOrderViewModel onlineOrderViewModel =
              Provider.of<OnlineOrderViewModel>(context, listen: false);
          await onlineOrderViewModel.getOnlineOrder();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Consumer<OnlineOrderViewModel>(builder: (context, model, child) {
            if (model.state == ResultState.none) {
              return const SizedBox();
            }
            if (model.state == ResultState.noData) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Text(
                    "Tidak ada transaksi yang berjalan.",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: colorMenu,
                          fontSize: 15.0,
                        ),
                  ),
                ),
              );
            }
            if (model.state == ResultState.notConnected) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Text(
                    "Tidak ada koneksi internet",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: colorMenu,
                          fontSize: 15.0,
                        ),
                  ),
                ),
              );
            }
            if (model.state == ResultState.error) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Text(
                    "Terjadi kesalahan.",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: colorMenu,
                          fontSize: 15.0,
                        ),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: model.onlineOrder.length,
              itemBuilder: (context, index) {
                final OnlineOrder onlineOrder = model.onlineOrder[index];

                return CustomItemOnlineOrder(onlineOrder: onlineOrder);
              },
            );
          }),
        ),
      ),
    );
  }
}
