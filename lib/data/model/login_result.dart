class LoginResult {
  LoginResult({
    required this.status,
    required this.message,
    this.user,
  });

  bool status;
  String message;
  User? user;

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        status: json["status"],
        message: json["message"],
        user: json["data"] == null ? null : User.fromJson(json["data"]),
      );
}

class User {
  User(
      {required this.id,
      this.username,
      required this.email,
      required this.password,
      this.nama,
      this.alamat,
      this.latitude,
      this.longitude,
      this.noTelp,
      this.avatar,
      required this.role,
      required this.activate});

  String id;
  String? username;
  String email;
  String password;
  String? nama;
  String? alamat;
  String? latitude;
  String? longitude;
  String? noTelp;
  String? avatar;
  String role;
  String activate;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      password: json["password"],
      nama: json["nama"],
      alamat: json["alamat"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      noTelp: json["no_telp"],
      avatar: json["avatar"],
      role: json["role"],
      activate: json["activate"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "nama": nama,
        "alamat": alamat,
        "latitude": latitude,
        "longitude": longitude,
        "noTelp": noTelp,
        "avatar": avatar,
        "role": role,
      };
}
