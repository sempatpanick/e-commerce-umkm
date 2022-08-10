import 'package:flutter/material.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/login_result.dart';
import '../../../data/preferences/preferences_helper.dart';

class MainViewModel extends ChangeNotifier {
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
