import 'package:e_warung/data/model/online_order_model.dart';
import 'package:flutter/material.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/general_result.dart';
import '../../../data/preferences/preferences_helper.dart';
import '../../../utils/get_connection.dart';
import '../../../utils/result_state.dart';

class OnlineOrderViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final GetConnection _getConnection = GetConnection();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  List<OnlineOrder> _onlineOrder = [];
  List<OnlineOrder> get onlineOrder => _onlineOrder;

  Future<void> getOnlineOrder() async {
    changeState(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await _apiService.getOnlineOrder(userLogin.id);

        if (result.status) {
          _onlineOrder = result.data;
          changeState(ResultState.hasData);
        } else {
          changeState(ResultState.noData);
        }
      } else {
        changeState(ResultState.notConnected);
      }
    } catch (e) {
      changeState(ResultState.error);
    }
  }

  Future<GeneralResult> updateOnlineOrder(int id, int status, int? paid, int? changeBill) async {
    try {
      final connection = await _getConnection.getConnection();

      if (!connection) {
        return GeneralResult(status: false, message: "Tidak ada koneksi internet");
      }

      final result = await _apiService.updateOnlineOrder(id, status, paid, changeBill);

      return result;
    } catch (e) {
      return GeneralResult(status: false, message: "Terjadi kesalahan");
    }
  }

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }
}
