import 'package:flutter/material.dart';

import '../../../data/api/api_service.dart';
import '../../../data/model/form_product.dart';
import '../../../data/model/general_result.dart';
import '../../../data/model/products_user_result.dart';
import '../../../data/model/recommended_product_result.dart';
import '../../../data/preferences/preferences_helper.dart';
import '../../../utils/get_connection.dart';
import '../../../utils/result_state.dart';

class ProductViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final PreferencesHelper _preferencesHelper = PreferencesHelper();
  final _getConnection = GetConnection();

  ResultState _stateProduct = ResultState.none;
  ResultState get stateProduct => _stateProduct;

  bool _isFormInputProduct = false;
  bool get isFormInputProduct => _isFormInputProduct;

  List<Products> _products = [];
  List<Products> get products => _products;

  RecommendedProduct _recommendedProduct = RecommendedProduct(
      id: "", nama: "", keterangan: "", harga: "", gambar: "");
  RecommendedProduct get recommendedProduct => _recommendedProduct;

  FormProduct _formProduct = FormProduct(title: "", type: "");
  FormProduct get formProduct => _formProduct;

  void fetchProductUser() async {
    changeStateProduct(ResultState.loading);
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await apiService.getProductsUser(userLogin.id);

        if (result.status) {
          if (result.data!.isNotEmpty) {
            _products = result.data!;
            changeStateProduct(ResultState.hasData);
          } else {
            changeStateProduct(ResultState.noData);
          }
        } else {
          changeStateProduct(ResultState.error);
        }
      } else {
        changeStateProduct(ResultState.error);
      }
    } catch (e) {
      changeStateProduct(ResultState.error);
    }
  }

  Future<RecommendedProductResult> fetchRecommendedProduct(String id) async {
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        return await apiService.getRecommendedProduct(id);
      } else {
        return RecommendedProductResult(
            status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      return RecommendedProductResult(
          status: false, message: "Failed to get recommended product, $e");
    }
  }

  Future<GeneralResult> addProduct(
      String idProduct,
      String name,
      String description,
      int price,
      int stock,
      String image,
      String baseImage) async {
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await apiService.addProduct(userLogin.id, idProduct,
            name, description, price, stock, image, baseImage);

        if (result.status) {
          fetchProductUser();
        }

        return result;
      } else {
        return GeneralResult(
            status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      return GeneralResult(status: false, message: "Failed to add product, $e");
    }
  }

  Future<GeneralResult> updateProduct(
      String idProduct,
      String name,
      String description,
      int price,
      int stock,
      String image,
      String baseImage) async {
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await apiService.updateProduct(userLogin.id, idProduct,
            name, description, price, stock, image, baseImage);

        if (result.status) {
          fetchProductUser();
        }

        return result;
      } else {
        return GeneralResult(
            status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      return GeneralResult(status: false, message: "Failed to add product, $e");
    }
  }

  Future<GeneralResult> deleteProductById(String id) async {
    try {
      final connection = await _getConnection.getConnection();
      if (connection) {
        final userLogin = await _preferencesHelper.getUserLogin;
        final result = await apiService.deleteProduct(userLogin.id, id);

        if (result.status) {
          fetchProductUser();
        }

        return result;
      } else {
        return GeneralResult(
            status: false, message: "Tidak ada koneksi internet");
      }
    } catch (e) {
      return GeneralResult(status: false, message: "Terjadi kesalahan");
    }
  }

  void setIsFormInputProduct(bool state) {
    _isFormInputProduct = state;
    notifyListeners();
  }

  void setRecommendedProduct(RecommendedProduct product) {
    _recommendedProduct = product;
    notifyListeners();
  }

  void setFormProduct(FormProduct formProduct) {
    _formProduct = formProduct;
    notifyListeners();
  }

  void changeStateProduct(ResultState s) {
    _stateProduct = s;
    notifyListeners();
  }
}
