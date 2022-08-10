// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatusModel _$OrderStatusModelFromJson(Map<String, dynamic> json) =>
    OrderStatusModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => OrderStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderStatusModelToJson(OrderStatusModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

OrderStatus _$OrderStatusFromJson(Map<String, dynamic> json) => OrderStatus(
      id: json['id'] as int,
      idUser: json['id_users'] as int,
      store: OrderStatusStore.fromJson(json['store'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((e) => OrderStatusProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingCost: json['shipping_cost'] as int,
      bill: json['bill'] as int,
      paid: json['paid'] as int,
      changeBill: json['change_bill'] as int,
      status: json['status'] as int,
      datetimeTransaction: json['datetime_transaction'] as String,
    );

Map<String, dynamic> _$OrderStatusToJson(OrderStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_users': instance.idUser,
      'store': instance.store,
      'products': instance.products,
      'shipping_cost': instance.shippingCost,
      'bill': instance.bill,
      'paid': instance.paid,
      'change_bill': instance.changeBill,
      'status': instance.status,
      'datetime_transaction': instance.datetimeTransaction,
    };

OrderStatusStore _$OrderStatusStoreFromJson(Map<String, dynamic> json) =>
    OrderStatusStore(
      id: json['id'] as int,
      name: json['name'] as String?,
      address: OrderStatusStoreAddress.fromJson(
          json['address'] as Map<String, dynamic>),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$OrderStatusStoreToJson(OrderStatusStore instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'avatar': instance.avatar,
    };

OrderStatusStoreAddress _$OrderStatusStoreAddressFromJson(
        Map<String, dynamic> json) =>
    OrderStatusStoreAddress(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderStatusStoreAddressToJson(
        OrderStatusStoreAddress instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

OrderStatusProduct _$OrderStatusProductFromJson(Map<String, dynamic> json) =>
    OrderStatusProduct(
      idProduct: json['id_product'] as int,
      name: json['name'] as String,
      amount: json['amount'] as int,
      price: json['price'] as int,
    );

Map<String, dynamic> _$OrderStatusProductToJson(OrderStatusProduct instance) =>
    <String, dynamic>{
      'id_product': instance.idProduct,
      'name': instance.name,
      'amount': instance.amount,
      'price': instance.price,
    };
