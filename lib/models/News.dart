import 'package:hive/hive.dart';

part 'News.g.dart';

@HiveType(typeId: 6)
class News extends HiveObject{
  @HiveField(0)
  int userId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;
  @HiveField(3)
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
