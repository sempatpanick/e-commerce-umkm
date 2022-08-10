class RegisterResult {
  RegisterResult({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory RegisterResult.fromJson(Map<String, dynamic> json) => RegisterResult(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
