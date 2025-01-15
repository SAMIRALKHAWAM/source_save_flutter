// To parse this JSON data, do
//
//     final getUserGroup = getUserGroupFromJson(jsonString);

import 'dart:convert';

GetUserGroup getUserGroupFromJson(String str) => GetUserGroup.fromJson(json.decode(str));

String getUserGroupToJson(GetUserGroup data) => json.encode(data.toJson());

class GetUserGroup {
  bool success;
  String message;
  int code;
  List<Datum> data;

  GetUserGroup({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory GetUserGroup.fromJson(Map<String, dynamic> json) => GetUserGroup(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  int userId;
  int isAdmin;
  String userName;
  String userEmail;

  Datum({
    required this.id,
    required this.userId,
    required this.isAdmin,
    required this.userName,
    required this.userEmail,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    isAdmin: json["is_admin"],
    userName: json["user_name"],
    userEmail: json["user_email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "is_admin": isAdmin,
    "user_name": userName,
    "user_email": userEmail,
  };
}
