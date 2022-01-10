class News {
  int userId;
  int id;
  String title;
  String body;

  News({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}
