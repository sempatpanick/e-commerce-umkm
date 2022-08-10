import 'package:e_warung/common/styles.dart';
import 'package:e_warung/screen/change_password/change_password_view_model.dart';
import 'package:e_warung/widgets/custom_notification_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/encryption.dart';
import '../../utils/result_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change_password_screen';
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      CustomNotificationSnackbar(context: context, message: "Konfirmasi password tidak sama");
      return;
    }
    if (_oldPasswordController.text == _newPasswordController.text) {
      CustomNotificationSnackbar(
          context: context, message: "Password baru tidak boleh sama dengan password lama");
      return;
    }

    final ChangePasswordViewModel changePasswordViewModel =
        Provider.of<ChangePasswordViewModel>(context, listen: false);
    final result = await changePasswordViewModel.changePassword(
        Encryption.generateMd5(_oldPasswordController.text),
        Encryption.generateMd5(_newPasswordController.text));

    CustomNotificationSnackbar(context: context, message: result.message);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteBlue,
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Consumer<ChangePasswordViewModel>(builder: (context, model, child) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(26.0),
            children: [
              TextFormField(
                controller: _oldPasswordController,
                autocorrect: false,
                obscureText: !_isOldPasswordVisible,
                textInputAction: TextInputAction.next,
                readOnly: model.state == ResultState.loading ? true : false,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return "Password lama tidak boleh kurang dari 3 karakter";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password Lama',
                  hintText: 'Password lama..',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: _isOldPasswordVisible
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility_outlined),
                    color: textFieldColorGrey,
                    onPressed: () {
                      setState(() {
                        _isOldPasswordVisible = !_isOldPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _newPasswordController,
                autocorrect: false,
                obscureText: !_isNewPasswordVisible,
                textInputAction: TextInputAction.next,
                readOnly: model.state == ResultState.loading ? true : false,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return "Password baru tidak boleh kurang dari 3 karakter";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  hintText: 'Password baru..',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: _isNewPasswordVisible
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility_outlined),
                    color: textFieldColorGrey,
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                autocorrect: false,
                obscureText: !_isConfirmPasswordVisible,
                textInputAction: TextInputAction.send,
                readOnly: model.state == ResultState.loading ? true : false,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return "Password baru tidak boleh kurang dari 3 karakter";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  hintText: 'Konfirmasi Password baru..',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    alignment: Alignment.centerLeft,
                    icon: _isConfirmPasswordVisible
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility_outlined),
                    color: textFieldColorGrey,
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: model.state == ResultState.loading ? null : () => _changePassword(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: const StadiumBorder(),
                ),
                child: model.state == ResultState.loading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
