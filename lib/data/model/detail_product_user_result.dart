class DetailProductUserResult {
  DetailProductUserResult({
    required this.status,
    required this.message,
    this.data,
  });

  bool status;
  String message;
  Product? data;

  factory DetailProductUserResult.fromJson(Map<String, dynamic> json) =>
      DetailProductUserResult(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Product.fromJson(json["data"]),
      );
}

class Product {
  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
