// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineOrderModel _$OnlineOrderModelFromJson(Map<String, dynamic> json) =>
    OnlineOrderModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => OnlineOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OnlineOrderModelToJson(OnlineOrderModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

OnlineOrder _$OnlineOrderFromJson(Map<String, dynamic> json) => OnlineOrder(
      id: json['id'] as int,
      idStore: json['id_store'] as int,
      buyer: OnlineOrderBuyer.fromJson(json['buyer'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((e) => OnlineOrderProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingCost: json['shipping_cost'] as int,
      bill: json['bill'] as int,
      paid: json['paid'] as int,
      changeBill: json['change_bill'] as int,
      status: json['status'] as int,
      datetimeTransaction: json['datetime_transaction'] as String,
    );

Map<String, dynamic> _$OnlineOrderToJson(OnlineOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_store': instance.idStore,
      'buyer': instance.buyer,
      'products': instance.products,
      'shipping_cost': instance.shippingCost,
      'bill': instance.bill,
      'paid': instance.paid,
      'change_bill': instance.changeBill,
      'status': instance.status,
      'datetime_transaction': instance.datetimeTransaction,
    };

OnlineOrderBuyer _$OnlineOrderBuyerFromJson(Map<String, dynamic> json) =>
    OnlineOrderBuyer(
      id: json['id'] as int,
      name: json['name'] as String?,
      address: OnlineOrderBuyerAddress.fromJson(
          json['address'] as Map<String, dynamic>),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$OnlineOrderBuyerToJson(OnlineOrderBuyer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'avatar': instance.avatar,
    };

OnlineOrderBuyerAddress _$OnlineOrderBuyerAddressFromJson(
        Map<String, dynamic> json) =>
    OnlineOrderBuyerAddress(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$OnlineOrderBuyerAddressToJson(
        OnlineOrderBuyerAddress instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

OnlineOrderProduct _$OnlineOrderProductFromJson(Map<String, dynamic> json) =>
    OnlineOrderProduct(
      idProduct: json['id_product'] as int,
      name: json['name'] as String,
      amount: json['amount'] as int,
      price: json['price'] as int,
    );

Map<String, dynamic> _$OnlineOrderProductToJson(OnlineOrderProduct instance) =>
    <String, dynamic>{
      'id_product': instance.idProduct,
      'name': instance.name,
      'amount': instance.amount,
      'price': instance.price,
    };
