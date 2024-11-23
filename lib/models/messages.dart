import 'dart:convert';

Messages usersFromJson(String str) => Messages.fromJson(json.decode(str));

String usersToJson(Messages data) => json.encode(data.toJson());

class Messages {
  final String name;
  final String text;
  final String chatroomId;
  final String userId;
  final dynamic timestamp;

  Messages({
    required this.name,
    required this.text,
    required this.chatroomId,
    required this.timestamp,
    required this.userId,
  });

  Messages copyWith({
    String? name,
    String? text,
    String? chatroomId,
    String? timestamp,
    String? userId,
  }) =>
      Messages(
        name: name ?? this.name,
        text: text ?? this.text,
        chatroomId: chatroomId ?? this.chatroomId,
        timestamp: timestamp ?? this.timestamp,
        userId: userId ?? this.userId,
      );

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        name: json["name"],
        text: json["text"],
        chatroomId: json["chatroom_id"],
        timestamp: json["timestamp"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "text": text,
        "chatroom_id": chatroomId,
        "timestamp": timestamp,
        "user_id": userId,
      };
}
