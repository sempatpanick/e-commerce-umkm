import 'package:json_annotation/json_annotation.dart';

part 'order_status_model.g.dart';

@JsonSerializable()
class OrderStatusModel {
  bool status;
  String message;
  List<OrderStatus> data;

  OrderStatusModel({required this.status, required this.message, required this.data});

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) => _$OrderStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusModelToJson(this);
}

@JsonSerializable()
class OrderStatus {
  int id;
  @JsonKey(name: 'id_users')
  int idUser;
  OrderStatusStore store;
  List<OrderStatusProduct> products;
  @JsonKey(name: 'shipping_cost')
  int shippingCost;
  int bill;
  int paid;
  @JsonKey(name: 'change_bill')
  int changeBill;
  int status;
  @JsonKey(name: 'datetime_transaction')
  String datetimeTransaction;

  OrderStatus(
      {required this.id,
      required this.idUser,
      required this.store,
      required this.products,
      required this.shippingCost,
      required this.bill,
      required this.paid,
      required this.changeBill,
      required this.status,
      required this.datetimeTransaction});

  factory OrderStatus.fromJson(Map<String, dynamic> json) => _$OrderStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusToJson(this);
}

@JsonSerializable()
class OrderStatusStore {
  int id;
  String? name;
  OrderStatusStoreAddress address;
  String? avatar;

  OrderStatusStore(
      {required this.id, required this.name, required this.address, required this.avatar});

  factory OrderStatusStore.fromJson(Map<String, dynamic> json) => _$OrderStatusStoreFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusStoreToJson(this);
}

@JsonSerializable()
class OrderStatusStoreAddress {
  String name;
  double latitude;
  double longitude;

  OrderStatusStoreAddress({required this.name, required this.latitude, required this.longitude});

  factory OrderStatusStoreAddress.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusStoreAddressFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusStoreAddressToJson(this);
}

@JsonSerializable()
class OrderStatusProduct {
  @JsonKey(name: 'id_product')
  int idProduct;
  String name;
  int amount;
  int price;

  OrderStatusProduct(
      {required this.idProduct, required this.name, required this.amount, required this.price});

  factory OrderStatusProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusProductToJson(this);
}
