import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_warung/screen/profile/profile_screen.dart';
import 'package:e_warung/screen/seller/online_order/online_order_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../../../common/key_app.dart';
import '../../../common/styles.dart';
import '../../../data/model/login_result.dart';
import '../../../widgets/custom_notification_snackbar.dart';
import '../../auth/auth_view_model.dart';
import '../../history_transaction/history_transaction_view_model.dart';
import '../cart/cart_screen.dart';
import '../cart/cart_view_model.dart';
import '../home/home_screen.dart';
import '../home/home_view_model.dart';
import '../product/product_screen.dart';
import '../product/product_view_model.dart';
import 'main_view_model.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  final autoSizeGroup = AutoSizeGroup();

  final List<IconData> _listIcon = [
    Icons.home_outlined,
    Icons.text_snippet_outlined,
    Icons.shopping_cart_outlined,
    Icons.account_circle_outlined,
  ];

  final List<Widget> _listWidget = [
    const HomeScreen(),
    const ProductScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  final List<String> _listMenu = [
    "Home",
    "List",
    "Cart",
    "Profile",
  ];

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
      final ProductViewModel productViewModel =
          Provider.of<ProductViewModel>(context, listen: false);
      final MainViewModel mainViewModel = Provider.of<MainViewModel>(context, listen: false);
      final CartViewModel cartViewModel = Provider.of<CartViewModel>(context, listen: false);
      if (productViewModel.products.any((element) => element.idProduk == barcodeScanRes)) {
        setState(() {
          mainViewModel.setIndexBottomNav(2);
          cartViewModel.addResultBarcode(barcodeScanRes);
        });
      } else {
        CustomNotificationSnackbar(
            context: context, message: "Produk tersebut tidak tersedia di toko anda");
      }
    }
  }

  @override
  void initState() {
    final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final MainViewModel mainViewModel = Provider.of<MainViewModel>(context, listen: false);
    final CartViewModel cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final OnlineOrderViewModel onlineOrderViewModel =
        Provider.of<OnlineOrderViewModel>(context, listen: false);

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
        mainViewModel.updateTokenFCM(token);
      }
    });

    // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //   if (message != null) {
    //     final User userLogin = authViewModel.userLogin;
    //     if (userLogin.id.isNotEmpty) {
    //       if (message.data['redirect'] == 'online_order') {}
    //     }
    //   }
    // });

    //on background (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final User userLogin = authViewModel.userLogin;
      if (userLogin.id.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (message.data['redirect'] == 'online_order') {
            onlineOrderViewModel.getOnlineOrder();
            mainViewModel.setIndexBottomNav(2);
            cartViewModel.setIndexTabToOnlineOrder(1);
          }
        });
      }
    });

    //on foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final User userLogin = authViewModel.userLogin;
      if (userLogin.id.isNotEmpty) {
        if (message.data['redirect'] == 'online_order') {
          onlineOrderViewModel.getOnlineOrder();
        }

        CustomNotificationSnackbar(
          context: context,
          message: message.notification?.body ?? "",
          actionLabel: message.data['redirect'] != null ? "Lihat" : null,
          action: () {
            if (message.data['redirect'] == 'online_order') {
              onlineOrderViewModel.getOnlineOrder();
              mainViewModel.setIndexBottomNav(2);
              cartViewModel.setIndexTabToOnlineOrder(1);
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
      final HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      final ProductViewModel productViewModel =
          Provider.of<ProductViewModel>(context, listen: false);
      final OnlineOrderViewModel onlineOrderViewModel =
          Provider.of<OnlineOrderViewModel>(context, listen: false);
      final HistoryTransactionViewModel historyTransactionViewModel =
          Provider.of<HistoryTransactionViewModel>(context, listen: false);

      homeViewModel.fetchSummaryStore();
      homeViewModel.fetchNews();
      productViewModel.fetchProductUser();
      onlineOrderViewModel.getOnlineOrder();
      historyTransactionViewModel.fetchHistoryTransaction();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, model, child) {
      return Scaffold(
        body: _listWidget[model.indexBottomNav],
        backgroundColor: colorWhiteBlue,
        floatingActionButton: ScaleTransition(
          scale: animation,
          child: FloatingActionButton(
            elevation: 8,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(41)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [colorLinearStart, colorLinearEnd],
                ),
              ),
              child: const Icon(
                Icons.crop_free,
                color: textColorWhite,
              ),
            ),
            onPressed: () {
              scanBarcodeNormal();
              _animationController.reset();
              _animationController.forward();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          splashColor: primaryColor,
          notchAndCornersAnimation: animation,
          splashSpeedInMilliseconds: 300,
          activeIndex: model.indexBottomNav,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 10,
          rightCornerRadius: 10,
          onTap: (index) => model.setIndexBottomNav(index),
        ),
      );
    });
  }
}
