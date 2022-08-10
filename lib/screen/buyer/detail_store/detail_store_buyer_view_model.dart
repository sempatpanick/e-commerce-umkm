import 'package:e_warung/data/model/list_store_result.dart';
import 'package:flutter/material.dart';

import '../../../data/api/api_service.dart';
import '../../../utils/get_connection.dart';
import '../../../utils/result_state.dart';

class DetailStoreBuyerViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final _getConnection = GetConnection();

  List<ProductStore> _products = [];
  List<ProductStore> get products => _products;

  ResultState _stateProduct = ResultState.none;
  ResultState get stateProduct => _stateProduct;

  bool _isExpandableAppBar = true;
  bool get isExpandableAppBar => _isExpandableAppBar;

  void fetchProductStore(int idStore) async {
    changeStateProduct(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final result = await _apiService.getListStore();

        if (result.status) {
          if (result.data.isNotEmpty) {
            Store store =
                result.data.where((store) => store.id == idStore).first;
            _products = store.products;
            changeStateProduct(ResultState.hasData);
          } else {
            changeStateProduct(ResultState.noData);
          }
        } else {
          changeStateProduct(ResultState.error);
        }
      } else {
        changeStateProduct(ResultState.notConnected);
      }
    } catch (e) {
      changeStateProduct(ResultState.error);
    }
  }

  void setIsExpandableAppBar(bool state) {
    _isExpandableAppBar = state;
    notifyListeners();
  }

  void changeStateProduct(ResultState s) {
    _stateProduct = s;
    notifyListeners();
  }
}
