import 'package:e_warung/utils/get_connection.dart';
import 'package:flutter/material.dart';

import '../../data/api/api_service.dart';
import '../../data/model/general_result.dart';
import '../../data/preferences/preferences_helper.dart';
import '../../utils/result_state.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final GetConnection _getConnection = GetConnection();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  Future<GeneralResult> changePassword(String oldPassword, String newPassword) async {
    changeState(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (!connection) {
        changeState(ResultState.error);
        return GeneralResult(status: false, message: "Tidak ada koneksi internet");
      }

      final userLogin = await _preferencesHelper.getUserLogin;
      final result = await _apiService.changePassword(userLogin.id, oldPassword, newPassword);

      if (!result.status) {
        changeState(ResultState.error);
        return GeneralResult(status: false, message: result.message);
      }

      changeState(ResultState.hasData);
      return result;
    } catch (e) {
      changeState(ResultState.error);
      return GeneralResult(status: false, message: "Terjadi kesalahan");
    }
  }

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }
}
