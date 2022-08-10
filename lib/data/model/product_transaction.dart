class ProductTransaction {
  ProductTransaction({
    required this.idProduct,
    required this.amount,
    required this.price,
  });

  String idProduct;
  int amount;
  int price;

  factory ProductTransaction.fromJson(Map<String, dynamic> json) => ProductTransaction(
    idProduct: json["id_product"],
    amount: json["amount"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id_product"] = idProduct;
    map["amount"] = amount;
    map["price"] = price;
    return map;
  }
}
