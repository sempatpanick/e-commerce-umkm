import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_warung/data/model/detail_product_user_result.dart';
import 'package:e_warung/data/model/general_result.dart';
import 'package:e_warung/data/model/history_transaction_result.dart';
import 'package:e_warung/data/model/list_store_result.dart';
import 'package:e_warung/data/model/login_result.dart';
import 'package:e_warung/data/model/news_result.dart';
import 'package:e_warung/data/model/online_order_model.dart';
import 'package:e_warung/data/model/order_status_model.dart';
import 'package:e_warung/data/model/products_user_result.dart';
import 'package:e_warung/data/model/recommended_product_result.dart';
import 'package:e_warung/data/model/register_result.dart';
import 'package:e_warung/data/model/summary_result.dart';

class ApiService {
  static const String _baseUrl = 'https://e-warung.my.id/api';
  final Dio _dio = Dio();

  Future<LoginResult> login(String email, String password) async {
    final Response response =
        await _dio.post("$_baseUrl/user/login.php", data: {"email": email, "password": password});
    if (response.statusCode == 200) {
      return LoginResult.fromJson(response.data);
    } else {
      return LoginResult.fromJson(json.decode('{"status":false,"message":"Failed to auth"}'));
    }
  }

  Future<RegisterResult> register(String email, String password, String role) async {
    final response = await _dio.post("$_baseUrl/user/signup.php",
        data: {"email": email, "password": password, "role": role});
    if (response.statusCode == 200) {
      return RegisterResult.fromJson(response.data);
    } else {
      return RegisterResult.fromJson(
          json.decode('{"status":false,"message":"Failed to register"}'));
    }
  }

