import 'package:e_warung/data/api/api_service.dart';
import 'package:e_warung/data/model/login_result.dart';
import 'package:e_warung/data/preferences/preferences_helper.dart';
import 'package:flutter/material.dart';

class MainBuyerViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  int _indexBottomNav = 0;
  int get indexBottomNav => _indexBottomNav;

  void setIndexBottomNav(int index) {
    _indexBottomNav = index;
    notifyListeners();
  }

  void updateTokenFCM(String token) async {
    final User userLogin = await _preferencesHelper.getUserLogin;
    await _apiService.updateTokenFCM(userLogin.id, token);
  }
}
