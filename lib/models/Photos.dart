import 'package:hive/hive.dart';

part 'Photos.g.dart';

@HiveType(typeId: 7)
class Photos extends HiveObject{
  @HiveField(0)
  int albumId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;
  @HiveField(3)
  String url;
  @HiveField(4)
  String thumbnailUrl;

  Photos({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photos.fromJson(Map<String, dynamic> json) => Photos(
    albumId: json["albumId"],
    id: json["id"],
    title: json["title"],
    url: json["url"],
    thumbnailUrl: json["thumbnailUrl"],
  );

  Map<String, dynamic> toJson() => {
    "albumId": albumId,
    "id": id,
    "title": title,
    "url": url,
    "thumbnailUrl": thumbnailUrl,
  };
}
