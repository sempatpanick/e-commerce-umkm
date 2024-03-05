import 'package:e_warung/screen/history_transaction/history_transaction_view_model.dart';
import 'package:e_warung/screen/seller/online_order/online_order_view_model.dart';
import 'package:e_warung/widgets/custom_notification_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/styles.dart';
import '../data/model/online_order_model.dart';
import '../screen/map_location/map_location_screen.dart';
import '../screen/seller/home/home_view_model.dart';
import '../screen/seller/product/product_view_model.dart';
import '../utils/get_formatted.dart';

class CustomItemOnlineOrder extends StatefulWidget {
  const CustomItemOnlineOrder({
    Key? key,
    required this.onlineOrder,
  }) : super(key: key);

  final OnlineOrder onlineOrder;

  @override
  State<CustomItemOnlineOrder> createState() => _CustomItemOnlineOrderState();
}

class _CustomItemOnlineOrderState extends State<CustomItemOnlineOrder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textPaidController = TextEditingController();

  List<DataRow> listItem = [];
  bool _isLoadingUpdate = false;
  int _groupValue = 1;

  @override
  void dispose() {
    _textPaidController.dispose();

    super.dispose();
  }

  void _updateOrder() async {
    final NavigatorState navigator = Navigator.of(context);
    final HomeViewModel homeViewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    final ProductViewModel productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);
    final OnlineOrderViewModel onlineOrderViewModel =
        Provider.of<OnlineOrderViewModel>(context, listen: false);
    final HistoryTransactionViewModel historyTransactionViewModel =
        Provider.of<HistoryTransactionViewModel>(context, listen: false);

    int? paid;
    int? changeBill;

    if (_groupValue == 3) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      paid = int.parse(_textPaidController.text);
      changeBill = paid - widget.onlineOrder.bill;
    }
    navigator.pop();

    setState(() {
      _isLoadingUpdate = true;
    });

    final result = await onlineOrderViewModel.updateOnlineOrder(
        widget.onlineOrder.id, _groupValue, paid, changeBill);

    if (result.status) {
      homeViewModel.fetchSummaryStore();
      productViewModel.fetchProductUser();
      onlineOrderViewModel.getOnlineOrder();
      historyTransactionViewModel.fetchHistoryTransaction();
    }

    CustomNotificationSnackbar(context: context, message: result.message);

    setState(() {
      _isLoadingUpdate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    listItem.clear();
    int iteration = 1;

    for (var element in widget.onlineOrder.products) {
      listItem.add(
        DataRow(
          cells: [
            DataCell(Align(
                alignment: Alignment.centerLeft, child: Text("$iteration."))),
            DataCell(Text(element.name)),
            DataCell(Text("x${element.amount}")),
            DataCell(Align(
                alignment: Alignment.centerLeft,
                child: Text(GetFormatted.number(element.price)))),
          ],
        ),
      );
      iteration++;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
      decoration: BoxDecoration(
          color: textColorWhite, borderRadius: BorderRadius.circular(25.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Nama",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                      ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  widget.onlineOrder.buyer.name ?? "",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Alamat",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                      ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.onlineOrder.buyer.address.name,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: colorBlack,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    OutlinedButton(
                        onPressed: () => Navigator.pushNamed(
                                context, MapLocationScreen.routeName,
                                arguments: {
                                  "name": widget.onlineOrder.buyer.address.name,
                                  "latitude":
                                      widget.onlineOrder.buyer.address.latitude,
                                  "longitude":
                                      widget.onlineOrder.buyer.address.longitude
                                }),
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryColor)),
                        child: Text(
                          "Buka Map",
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: primaryColor,
                                    fontSize: 12.0,
                                  ),
                        ))
                  ],
                ),
              ),
            ],
          ),
          Text(
            "Items",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: colorBlack,
                  fontSize: 11.0,
                ),
          ),
          const SizedBox(
            height: 4,
          ),
          DataTable(
            columnSpacing: 5.0,
            headingRowHeight: 20,
            horizontalMargin: 10,
            showBottomBorder: true,
            columns: const [
              DataColumn(label: Text("No.")),
              DataColumn(label: Expanded(child: Text("Name"))),
              DataColumn(label: Text("Amount")),
              DataColumn(
                label: SizedBox(width: 66, child: Center(child: Text("Price"))),
              ),
            ],
            rows: listItem,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Harga",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                      ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  GetFormatted.number(widget.onlineOrder.bill -
                      widget.onlineOrder.shippingCost),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Ongkos Kirim",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                      ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  GetFormatted.number(widget.onlineOrder.shippingCost),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Status Pengiriman",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                      ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      color: widget.onlineOrder.status == 0
                          ? colorDashboardPurple
                          : widget.onlineOrder.status == 1
                              ? colorLinearEnd
                              : widget.onlineOrder.status == 2
                                  ? colorRed
                                  : colorDashboardGreen,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text(
                    widget.onlineOrder.status == 0
                        ? "Menunggu Perstujuan"
                        : widget.onlineOrder.status == 1
                            ? "Dalam Pengiriman"
                            : widget.onlineOrder.status == 2
                                ? "Ditolak"
                                : "Tela"
                                    "h Dikirim",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: textColorWhite,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Total",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                      ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  GetFormatted.number(widget.onlineOrder.bill),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: colorBlack,
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoadingUpdate
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color: colorBlack,
                                          fontSize: 12.0,
                                        ),
                                  ),
                                  RadioListTile(
                                    visualDensity: const VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    contentPadding: EdgeInsets.zero,
                                    groupValue: _groupValue,
                                    value: 1,
                                    onChanged: (value) {
                                      setState(() {
                                        _groupValue = value as int;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(
                                      "Dalam Pengiriman",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: colorBlack,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ),
                                  RadioListTile(
                                    visualDensity: const VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    contentPadding: EdgeInsets.zero,
                                    groupValue: _groupValue,
                                    value: 2,
                                    onChanged: (value) {
                                      setState(() {
                                        _groupValue = value as int;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(
                                      "Tolak Pengiriman",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: colorBlack,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ),
                                  RadioListTile(
                                    visualDensity: const VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    contentPadding: EdgeInsets.zero,
                                    groupValue: _groupValue,
                                    value: 3,
                                    onChanged: (value) {
                                      setState(() {
                                        _groupValue = value as int;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(
                                      "Telah Dikirim",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: colorBlack,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ),
                                  if (_groupValue == 3)
                                    Text(
                                      "Pembayaran",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: colorBlack,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  if (_groupValue == 3)
                                    TextFormField(
                                      controller: _textPaidController,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 16),
                                          labelText: "Money",
                                          border: OutlineInputBorder()),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (int.parse(value!) <
                                            widget.onlineOrder.bill) {
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
                            ),
                            contentPadding: const EdgeInsets.only(
                                top: 20.0, right: 20.0, left: 20.0),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: colorRed,
                                        fontSize: 12.0,
                                      ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _updateOrder(),
                                child: Text(
                                  "Update",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: primaryColor,
                                        fontSize: 12.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                "Proses",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: textColorWhite,
                      fontSize: 12.0,
                    ),
              ),
            ),
          ),
          if (_isLoadingUpdate) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
