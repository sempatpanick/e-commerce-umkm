import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/styles.dart';
import '../../data/model/login_result.dart';
import '../auth/auth_screen.dart';
import '../auth/auth_view_model.dart';
import '../buyer/main/main_buyer_screen.dart';
import '../seller/main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AuthViewModel>(context, listen: false).getUserFromPreferences();
      Timer(const Duration(seconds: 2), () {
        final User user = Provider.of<AuthViewModel>(context, listen: false).userLogin;
        if (user.id != "") {
          if (user.role == "Seller") {
            Navigator.pushReplacementNamed(context, MainScreen.routeName);
          } else {
            Navigator.pushReplacementNamed(context, MainBuyerScreen.routeName);
          }
        } else {
          Navigator.pushReplacementNamed(context, AuthScreen.routeName, arguments: true);
        }
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_business_outlined,
              size: 100,
              color: textColorWhite,
            ),
            Text(
              "E-Warung",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: textColorWhite, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
