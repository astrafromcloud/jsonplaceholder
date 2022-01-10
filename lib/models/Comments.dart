class Comments {
  int postId;
  int id;
  String name;
  String body;
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
