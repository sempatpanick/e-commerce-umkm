class SummaryResult {
  SummaryResult({
    required this.status,
    required this.message,
    this.data,
  });

  bool status;
  String message;
  Summary? data;

  factory SummaryResult.fromJson1(Map<String, dynamic> json) => SummaryResult(
    status: json["status"],
    message: json["message"],
    data: Summary.fromJson(json["data"]),
  );

  factory SummaryResult.fromJson2(Map<String, dynamic> json) => SummaryResult(
    status: json["status"],
    message: json["message"],
  );
}

class Summary {
  Summary({
    required this.totalOrders,
    required this.todayOrders,
    required this.monthOrders,
    required this.yearOrders,
    required this.totalTodayRevenue,
    required this.totalMonthRevenue,
    required this.totalYearRevenue,
    required this.totalRevenue,
    required this.totalProducts,
  });

  int totalOrders;
  int todayOrders;
  int monthOrders;
  int yearOrders;
  int totalTodayRevenue;
  int totalMonthRevenue;
  int totalYearRevenue;
  int totalRevenue;
  int totalProducts;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalOrders: json["total_orders"],
    todayOrders: json["today_orders"],
    monthOrders: json["month_orders"],
    yearOrders: json["year_orders"],
    totalTodayRevenue: json["total_today_revenue"],
    totalMonthRevenue: json["total_month_revenue"],
    totalYearRevenue: json["total_year_revenue"],
    totalRevenue: json["total_revenue"],
    totalProducts: json["total_products"],
  );

  Map<String, dynamic> toJson() => {
    "total_orders": totalOrders,
    "today_orders": todayOrders,
    "month_orders": monthOrders,
    "year_orders": yearOrders,
    "total_today_revenue": totalTodayRevenue,
    "total_month_revenue": totalMonthRevenue,
    "total_year_revenue": totalYearRevenue,
    "total_revenue": totalRevenue,
    "total_products": totalProducts,
  };
}
