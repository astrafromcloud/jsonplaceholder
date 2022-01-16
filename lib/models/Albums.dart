import 'package:hive/hive.dart';

part 'Albums.g.dart';

@HiveType(typeId: 2)
class Albums extends HiveObject{
  @HiveField(0)
  int userId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;

  Albums({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
  };
}