  Future<GeneralResult> resendEmail(String email) async {
    final response = await _dio.post("$_baseUrl/user/resend_email.php", data: {"email": email});
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(response.data);
    } else {
      return GeneralResult.fromJson(
          json.decode('{"status":false,"message":"Failed to resend email"}'));
    }
  }

  Future<LoginResult> updateProfile(String id, String email, String? username, String? name,
      String? phone, String? address, double? latitude, double? longitude) async {
    final Response response = await _dio.post("$_baseUrl/user/update_profile.php", data: {
      "id": id,
      "email": email,
      "username": username,
      "name": name,
      "phone": phone,
      "alamat": address,
      "latitude": latitude,
      "longitude": longitude
    });
    if (response.statusCode == 200) {
      return LoginResult.fromJson(response.data);
    } else {
      return LoginResult.fromJson(json.decode('{"status":false,"message":"Failed to update"}'));
    }
  }

  Future<LoginResult> updateProfileAddress(
      String id, String? address, double? latitude, double? longitude) async {
    final Response response = await _dio.post("$_baseUrl/user/update_profile_address.php",
        data: {"id": id, "alamat": address, "latitude": latitude, "longitude": longitude});
    if (response.statusCode == 200) {
      return LoginResult.fromJson(response.data);
    } else {
      return LoginResult.fromJson(json.decode('{"status":false,"message":"Failed to update"}'));
    }
  }

  Future<GeneralResult> changePassword(String id, String oldPassword, String newPassword) async {
    final response = await _dio.post("$_baseUrl/user/change_password.php",
        data: {"id": id, "old_password": oldPassword, "new_password": newPassword});
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(response.data);
    } else {
      return GeneralResult.fromJson(
          json.decode('{"status":false,"message":"Failed to change password"}'));
    }
  }

  Future<GeneralResult> updateTokenFCM(String id, String token) async {
    final Response response = await _dio
        .post("$_baseUrl/user/update_token_fcm.php", data: {"id": id, "token_fcm": token});
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(response.data);
    } else {
      return GeneralResult.fromJson(json.decode('{"status":false,"message":"Failed to update"}'));
    }
  }

  Future<NewsResult> getNews() async {
    final response = await _dio.get("$_baseUrl/news.php");
    if (response.statusCode == 200) {
      return NewsResult.fromJson(response.data);
    } else {
      return NewsResult.fromJson(
          json.decode('{"status":false,"message":"Failed to get news","data":[]}'));
    }
  }

  Future<RecommendedProductResult> getRecommendedProduct(String id) async {
    final response = await _dio.post("$_baseUrl/product/recommended.php", data: {"id_product": id});
    if (response.statusCode == 200) {
      return RecommendedProductResult.fromJson1(response.data);
    } else {
      return RecommendedProductResult.fromJson2(
          json.decode('{"status":false,"message":"Failed to get recommended product"}'));
    }
  }

  Future<GeneralResult> addProduct(String idUser, String idProduct, String name,
      String? description, int price, int stock, String image, String baseImage) async {
    final response = await _dio.post("$_baseUrl/product/add.php", data: {
      "id_user": idUser,
      "id_product": idProduct,
      "nama": name,
      "keterangan": description,
      "harga": price,
      "stok": stock,
      "gambar": image,
      "base_image": baseImage
    });
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(response.data);
    } else {
      return GeneralResult.fromJson(
          json.decode('{"status":false,"message":"Failed to add product"}'));
    }
  }

  Future<GeneralResult> updateProduct(String idUser, String idProduct, String name,
      String? description, int price, int stock, String image, String baseImage) async {
    final response = await _dio.post("$_baseUrl/product/update.php", data: {
      "id_user": idUser,
      "id_product": idProduct,
      "nama": name,
      "keterangan": description,
      "harga": "$price",
      "stok": "$stock",
      "gambar": image,
      "base_image": baseImage
    });
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(response.data);
    } else {
      return GeneralResult.fromJson(
          json.decode('{"status":false,"message":"Failed to update product"}'));
    }
  }

  Future<ProductsUserResult> getProductsUser(String id) async {
    final response = await _dio.post("$_baseUrl/product/by_shop.php", data: {"id_users": id});
    if (response.statusCode == 200) {
      return ProductsUserResult.fromJson1(response.data);
    } else {
      return ProductsUserResult.fromJson2(
          json.decode('{"status":false,"message":"Failed to get products"}'));
    }
  }

  Future<DetailProductUserResult> getDetailProductUser(String idUser, String idProduct) async {
    final response = await _dio
        .post("$_baseUrl/product/by_shop.php", data: {"id_users": idUser, "id_produk": idProduct});
    if (response.statusCode == 200) {
      return DetailProductUserResult.fromJson(response.data);
    } else {
      return DetailProductUserResult.fromJson(
          json.decode('{"status":false,"message":"Failed to get products"}'));
    }
  }

  Future<GeneralResult> deleteProduct(String idUser, String idProduct) async {
    final response = await _dio
        .post("$_baseUrl/product/delete.php", data: {"id_users": idUser, "id_produk": idProduct});
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(response.data);
    } else {
      return GeneralResult.fromJson(
          json.decode('{"status":false,"message":"Failed to delete product"}'));
    }
  }

  Future<GeneralResult> saveTransaction(String idUser, String idStore, int shippingCost, int bill,
      int? paid, int? changeBill, List<Map> products) async {
    var body = {
      "id_user": idUser,
      "id_store": idStore,
      "shipping_cost": shippingCost,
      "bill": bill,
      "paid": paid,
      "change_bill": '$changeBill',
      "products": products
    };

    final response = await _dio.post("$_baseUrl/product/transaction.php", data: body);

    if (response.statusCode == 200) {
      return GeneralResult.fromJson(response.data);
    } else {
      return GeneralResult.fromJson(json.decode('{"status":false,"message":"Transaction failed"}'));
    }
  }

  Future<OnlineOrderModel> getOnlineOrder(String id) async {
    final response =
        await _dio.get("$_baseUrl/product/online_order.php", queryParameters: {"id_store": id});
    if (response.statusCode == 200) {
      return OnlineOrderModel.fromJson(response.data);
    } else {
      return OnlineOrderModel.fromJson(
          json.decode('{"status":false, "message":"Failed to delete product", "data": []}'));
    }
  }

  Future<GeneralResult> updateOnlineOrder(int id, int status, int? paid, int? changeBill) async {
    final response = await _dio.post("$_baseUrl/product/update_online_order.php",
        data: {"id": id, "status": status, "paid": paid, "change_bill": changeBill});
    if (response.statusCode == 200) {
      return GeneralResult.fromJson(response.data);
    } else {
      return GeneralResult.fromJson(
          json.decode('{"status":false,"message":"Failed to update product"}'));
    }
  }

  Future<HistoryTransactionResult> getHistoryTransaction(String idUser, String role) async {
    final response = await _dio
        .post("$_baseUrl/user/history_transaction.php", data: {"id_user": idUser, "role": role});
    if (response.statusCode == 200) {
      return HistoryTransactionResult.fromJson(response.data);
    } else {
      return HistoryTransactionResult.fromJson(
          json.decode('{"status":false,"message":"Failed to get history","data":[]}'));
    }
  }

  Future<SummaryResult> getSummaryStore(String idUser) async {
    final response = await _dio.post("$_baseUrl/user/summary.php", data: {"id_user": idUser});
    if (response.statusCode == 200) {
      return SummaryResult.fromJson1(response.data);
    } else {
      return SummaryResult.fromJson2(
          json.decode('{"status":false,"message":"Failed to delete product"}'));
    }
  }

  Future<ListStoreResult> getListStore() async {
    final response = await _dio.get("$_baseUrl/store/list_store.php");
    if (response.statusCode == 200) {
      return ListStoreResult.fromJson(response.data);
    } else {
      return ListStoreResult.fromJson(
          json.decode('{"status":false, "message":"Failed to get list store", "data": []}'));
    }
  }

  Future<OrderStatusModel> getOrderStatus(String id) async {
    final response =
        await _dio.get("$_baseUrl/product/order_status.php", queryParameters: {"id_user": id});
    if (response.statusCode == 200) {
      return OrderStatusModel.fromJson(response.data);
    } else {
      return OrderStatusModel.fromJson(
          json.decode('{"status":false, "message":"Failed to delete product", "data": []}'));
    }
  }
}
