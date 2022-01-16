import 'package:hive/hive.dart';

part 'Company.g.dart';

@HiveType(typeId: 4)
class Company extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  String catchPhrase;
  @HiveField(2)
  String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        name: json["name"],
        catchPhrase: json["catchPhrase"],
        bs: json["bs"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "catchPhrase": catchPhrase,
        "bs": bs,
      };
}
