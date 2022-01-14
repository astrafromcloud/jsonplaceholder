import 'package:hive/hive.dart';

part 'Checks.g.dart';

@HiveType(typeId: 0)
class Checks extends HiveObject {
  @HiveField(0)
  int userId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;
  @HiveField(3)
  bool completed;

  Checks({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed
  });

  factory Checks.fromJson(Map<String, dynamic> json) => Checks(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed
  };
}
