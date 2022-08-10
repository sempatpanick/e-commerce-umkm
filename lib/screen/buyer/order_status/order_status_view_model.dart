import 'package:e_warung/data/api/api_service.dart';
import 'package:e_warung/data/preferences/preferences_helper.dart';
import 'package:flutter/material.dart';

import '../../../data/model/order_status_model.dart';
import '../../../utils/get_connection.dart';
import '../../../utils/result_state.dart';

class OrderStatusViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final GetConnection _getConnection = GetConnection();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  List<OrderStatus> _orderStatus = [];
  List<OrderStatus> get orderStatus => _orderStatus;

  Future<void> getOrderStatus() async {
    changeState(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await _apiService.getOrderStatus(userLogin.id);

        if (result.status) {
          _orderStatus = result.data;
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

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }
}
