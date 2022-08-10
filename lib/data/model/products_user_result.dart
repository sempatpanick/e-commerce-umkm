class ProductsUserResult {
  ProductsUserResult({
    required this.status,
    required this.message,
    this.data,
  });

  bool status;
  String message;
  List<Products>? data;

  factory ProductsUserResult.fromJson1(Map<String, dynamic> json) =>
      ProductsUserResult(
        status: json["status"],
        message: json["message"],
        data:
            List<Products>.from(json["data"].map((x) => Products.fromJson(x))),
      );

  // factory ProductsUserResult.fromJson(Map<String, dynamic> json) => ProductsUserResult(
  //   status: json["status"],
  //   message: json["message"],
  // )..data = (json['data'] as List<dynamic>?)
  //     ?.map((e) => Products.fromJson(e as Map<String, dynamic>))
  //     .toList();

  factory ProductsUserResult.fromJson2(Map<String, dynamic> json) =>
      ProductsUserResult(
        status: json["status"],
        message: json["message"],
      );
}

class Products {
  Products({
    required this.id,
    required this.idUsers,
    required this.idProduk,
    required this.nama,
    this.keterangan,
    required this.harga,
    required this.stok,
    this.gambar,
  });

  String id;
  String idUsers;
  String idProduk;
  String nama;
  String? keterangan;
  String harga;
  String stok;
  String? gambar;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["id"],
        idUsers: json["id_users"],
        idProduk: json["id_produk"],
        nama: json["nama"],
        keterangan: json["keterangan"],
        harga: json["harga"],
        stok: json["stok"],
        gambar: json["gambar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_users": idUsers,
        "id_produk": idProduk,
        "nama": nama,
        "keterangan": keterangan,
        "harga": harga,
        "stok": stok,
        "gambar": gambar,
      };
}
