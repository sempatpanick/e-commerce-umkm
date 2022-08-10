import 'package:flutter/material.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/list_store_result.dart';
import '../../../utils/get_connection.dart';
import '../../../utils/result_state.dart';

class HomeBuyerViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final GetConnection _getConnection = GetConnection();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  List<Store> _stores = [];
  List<Store> get stores => _stores;

  void getListStore() async {
    changeState(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final result = await _apiService.getListStore();

        if (result.status) {
          _stores = result.data;
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
