// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_store_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListStoreResult _$ListStoreResultFromJson(Map<String, dynamic> json) =>
    ListStoreResult(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListStoreResultToJson(ListStoreResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: json['id'] as int,
      image: json['image'] as String?,
      name: json['name'] as String?,
      address: AddressStore.fromJson(json['address'] as Map<String, dynamic>),
      email: json['email'] as String,
      phone: json['phone'] as int?,
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductStore.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'address': instance.address,
      'email': instance.email,
      'phone': instance.phone,
      'products': instance.products,
    };

AddressStore _$AddressStoreFromJson(Map<String, dynamic> json) => AddressStore(
      name: json['name'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddressStoreToJson(AddressStore instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

ProductStore _$ProductStoreFromJson(Map<String, dynamic> json) => ProductStore(
      id: json['id'] as int,
      idUser: json['id_user'] as int,
      idProduct: json['id_product'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as int,
      stock: json['stock'] as int,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProductStoreToJson(ProductStore instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'id_product': instance.idProduct,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'stock': instance.stock,
      'image': instance.image,
    };
