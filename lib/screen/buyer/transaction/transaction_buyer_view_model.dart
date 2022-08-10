import 'package:flutter/foundation.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/general_result.dart';
import '../../../data/preferences/preferences_helper.dart';
import '../../../utils/get_connection.dart';
import '../../../utils/result_state.dart';

class TransactionBuyerViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final _getConnection = GetConnection();

  ResultState _stateTransaction = ResultState.none;
  ResultState get stateTransaction => _stateTransaction;

  Future<GeneralResult> transaction(
      String idStore, int shippingCost, int totalPrice, List<Map> products) async {
    changeStateTransaction(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        changeStateTransaction(ResultState.hasData);
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await _apiService.saveTransaction(
            userLogin.id, idStore, shippingCost, totalPrice, null, null, products);
        return result;
      } else {
        changeStateTransaction(ResultState.notConnected);
        return GeneralResult(status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      changeStateTransaction(ResultState.error);
      return GeneralResult(status: false, message: "Transaction failed, $e");
    }
  }

  void changeStateTransaction(ResultState s) {
    _stateTransaction = s;
    notifyListeners();
  }
}
