// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_buyer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartBuyerModel _$CartBuyerModelFromJson(Map<String, dynamic> json) =>
    CartBuyerModel(
      idStore: json['id_store'] as int,
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductCart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartBuyerModelToJson(CartBuyerModel instance) =>
    <String, dynamic>{
      'id_store': instance.idStore,
      'products': instance.products,
    };

ProductCart _$ProductCartFromJson(Map<String, dynamic> json) => ProductCart(
      idProduct: json['id_product'] as int,
      price: json['price'] as int,
      amount: json['amount'] as int,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ProductCartToJson(ProductCart instance) =>
    <String, dynamic>{
      'id_product': instance.idProduct,
      'price': instance.price,
      'amount': instance.amount,
      'description': instance.description,
    };
