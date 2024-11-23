import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  final String country;
  final String email;
  final String id;
  final String name;

  Users({
    required this.country,
    required this.email,
    required this.id,
    required this.name,
  });

  Users copyWith({
    String? country,
    String? email,
    String? id,
    String? name,
  }) =>
      Users(
        country: country ?? this.country,
        email: email ?? this.email,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        country: json["country"],
        email: json["email"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "email": email,
        "id": id,
        "name": name,
      };
}
