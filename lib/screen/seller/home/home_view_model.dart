import 'package:flutter/material.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/news_result.dart';
import '../../../data/model/summary_result.dart';
import '../../../data/preferences/preferences_helper.dart';
import '../../../utils/get_connection.dart';
import '../../../utils/result_state.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final _getConnection = GetConnection();

  ResultState _stateSummary = ResultState.none;
  ResultState get stateSummary => _stateSummary;

  ResultState _stateNews = ResultState.none;
  ResultState get stateNews => _stateNews;

  Summary? _summary;
  Summary? get summary => _summary;

  List<News> _news = [];
  List<News> get news => _news;

  void fetchSummaryStore() async {
    changeStateSummary(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await apiService.getSummaryStore(userLogin.id);

        if (result.status) {
          _summary = result.data!;
          changeStateSummary(ResultState.hasData);
        } else {
          changeStateSummary(ResultState.error);
        }
      } else {
        changeStateSummary(ResultState.notConnected);
      }
    } catch (e) {
      changeStateSummary(ResultState.error);
    }
  }

  void fetchNews() async {
    changeStateNews(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final result = await apiService.getNews();

        if (result.status) {
          _news = result.data;
          changeStateNews(ResultState.hasData);
        } else {
          changeStateNews(ResultState.error);
        }
      } else {
        changeStateNews(ResultState.error);
      }
    } catch (e) {
      changeStateNews(ResultState.error);
    }
  }

  void changeStateSummary(ResultState s) {
    _stateSummary = s;
    notifyListeners();
  }

  void changeStateNews(ResultState s) {
    _stateNews = s;
    notifyListeners();
  }

  void clear() {
    changeStateSummary(ResultState.none);
    changeStateNews(ResultState.none);
    _summary = null;
    _news = [];
  }
}
