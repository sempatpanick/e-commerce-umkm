import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'cart_buyer_model.g.dart';

List<CartBuyerModel> cartBuyerModelFromJson(String str) =>
    List<CartBuyerModel>.from(
        json.decode(str).map((x) => CartBuyerModel.fromJson(x)));

String cartBuyerModelToJson(List<CartBuyerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class CartBuyerModel {
  @JsonKey(name: 'id_store')
  int idStore;
  List<ProductCart> products;

  CartBuyerModel({required this.idStore, required this.products});

  factory CartBuyerModel.fromJson(Map<String, dynamic> json) =>
      _$CartBuyerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartBuyerModelToJson(this);
}

@JsonSerializable()
class ProductCart {
  @JsonKey(name: 'id_product')
  int idProduct;
  int price;
  int amount;
  String description;

  ProductCart(
      {required this.idProduct,
      required this.price,
      required this.amount,
      required this.description});

  factory ProductCart.fromJson(Map<String, dynamic> json) =>
      _$ProductCartFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCartToJson(this);
}
