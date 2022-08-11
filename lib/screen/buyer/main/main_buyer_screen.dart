import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_warung/common/key_app.dart';
import 'package:e_warung/screen/auth/auth_view_model.dart';
import 'package:e_warung/screen/buyer/home/home_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/order_status/order_status_screen.dart';
import 'package:e_warung/screen/buyer/order_status/order_status_view_model.dart';
import 'package:e_warung/screen/history_transaction/history_transaction_view_model.dart';
import 'package:e_warung/widgets/custom_notification_snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../common/styles.dart';
import '../../../data/model/login_result.dart';
import '../../profile/profile_screen.dart';
import '../cart/cart_buyer_screen.dart';
import '../home/home_buyer_screen.dart';
import 'main_buyer_view_model.dart';

class MainBuyerScreen extends StatefulWidget {
  static const routeName = '/buyer_main';
  const MainBuyerScreen({Key? key}) : super(key: key);

  @override
  State<MainBuyerScreen> createState() => _CartBuyerScreenState();
}

class _CartBuyerScreenState extends State<MainBuyerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  final autoSizeGroup = AutoSizeGroup();

  final List<IconData> _listIcon = [
    Icons.home_outlined,
    Icons.shopping_cart_outlined,
    Icons.shop_outlined,
    Icons.account_circle_outlined
  ];

  final List<Widget> _listWidget = [
    const HomeBuyerScreen(),
    const CartBuyerScreen(),
    const OrderStatusScreen(),
    const ProfileScreen()
  ];

  final List<String> _listMenu = ["Home", "Cart", "Order Status", "Profile"];

  @override
  void initState() {
    final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final MainBuyerViewModel mainBuyerViewModel =
        Provider.of<MainBuyerViewModel>(context, listen: false);
    final OrderStatusViewModel orderStatusViewModel =
        Provider.of<OrderStatusViewModel>(context, listen: false);
    final HistoryTransactionViewModel historyTransactionViewModel =
        Provider.of<HistoryTransactionViewModel>(context, listen: false);

    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: textColorWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    curve = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      const Duration(milliseconds: 500),
      () => _animationController.forward(),
    );

    FirebaseMessaging.instance.getToken(vapidKey: KeyApp.vapidKey).then((token) {
      if (token != null) {
        mainBuyerViewModel.updateTokenFCM(token);
      }
    });

    //on background (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final User userLogin = authViewModel.userLogin;
      if (userLogin.id.isNotEmpty) {
        if (message.data['redirect'] == 'order_status') {
          orderStatusViewModel.getOrderStatus();
          historyTransactionViewModel.fetchHistoryTransaction();
          mainBuyerViewModel.setIndexBottomNav(2);
        }
      }
    });

    //on foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final User userLogin = authViewModel.userLogin;
      if (userLogin.id.isNotEmpty) {
        if (message.data['redirect'] == 'order_status') {
          orderStatusViewModel.getOrderStatus();
          historyTransactionViewModel.fetchHistoryTransaction();
        }

        CustomNotificationSnackbar(
          context: context,
          message: message.notification?.body ?? "",
          actionLabel: message.data['redirect'] != null ? "Lihat" : null,
          action: () {
            if (message.data['redirect'] == 'order_status') {
              orderStatusViewModel.getOrderStatus();
              historyTransactionViewModel.fetchHistoryTransaction();
              mainBuyerViewModel.setIndexBottomNav(2);
            }
          },
        );
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final HomeBuyerViewModel homeBuyerViewModel =
          Provider.of<HomeBuyerViewModel>(context, listen: false);
      final OrderStatusViewModel orderStatusViewModel =
          Provider.of<OrderStatusViewModel>(context, listen: false);
      final HistoryTransactionViewModel historyTransactionViewModel =
          Provider.of<HistoryTransactionViewModel>(context, listen: false);

      homeBuyerViewModel.getListStore();
      orderStatusViewModel.getOrderStatus();
      historyTransactionViewModel.fetchHistoryTransaction();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainBuyerViewModel>(builder: (context, model, child) {
      return Scaffold(
        body: _listWidget[model.indexBottomNav],
        backgroundColor: colorWhiteBlue,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          backgroundColor: textColorWhite,
          itemCount: _listIcon.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? colorMenu : textFieldColorGrey;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _listIcon[index],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AutoSizeText(
                    _listMenu[index],
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: color, fontSize: 12.0),
                    group: autoSizeGroup,
                  ),
                ),
              ],
            );
          },
          gapLocation: GapLocation.none,
          splashColor: primaryColor,
          notchAndCornersAnimation: animation,
          notchSmoothness: NotchSmoothness.defaultEdge,
          splashSpeedInMilliseconds: 300,
          leftCornerRadius: 10,
          rightCornerRadius: 10,
          activeIndex: model.indexBottomNav,
          onTap: (index) => model.setIndexBottomNav(index),
        ),
      );
    });
  }
}
