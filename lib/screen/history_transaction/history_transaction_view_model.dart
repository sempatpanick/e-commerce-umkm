import 'package:flutter/material.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/history_transaction_result.dart';
import '../../../data/preferences/preferences_helper.dart';
import '../../../utils/get_connection.dart';
import '../../../utils/result_state.dart';

class HistoryTransactionViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final _getConnection = GetConnection();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  Future<void> fetchHistoryTransaction() async {
    try {
      changeState(ResultState.loading);
      final connection = await _getConnection.getConnection();
      if (connection) {
        final userLogin = await _preferencesHelper.getUserLogin;
        var result = await apiService.getHistoryTransaction(userLogin.id, userLogin.role);
        _transactions = result.data;
        if (result.data.isNotEmpty) {
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
