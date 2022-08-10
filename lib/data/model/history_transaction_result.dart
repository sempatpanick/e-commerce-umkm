class HistoryTransactionResult {
  HistoryTransactionResult({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Transaction> data;

  factory HistoryTransactionResult.fromJson(Map<String, dynamic> json) => HistoryTransactionResult(
        status: json["status"],
        message: json["message"],
        data: List<Transaction>.from(json["data"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    required this.id,
    required this.idUsers,
    required this.bill,
    this.paid,
    this.changeBill,
    required this.datetimeTransaction,
    required this.items,
  });

  String id;
  String idUsers;
  String bill;
  String? paid;
  String? changeBill;
  DateTime datetimeTransaction;
  List<Item> items;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        idUsers: json["id_users"],
        bill: json["bill"],
        paid: json["paid"],
        changeBill: json["change_bill"],
        datetimeTransaction: DateTime.parse(json["datetime_transaction"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_users": idUsers,
        "bill": bill,
        "paid": paid,
        "change_bill": changeBill,
        "datetime_transaction": datetimeTransaction.toIso8601String(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.idTransaction,
    required this.idProduk,
    required this.name,
    required this.amount,
    required this.price,
  });

  String idTransaction;
  String idProduk;
  String name;
  String amount;
  String price;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        idTransaction: json["id_transaction"],
        idProduk: json["id_produk"],
        name: json["name"],
        amount: json["amount"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id_transaction": idTransaction,
        "id_produk": idProduk,
        "name": name,
        "amount": amount,
        "price": price,
      };
}
