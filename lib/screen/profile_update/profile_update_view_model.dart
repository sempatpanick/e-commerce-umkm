import 'package:e_warung/data/model/login_result.dart';
import 'package:flutter/material.dart';

import '../../data/api/api_service.dart';
import '../../data/preferences/preferences_helper.dart';
import '../../utils/get_connection.dart';
import '../../utils/result_state.dart';

class ProfileUpdateViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final _getConnection = GetConnection();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  ResultState _stateAddress = ResultState.none;
  ResultState get stateAddress => _stateAddress;

  Future<LoginResult> updateProfile(String email, String username, String name, String phone,
      String? address, double? latitude, double? longitude) async {
    changeState(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();

      if (!connection) {
        changeState(ResultState.error);
        return LoginResult(status: false, message: "Tidak ada koneksi internet");
      }

      final userLogin = await _preferencesHelper.getUserLogin;
      final result = await _apiService.updateProfile(
          userLogin.id, email, username, name, phone, address, latitude, longitude);

      if (!result.status) {
        changeState(ResultState.error);
        return result;
      }

      if (result.user == null) {
        changeState(ResultState.error);
        return LoginResult(status: false, message: "Terjadi kesalahan!");
      }

      _preferencesHelper.setUserLogin(result.user!);

      changeState(ResultState.hasData);
      return result;
    } catch (e) {
      changeState(ResultState.error);
      return LoginResult(status: false, message: "Failed to login");
    }
  }

  Future<LoginResult> updateProfileAddress(
      String address, double latitude, double longitude) async {
    changeStateAddress(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();

      if (!connection) {
        changeStateAddress(ResultState.error);
        return LoginResult(status: false, message: "Tidak ada koneksi internet");
      }

      final userLogin = await _preferencesHelper.getUserLogin;
      final result =
          await _apiService.updateProfileAddress(userLogin.id, address, latitude, longitude);

      if (!result.status) {
        changeStateAddress(ResultState.error);
        return result;
      }

      if (result.user == null) {
        changeStateAddress(ResultState.error);
        return LoginResult(status: false, message: "Terjadi kesalahan!");
      }

      _preferencesHelper.setUserLogin(result.user!);

      changeStateAddress(ResultState.hasData);
      return result;
    } catch (e) {
      changeStateAddress(ResultState.error);
      return LoginResult(status: false, message: "Failed to login");
    }
  }

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }

  void changeStateAddress(ResultState s) {
    _stateAddress = s;
    notifyListeners();
  }
}
