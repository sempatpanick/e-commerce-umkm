import 'package:e_warung/utils/result_state.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/api/api_service.dart';
import '../../data/preferences/preferences_helper.dart';

class ProfileLocationViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();

  ResultState _stateCurrentPosition = ResultState.none;
  ResultState get stateCurrentPosition => _stateCurrentPosition;

  final double _initialLatitude = -6.932205;
  double get initialLatitude => _initialLatitude;

  final double _initialLongitude = 111.371222;
  double get initialLongitude => _initialLongitude;

  final String _subLocalityName = "Sambongrejo";
  String get subLocalityName => _subLocalityName;

  final String _localityName = "Kecamatan Tunjungan";
  String get localityName => _localityName;

  double? _currentLatitude;
  double? get currentLatitude => _currentLatitude;

  double? _currentLongitude;
  double? get currentLongitude => _currentLongitude;

  String? _currentNamePosition;
  String? get currentNamePosition => _currentNamePosition;

  String _popUpMessage = "";
  String get popUpMessage => _popUpMessage;

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  void setCurrentLocation(String? name, double? lat, double? long) async {
    _currentNamePosition = name;
    _currentLatitude = lat;
    _currentLongitude = long;

    final userLogin = await _preferencesHelper.getUserLogin;
    final result = await _apiService.updateProfileAddress(userLogin.id, name, lat, long);

    if (!result.status) {
      return;
    }

    if (result.user == null) {
      return;
    }

    _preferencesHelper.setUserLogin(result.user!);

    notifyListeners();
  }

  void clearCurrentLocation() {
    _currentNamePosition = null;
    _currentLatitude = null;
    _currentLongitude = null;

    notifyListeners();
  }

  void setPopUpMessage(String s) {
    _popUpMessage = s;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      _popUpMessage = "";
      notifyListeners();
    });
  }

  void changeStateCurrentPosition(ResultState s) {
    _stateCurrentPosition = s;
    notifyListeners();
  }
}
