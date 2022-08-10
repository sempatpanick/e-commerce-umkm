class NewsResult {
  NewsResult({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<News> data;

  factory NewsResult.fromJson(Map<String, dynamic> json) => NewsResult(
    status: json["status"],
    message: json["message"],
    data: List<News>.from(json["data"].map((x) => News.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class News {
  News({
    required this.id,
    required this.title,
    this.headline,
    required this.content,
    required this.author,
    required this.date,
  });

  String id;
  String title;
  String? headline;
  String content;
  String author;
  DateTime date;

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    title: json["title"],
    headline: json["headline"],
    content: json["content"],
    author: json["author"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "headline": headline,
    "content": content,
    "author": author,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
