import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/result_state.dart';
import '../../../widgets/custom_item_history_transaction.dart';
import '../../../widgets/custom_notification_widget.dart';
import 'history_transaction_view_model.dart';

class HistoryTransactionScreen extends StatelessWidget {
  const HistoryTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final HistoryTransactionViewModel historyTransactionViewModel =
            Provider.of<HistoryTransactionViewModel>(context, listen: false);
        await historyTransactionViewModel.fetchHistoryTransaction();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Consumer<HistoryTransactionViewModel>(builder: (context, model, child) {
          if (model.state == ResultState.loading) {
            return SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          } else if (model.state == ResultState.noData) {
            return const SizedBox(
                height: 50,
                child: CustomNotificationWidget(message: "Tidak ada history transaksi"));
          } else if (model.state == ResultState.notConnected) {
            return const SizedBox(
                height: 50, child: CustomNotificationWidget(message: "Tidak ada koneksi internet"));
          } else if (model.state == ResultState.error) {
            return const SizedBox(
                height: 50, child: CustomNotificationWidget(message: "Terjadi kesalahan.."));
          } else if (model.state == ResultState.none) {
            return const SizedBox(
                height: 50, child: CustomNotificationWidget(message: "Not initialized"));
          }

          var dataTransactions = model.transactions;
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataTransactions.length,
              itemBuilder: (context, index) {
                return CustomItemHistoryTransaction(dataTransaction: dataTransactions[index]);
              });
        }),
      ),
    );
  }
}
