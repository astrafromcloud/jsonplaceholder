class Checks {
  int userId;
  int id;
  String title;
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
