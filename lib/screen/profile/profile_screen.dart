import 'package:e_warung/screen/auth/auth_view_model.dart';
import 'package:e_warung/screen/change_password/change_password_screen.dart';
import 'package:e_warung/screen/profile_update/profile_update_screen.dart';
import 'package:e_warung/screen/seller/cart/cart_view_model.dart';
import 'package:e_warung/screen/seller/home/home_view_model.dart';
import 'package:e_warung/screen/seller/main/main_view_model.dart';
import 'package:e_warung/screen/seller/product/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/styles.dart';
import '../auth/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<AuthViewModel>(builder: (context, model, child) {
            return Container(
              margin: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: textColorWhite,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: primaryColor,
                          ),
                          child: model.userLogin.avatar != ""
                              ? Image.network(
                                  "https://e-warung.my.id/assets/users/${model.userLogin.id}/${model.userLogin.avatar ?? ""}",
                                  fit: BoxFit.fill,
                                  errorBuilder: (BuildContext context, Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 100.0,
                                      color: textColorWhite,
                                    );
                                  },
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 100,
                                ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            model.userLogin.email,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.black, fontSize: 15.0),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, ProfileUpdateScreen.routeName);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.edit),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: textColorWhite, borderRadius: BorderRadius.circular(20.0)),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          onTap: () => Navigator.pushNamed(context, ChangePasswordScreen.routeName),
                          leading: const Icon(Icons.key),
                          title: Text(
                            "Change Password",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.black, fontSize: 15.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: 120.0,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AuthScreen.routeName,
                            arguments: true);
                        Provider.of<CartViewModel>(context, listen: false).clearAll();
                        Provider.of<MainViewModel>(context, listen: false).setIndexBottomNav(0);
                        Provider.of<HomeViewModel>(context, listen: false).clear();
                        Provider.of<ProductViewModel>(context, listen: false)
                            .setIsFormInputProduct(false);
                        model.removeUserLogin();
                      },
                      child: Text(
                        "Logout",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: textColorWhite, fontSize: 17.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
