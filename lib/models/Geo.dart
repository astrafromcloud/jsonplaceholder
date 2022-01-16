import 'package:hive/hive.dart';

part 'Geo.g.dart';

@HiveType(typeId: 5)
class Geo extends HiveObject{
  @HiveField(0)
  String lat;
  @HiveField(1)
  String lng;

  Geo({
    required this.lat,
    required this.lng,
  });

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
