class GeneralResult {
  GeneralResult({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory GeneralResult.fromJson(Map<String, dynamic> json) => GeneralResult(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
