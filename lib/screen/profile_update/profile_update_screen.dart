import 'package:e_warung/data/model/login_result.dart';
import 'package:e_warung/screen/profile_location/profile_location_view_model.dart';
import 'package:e_warung/screen/profile_update/profile_update_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../common/styles.dart';
import '../../utils/result_state.dart';
import '../../widgets/custom_notification_snackbar.dart';
import '../auth/auth_view_model.dart';
import '../profile_location/profile_location_screen.dart';

class ProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/profile_update';
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final ProfileUpdateViewModel profileUpdateViewModel =
          Provider.of<ProfileUpdateViewModel>(context, listen: false);
      final ProfileLocationViewModel profileLocationViewModel =
          Provider.of<ProfileLocationViewModel>(context, listen: false);
      final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      final result = await profileUpdateViewModel.updateProfile(
          _emailController.text,
          _usernameController.text,
          _nameController.text,
          _phoneController.text,
          profileLocationViewModel.currentNamePosition,
          profileLocationViewModel.currentLatitude,
          profileLocationViewModel.currentLongitude);

      if (result.status) {
        authViewModel.getUserFromPreferences();
      }

      CustomNotificationSnackbar(context: context, message: result.message);
    }
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final ProfileLocationViewModel profileLocationViewModel =
          Provider.of<ProfileLocationViewModel>(context, listen: false);
      final User user = authViewModel.userLogin;

      _emailController.text = user.email;
      _usernameController.text = user.username ?? "";
      _nameController.text = user.nama ?? "";
      _phoneController.text = user.noTelp ?? "";
      _addressController.text = user.alamat ?? "";
      profileLocationViewModel.setCurrentLocation(
          user.alamat,
          user.latitude == null ? null : double.parse(user.latitude!),
          user.longitude == null ? null : double.parse(user.longitude!));
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhiteBlue,
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: Consumer<ProfileUpdateViewModel>(builder: (context, model, child) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(26.0),
            children: [
              TextFormField(
                controller: _emailController,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                readOnly: model.state == ResultState.loading ? true : false,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return "Email tidak boleh kurang dari 3 karakter";
                  }
                  if (!isEmail(value)) {
                    return "Email tidak valid";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'yourmail@example.com',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  prefixIcon: Icon(Icons.mail_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _usernameController,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                readOnly: model.state == ResultState.loading ? true : false,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return "Username tidak boleh kurang dari 3 karakter";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Username..',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _nameController,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                readOnly: model.state == ResultState.loading ? true : false,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return "Nama tidak boleh kurang dari 3 karakter";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'John Doe',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  prefixIcon: Icon(Icons.account_box_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _phoneController,
                autocorrect: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                readOnly: model.state == ResultState.loading ? true : false,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return "Nama tidak boleh kurang dari 3 karakter";
                  }
                  if (!isNumeric(value)) {
                    return "Nomor telepon harus angka";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: '085421432..',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _addressController,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                readOnly: true,
                onTap: () async {
                  var result = await Navigator.pushNamed(context, ProfileLocationScreen.routeName);
                  setState(() {
                    _addressController.text = result as String? ?? "";
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Address',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final AuthViewModel authViewModel =
                          Provider.of<AuthViewModel>(context, listen: false);

                      var result =
                          await Navigator.pushNamed(context, ProfileLocationScreen.routeName);
                      final Map? address = result as Map?;
                      setState(() {
                        if (address != null) {
                          _addressController.text = address['address'] ?? "";
                          authViewModel.getUserFromPreferences();
                        } else {
                          _addressController.text = authViewModel.userLogin.alamat ?? "";
                        }
                      });
                    },
                    icon: const Icon(Icons.add),
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
                  onPressed: model.state == ResultState.loading ? null : () => updateProfile(),
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
                          "Update Profile",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )),
            ],
          ),
        );
      }),
    );
  }
}
