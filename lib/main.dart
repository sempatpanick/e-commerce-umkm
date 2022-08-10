import 'package:e_warung/screen/buyer/cart/cart_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/detail_store/detail_store_buyer_view_model.dart';
import 'package:e_warung/screen/buyer/order_status/order_status_view_model.dart';
import 'package:e_warung/screen/buyer/transaction/transaction_buyer_screen.dart';
import 'package:e_warung/screen/buyer/transaction/transaction_buyer_view_model.dart';
import 'package:e_warung/screen/change_password/change_password_screen.dart';
import 'package:e_warung/screen/change_password/change_password_view_model.dart';
import 'package:e_warung/screen/map_location/map_location_screen.dart';
import 'package:e_warung/screen/seller/online_order/online_order_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'common/navigation.dart';
import 'common/styles.dart';
import 'data/model/list_store_result.dart';
import 'firebase_options.dart';
import 'screen/auth/auth_screen.dart';
import 'screen/auth/auth_view_model.dart';
import 'screen/buyer/detail_store/detail_store_buyer_screen.dart';
import 'screen/buyer/home/home_buyer_view_model.dart';
import 'screen/buyer/main/main_buyer_screen.dart';
import 'screen/buyer/main/main_buyer_view_model.dart';
import 'screen/history_transaction/history_transaction_view_model.dart';
import 'screen/profile_location/profile_location_screen.dart';
import 'screen/profile_location/profile_location_view_model.dart';
import 'screen/profile_update/profile_update_screen.dart';
import 'screen/profile_update/profile_update_view_model.dart';
import 'screen/seller/cart/cart_view_model.dart';
import 'screen/seller/home/home_view_model.dart';
import 'screen/seller/main/main_screen.dart';
import 'screen/seller/main/main_view_model.dart';
import 'screen/seller/product/product_view_model.dart';
import 'screen/splash/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => MainViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => ProductViewModel()),
        ChangeNotifierProvider(create: (context) => CartViewModel(context: context)),
        ChangeNotifierProvider(create: (context) => OnlineOrderViewModel()),
        ChangeNotifierProvider(create: (context) => HistoryTransactionViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileUpdateViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileLocationViewModel()),
        ChangeNotifierProvider(create: (context) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (context) => MainBuyerViewModel()),
        ChangeNotifierProvider(create: (context) => HomeBuyerViewModel()),
        ChangeNotifierProvider(create: (context) => DetailStoreBuyerViewModel()),
        ChangeNotifierProvider(create: (context) => CartBuyerViewModel()),
        ChangeNotifierProvider(create: (context) => TransactionBuyerViewModel()),
        ChangeNotifierProvider(create: (context) => OrderStatusViewModel()),
      ],
      child: MaterialApp(
        title: 'E-Warung',
        theme: lightTheme,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          AuthScreen.routeName: (context) =>
              AuthScreen(isLogin: ModalRoute.of(context)!.settings.arguments as bool),
          MainScreen.routeName: (context) => const MainScreen(),
          MapLocationScreen.routeName: (context) => MapLocationScreen(
              address: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
          ProfileUpdateScreen.routeName: (context) => const ProfileUpdateScreen(),
          ProfileLocationScreen.routeName: (context) => const ProfileLocationScreen(),
          ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
          MainBuyerScreen.routeName: (context) => const MainBuyerScreen(),
          DetailStoreBuyerScreen.routeName: (context) => DetailStoreBuyerScreen(
                store: ModalRoute.of(context)!.settings.arguments as Store,
              ),
          TransactionBuyerScreen.routeName: (context) => const TransactionBuyerScreen(),
        },
      ),
    );
  }
}
