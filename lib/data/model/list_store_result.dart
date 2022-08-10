import 'package:json_annotation/json_annotation.dart';

part 'list_store_result.g.dart';

@JsonSerializable()
class ListStoreResult {
  bool status;
  String message;
  List<Store> data;

  ListStoreResult(
      {required this.status, required this.message, required this.data});

  factory ListStoreResult.fromJson(Map<String, dynamic> json) =>
      _$ListStoreResultFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoreResultToJson(this);
}

@JsonSerializable()
class Store {
  int id;
  String? image;
  String? name;
  AddressStore address;
  String email;
  int? phone;
  List<ProductStore> products;

  Store(
      {required this.id,
      this.image,
      this.name,
      required this.address,
      required this.email,
      this.phone,
      required this.products});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
class AddressStore {
  String? name;
  double? latitude;
  double? longitude;

  AddressStore({this.name, this.latitude, this.longitude});

  factory AddressStore.fromJson(Map<String, dynamic> json) =>
      _$AddressStoreFromJson(json);

  Map<String, dynamic> toJson() => _$AddressStoreToJson(this);
}

@JsonSerializable()
class ProductStore {
  int id;
  @JsonKey(name: 'id_user')
  int idUser;
  @JsonKey(name: 'id_product')
  int idProduct;
  String name;
  String? description;
  int price;
  int stock;
  String? image;

  ProductStore(
      {required this.id,
      required this.idUser,
      required this.idProduct,
      required this.name,
      this.description,
      required this.price,
      required this.stock,
      this.image});

  factory ProductStore.fromJson(Map<String, dynamic> json) =>
      _$ProductStoreFromJson(json);

  Map<String, dynamic> toJson() => _$ProductStoreToJson(this);
}
