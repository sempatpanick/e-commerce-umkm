import 'package:flutter/material.dart';

import '../common/styles.dart';
import '../data/model/history_transaction_result.dart';
import '../utils/date_time_helper.dart';
import '../utils/get_formatted.dart';

class CustomItemHistoryTransaction extends StatelessWidget {
  final Transaction dataTransaction;
  const CustomItemHistoryTransaction({Key? key, required this.dataTransaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DataRow> listItem = [];
    int iteration = 1;

    for (var element in dataTransaction.items) {
      listItem.add(
        DataRow(
          cells: [
            DataCell(Align(alignment: Alignment.centerLeft, child: Text("$iteration."))),
            DataCell(Text(element.name)),
            DataCell(Text("x${element.amount}")),
            DataCell(Align(
                alignment: Alignment.centerLeft,
                child: Text(GetFormatted.number(int.parse(element.price))))),
          ],
        ),
      );
      iteration++;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(color: textColorWhite, borderRadius: BorderRadius.circular(30.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Transaction ID"),
              Text("#${dataTransaction.id}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Date Time"),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DateTimeHelper().dateFormat(dataTransaction.datetimeTransaction)),
                  Text(DateTimeHelper().timeFormat(dataTransaction.datetimeTransaction)),
                ],
              ),
            ],
          ),
          const Text("Items"),
          DataTable(
            columnSpacing: 5.0,
            headingRowHeight: 20,
            horizontalMargin: 10,
            columns: const [
              DataColumn(label: Text("No.")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Amount")),
              DataColumn(
                label: SizedBox(width: 66, child: Center(child: Text("Price"))),
              ),
            ],
            rows: listItem,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Price"),
              Text("Rp. ${GetFormatted.number(int.parse(dataTransaction.bill))}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Paid"),
              Text(dataTransaction.paid != null
                  ? "Rp. ${GetFormatted.number(int.parse(dataTransaction.paid!))}"
                  : "-")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Charge Back"),
              Text(dataTransaction.changeBill != null
                  ? "Rp. ${GetFormatted.number(int.parse(dataTransaction.changeBill!))}"
                  : "-")
            ],
          ),
        ],
      ),
    );
  }
}
