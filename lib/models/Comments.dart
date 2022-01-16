import 'package:hive/hive.dart';

part 'Comments.g.dart';

@HiveType(typeId: 3)
class Comments extends HiveObject{
  @HiveField(0)
  int postId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String body;
  @HiveField(4)
  String email;

  Comments({
    required this.postId,
    required this.id,
    required this.name,
    required this.body,
    required this.email
  });

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    postId: json["postId"],
    id: json["id"],
    name: json["name"],
    body: json["body"],
    email: json["email"]
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "id": id,
    "name": name,
    "body": body,
    "email": email
  };
}
