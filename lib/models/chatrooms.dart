import 'dart:convert';

Chatrooms usersFromJson(String str) => Chatrooms.fromJson(json.decode(str));

String usersToJson(Chatrooms data) => json.encode(data.toJson());

class Chatrooms {
  final String name;
  final String description;

  Chatrooms({
    required this.name,
    required this.description,
  });

  factory Chatrooms.fromJson(Map<String, dynamic> json) => Chatrooms(
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
      };
}
