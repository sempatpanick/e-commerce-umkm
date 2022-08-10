import 'package:e_warung/data/model/general_result.dart';
import 'package:e_warung/data/model/register_result.dart';
import 'package:e_warung/data/preferences/preferences_helper.dart';
import 'package:e_warung/utils/result_state.dart';
import 'package:flutter/material.dart';

import '../../data/api/api_service.dart';
import '../../data/model/login_result.dart';
import '../../utils/get_connection.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final _getConnection = GetConnection();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  User _userLogin = User(
      id: "",
      username: "",
      email: "",
      password: "",
      nama: "",
      alamat: "",
      noTelp: "",
      avatar: "",
      role: "",
      activate: "");
  User get userLogin => _userLogin;

  String? _role;
  String? get role => _role;

  Future<LoginResult> login(String email, String password) async {
    changeState(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();

      if (!connection) {
        changeState(ResultState.error);
        return LoginResult(status: false, message: "Tidak ada koneksi internet");
      }

      final result = await _apiService.login(email, password);

      if (!result.status) {
        changeState(ResultState.error);
        return result;
      }

      if (result.user == null) {
        changeState(ResultState.error);
        return LoginResult(status: false, message: "Terjadi kesalahan!");
      }

      _preferencesHelper.setUserLogin(result.user!);
      getUserFromPreferences();

      changeState(ResultState.hasData);
      return result;
    } catch (e) {
      changeState(ResultState.error);
      return LoginResult(status: false, message: "Failed to login");
    }
  }

  Future<RegisterResult> register(String email, String password) async {
    changeState(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (!connection) {
        changeState(ResultState.error);
        return RegisterResult(status: false, message: "Tidak ada koneksi internet");
      }

      final result = await _apiService.register(email, password, _role!);

      if (!result.status) {
        changeState(ResultState.error);
        return RegisterResult(status: false, message: result.message);
      }

      changeState(ResultState.hasData);
      return result;
    } catch (e) {
      changeState(ResultState.error);
      return RegisterResult(status: false, message: "Failed to register");
    }
  }

  Future<GeneralResult> resendEmail(String email) async {
    changeState(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (!connection) {
        changeState(ResultState.error);
        return GeneralResult(status: false, message: "Tidak ada koneksi internet");
      }

      final result = await _apiService.resendEmail(email);

      if (!result.status) {
        changeState(ResultState.error);
        return GeneralResult(status: false, message: result.message);
      }

      changeState(ResultState.hasData);
      return result;
    } catch (e) {
      changeState(ResultState.error);
      return GeneralResult(status: false, message: "Failed to resend email!");
    }
  }

  Future<void> getUserFromPreferences() async {
    _userLogin = await _preferencesHelper.getUserLogin;
    notifyListeners();
  }

  void removeUserLogin() async {
    _preferencesHelper.removeUserLogin();
    getUserFromPreferences();
    notifyListeners();
  }

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }
}
