import 'package:json_annotation/json_annotation.dart';

part 'online_order_model.g.dart';

@JsonSerializable()
class OnlineOrderModel {
  bool status;
  String message;
  List<OnlineOrder> data;

  OnlineOrderModel({required this.status, required this.message, required this.data});

  factory OnlineOrderModel.fromJson(Map<String, dynamic> json) => _$OnlineOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineOrderModelToJson(this);
}

@JsonSerializable()
class OnlineOrder {
  int id;
  @JsonKey(name: 'id_store')
  int idStore;
  OnlineOrderBuyer buyer;
  List<OnlineOrderProduct> products;
  @JsonKey(name: 'shipping_cost')
  int shippingCost;
  int bill;
  int paid;
  @JsonKey(name: 'change_bill')
  int changeBill;
  int status;
  @JsonKey(name: 'datetime_transaction')
  String datetimeTransaction;

  OnlineOrder(
      {required this.id,
      required this.idStore,
      required this.buyer,
      required this.products,
      required this.shippingCost,
      required this.bill,
      required this.paid,
      required this.changeBill,
      required this.status,
      required this.datetimeTransaction});

  factory OnlineOrder.fromJson(Map<String, dynamic> json) => _$OnlineOrderFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineOrderToJson(this);
}

@JsonSerializable()
class OnlineOrderBuyer {
  int id;
  String? name;
  OnlineOrderBuyerAddress address;
  String? avatar;

  OnlineOrderBuyer(
      {required this.id, required this.name, required this.address, required this.avatar});

  factory OnlineOrderBuyer.fromJson(Map<String, dynamic> json) => _$OnlineOrderBuyerFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineOrderBuyerToJson(this);
}

@JsonSerializable()
class OnlineOrderBuyerAddress {
  String name;
  double latitude;
  double longitude;

  OnlineOrderBuyerAddress({required this.name, required this.latitude, required this.longitude});

  factory OnlineOrderBuyerAddress.fromJson(Map<String, dynamic> json) =>
      _$OnlineOrderBuyerAddressFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineOrderBuyerAddressToJson(this);
}

@JsonSerializable()
class OnlineOrderProduct {
  @JsonKey(name: 'id_product')
  int idProduct;
  String name;
  int amount;
  int price;

  OnlineOrderProduct(
      {required this.idProduct, required this.name, required this.amount, required this.price});

  factory OnlineOrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OnlineOrderProductFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineOrderProductToJson(this);
}
