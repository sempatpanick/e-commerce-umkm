import 'package:e_warung/common/styles.dart';
import 'package:e_warung/screen/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/get_formatted.dart';
import '../../../utils/result_state.dart';
import '../../../widgets/custom_item_news.dart';
import '../../../widgets/custom_notification_widget.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                ),
                Consumer<AuthViewModel>(builder: (context, model, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Welcome Back,\n",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.white, fontSize: 19.0),
                                  ),
                                  TextSpan(
                                    text: model.userLogin.nama != ""
                                        ? model.userLogin.nama ?? ""
                                        : model.userLogin.email,
                                    style: Theme.of(context).textTheme.headline6!.copyWith(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
                const SizedBox(
                  height: 50.0,
                ),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 210.0,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    color: colorWhiteBlue,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<HomeViewModel>(builder: (context, model, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Text(
                                "Orders",
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardRed,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Orders",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                GetFormatted.number(
                                                    model.summary?.totalOrders ?? 0),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardOrange,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Today Orders",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                GetFormatted.number(
                                                    model.summary?.todayOrders ?? 0),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardBlue,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Month Orders",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                GetFormatted.number(
                                                    model.summary?.monthOrders ?? 0),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardPurple,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Year Orders",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                GetFormatted.number(model.summary?.yearOrders ?? 0),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Text(
                                "Revenue",
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardPattern1,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Revenue",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                "Rp. ${GetFormatted.number(model.summary?.totalRevenue ?? 0)}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardPattern2,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Today Revenue",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                "Rp. ${GetFormatted.number(model.summary?.totalTodayRevenue ?? 0)}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardPattern3,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Month Revenue",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                "Rp. ${GetFormatted.number(model.summary?.totalMonthRevenue ?? 0)}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardPattern4,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Year Revenue",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                "Rp. ${GetFormatted.number(model.summary?.totalYearRevenue ?? 0)}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Text(
                                "Products",
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 90,
                                    padding: const EdgeInsets.all(16.0),
                                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    decoration: BoxDecoration(
                                        color: colorDashboardGreen,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Products",
                                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                              color: textColorWhite, fontWeight: FontWeight.bold),
                                        ),
                                        model.stateSummary != ResultState.hasData
                                            ? const Center(
                                                child: SizedBox(
                                                    width: 30,
                                                    height: 30,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                              )
                                            : Text(
                                                GetFormatted.number(
                                                    model.summary?.totalProducts ?? 0),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: textColorWhite,
                                                        fontWeight: FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Text(
                              "News",
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                    fontSize: 20.0,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Consumer<HomeViewModel>(builder: (context, model, _) {
                            if (model.stateNews == ResultState.none) {
                              return const SizedBox();
                            } else if (model.stateNews == ResultState.loading) {
                              return SizedBox(
                                  height: MediaQuery.of(context).size.height / 2,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ));
                            } else if (model.stateNews == ResultState.hasData) {
                              var dataNews = model.news;
                              return MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: dataNews.length,
                                    itemBuilder: (context, index) {
                                      return CustomItemNews(news: dataNews[index]);
                                    }),
                              );
                            } else if (model.stateNews == ResultState.noData) {
                              return const SizedBox(
                                  height: 50,
                                  child: CustomNotificationWidget(message: "Tidak ada berita"));
                            } else if (model.stateNews == ResultState.error) {
                              return const SizedBox(
                                  height: 50,
                                  child: CustomNotificationWidget(
                                      message: "Terjadi kesalahan saat mengambil data"));
                            } else {
                              return const SizedBox(
                                  height: 50,
                                  child: CustomNotificationWidget(
                                      message: "Error: Went Something Wrong.."));
                            }
                          })
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
