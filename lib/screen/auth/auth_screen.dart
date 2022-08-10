import 'package:e_warung/screen/buyer/main/main_buyer_screen.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../common/styles.dart';
import '../../utils/encryption.dart';
import '../../utils/result_state.dart';
import '../../widgets/custom_notification_snackbar.dart';
import '../seller/main/main_screen.dart';
import 'auth_view_model.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  final bool isLogin;

  const AuthScreen({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final GroupButtonController _roleButtonController = GroupButtonController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;

  void auth() async {
    if (_formKey.currentState!.validate()) {
      if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
        CustomNotificationSnackbar(
            context: context, message: "Username or password can't be empty");
      } else if (isEmail(_emailTextController.text)) {
        final navigator = Navigator.of(context);
        final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        if (widget.isLogin) {
          final result = await authViewModel.login(
              _emailTextController.text, Encryption.generateMd5(_passwordTextController.text));

          if (result.status) {
            CustomNotificationSnackbar(
                context: context,
                message: "Selamat datang ${result.user!.nama ?? result.user!.email}");
            if (result.user!.role == "Seller") {
              navigator.pushReplacementNamed(MainScreen.routeName);
            } else {
              navigator.pushReplacementNamed(MainBuyerScreen.routeName);
            }
          } else {
            if (result.user?.activate == "0") {
              CustomNotificationSnackbar(
                  context: context,
                  message: result.message,
                  actionLabel: "Resend Email",
                  action: () async {
                    final resultEmail = await authViewModel.resendEmail(result.user!.email);
                    CustomNotificationSnackbar(context: context, message: resultEmail.message);
                  });
            } else {
              CustomNotificationSnackbar(context: context, message: result.message);
            }
          }
        } else {
          if (_roleButtonController.selectedIndex == null) {
            CustomNotificationSnackbar(
                context: context, message: "Anda harus memilih role terlebih dahulu");
          } else {
            final result = await authViewModel.register(
                _emailTextController.text, Encryption.generateMd5(_passwordTextController.text));

            if (result.status) {
              CustomNotificationSnackbar(
                  context: context,
                  message:
                      "Akun telah berhasil dibuat, silahkan periksa email/folder spam anda untuk aktivasi");
            } else {
              CustomNotificationSnackbar(context: context, message: result.message);
            }
          }
        }
      } else {
        CustomNotificationSnackbar(context: context, message: "Invalid Email");
      }
    }
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _roleButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthViewModel>(builder: (context, model, child) {
        return SafeArea(
          child: model.state == ResultState.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 43.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: widget.isLogin
                                ? Image.asset("assets/images/img_door_user.png")
                                : Image.asset("assets/images/img_phone_user.png"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.isLogin ? "Login" : "Register",
                            style: Theme.of(context).textTheme.headline5!.copyWith(
                                color: primaryColor,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.75),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          TextFormField(
                            controller: _emailTextController,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return "Email tidak boleh kurang dari 3 karakter";
                              }
                              if (!isEmail(value)) {
                                return "Email tidak valid";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              color: textFieldColorGrey,
                            ),
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "Email address..",
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: textFieldColorGrey,
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _passwordTextController,
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            obscureText: _isPasswordVisible,
                            textInputAction: TextInputAction.go,
                            onFieldSubmitted: (_) => auth(),
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return "Password tidak boleh kurang dari 3 karakter";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              color: textFieldColorGrey,
                            ),
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Password..",
                              prefixIcon: const Icon(
                                Icons.password,
                                color: textFieldColorGrey,
                              ),
                              suffixIcon: IconButton(
                                alignment: Alignment.centerLeft,
                                icon: _isPasswordVisible
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(Icons.visibility_off_outlined),
                                color: textFieldColorGrey,
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (!widget.isLogin)
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Select a Role",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GroupButton(
                                      controller: _roleButtonController,
                                      onSelected: (val, index, selected) =>
                                          model.setRole(val.toString()),
                                      options: GroupButtonOptions(
                                          selectedBorderColor: Colors.transparent,
                                          unselectedBorderColor: colorDashboardBlue,
                                          textPadding: const EdgeInsets.all(10),
                                          borderRadius: BorderRadius.circular(25.0)),
                                      buttons: const [
                                        "Seller",
                                        "Buyer",
                                      ])
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 22,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40.0,
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.isLogin) {
                                  auth();
                                } else {
                                  if (model.role != null) {
                                    if (model.role!.isNotEmpty) {
                                      auth();
                                    } else {
                                      CustomNotificationSnackbar(
                                          context: context,
                                          message: "Anda harus memilih role terlebih dahulu");
                                    }
                                  } else {
                                    CustomNotificationSnackbar(
                                        context: context,
                                        message: "Anda harus memilih role terlebih dahulu");
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              child: Text(
                                widget.isLogin ? "Login" : "Register",
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: textColorWhite,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                    child: const Divider(
                                      color: primaryColor,
                                      height: 1,
                                    )),
                              ),
                              Text(
                                "or",
                                style:
                                    Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12.0),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                                  child: const Divider(
                                    color: primaryColor,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40.0,
                            child: ElevatedButton(
                              onPressed: () {
                                widget.isLogin
                                    ? Navigator.pushNamed(context, AuthScreen.routeName,
                                        arguments: false)
                                    : Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: textColorWhite,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: primaryColor)),
                              ),
                              child: Text(
                                widget.isLogin ? "Register" : "Login",
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
