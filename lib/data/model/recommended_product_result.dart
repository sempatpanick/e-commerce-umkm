class RecommendedProductResult {
  RecommendedProductResult({
    required this.status,
    required this.message,
    this.data,
  });

  bool status;
  String message;
  RecommendedProduct? data;

  factory RecommendedProductResult.fromJson1(Map<String, dynamic> json) => RecommendedProductResult(
    status: json["status"],
    message: json["message"],
    data: RecommendedProduct.fromJson(json["data"]),
  );

  factory RecommendedProductResult.fromJson2(Map<String, dynamic> json) => RecommendedProductResult(
    status: json["status"],
    message: json["message"],
  );
}

class RecommendedProduct {
  RecommendedProduct({
    required this.id,
    required this.nama,
    this.keterangan,
    required this.harga,
    this.stok,
    this.gambar,
  });

  String id;
  String nama;
  String? keterangan;
  String harga;
  String? stok;
  String? gambar;

  factory RecommendedProduct.fromJson(Map<String, dynamic> json) => RecommendedProduct(
    id: json["id"],
    nama: json["nama"],
    keterangan: json["keterangan"],
    harga: json["harga"],
    gambar: json["gambar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "keterangan": keterangan,
    "harga": harga,
    "gambar": gambar,
  };
}
