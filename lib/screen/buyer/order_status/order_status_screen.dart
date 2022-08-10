import 'package:e_warung/common/styles.dart';
import 'package:e_warung/data/model/order_status_model.dart';
import 'package:e_warung/screen/buyer/order_status/order_status_view_model.dart';
import 'package:e_warung/utils/get_formatted.dart';
import 'package:e_warung/utils/result_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../history_transaction/history_transaction_screen.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({Key? key}) : super(key: key);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: TabBar(
            controller: _tabController,
            labelColor: textColorWhite,
            indicatorColor: textColorWhite,
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(
                text: "On Procces",
              ),
              Tab(
                text: "History Transaction",
              )
            ]),
        body: Container(
          color: colorWhiteBlue,
          child: TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  final OrderStatusViewModel orderStatusViewModel =
                      Provider.of<OrderStatusViewModel>(context, listen: false);
                  await orderStatusViewModel.getOrderStatus();
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Consumer<OrderStatusViewModel>(builder: (context, model, child) {
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
                      itemCount: model.orderStatus.length,
                      itemBuilder: (context, index) {
                        final OrderStatus orderStatus = model.orderStatus[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                              color: textColorWhite, borderRadius: BorderRadius.circular(25.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/market.svg',
                                      color: colorMenu,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        orderStatus.store.name ?? "",
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: colorMenu,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                            color: orderStatus.status == 0
                                                ? colorDashboardPurple
                                                : orderStatus.status == 1
                                                    ? colorLinearEnd
                                                    : orderStatus.status == 2
                                                        ? colorRed
                                                        : colorDashboardGreen,
                                            borderRadius: BorderRadius.circular(30.0)),
                                        child: Text(
                                          orderStatus.status == 0
                                              ? "Menunggu Perstujuan"
                                              : orderStatus.status == 1
                                                  ? "Dalam Pengiriman"
                                                  : orderStatus.status == 2
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
                              ),
                              const Divider(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * 0.2,
                                    vertical: 8.0),
                                child: Row(
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
                                        GetFormatted.number(
                                            orderStatus.bill - orderStatus.shippingCost),
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: colorBlack,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * 0.2,
                                    vertical: 8.0),
                                child: Row(
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
                                        GetFormatted.number(orderStatus.shippingCost),
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: colorBlack,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * 0.2,
                                    vertical: 8.0),
                                child: Row(
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
                                        GetFormatted.number(orderStatus.bill),
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: colorBlack,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              const HistoryTransactionScreen()
            ],
          ),
        ),
      ),
    );
  }
}
