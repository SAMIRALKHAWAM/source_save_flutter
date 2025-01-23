// To parse this JSON data, do
//
//     final differentModel = differentModelFromJson(jsonString);

import 'dart:convert';

DifferentModel differentModelFromJson(String str) => DifferentModel.fromJson(json.decode(str));

String differentModelToJson(DifferentModel data) => json.encode(data.toJson());

class DifferentModel {
  bool success;
  String message;
  int code;
  List<Datum> data;

  DifferentModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory DifferentModel.fromJson(Map<String, dynamic> json) => DifferentModel(
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
  int fileId;
  int groupUserId;
  String name;
  String description;
  double sizeMb;
  String url;
  String diff;
  int userId;
  String userName;

  Datum({
    required this.id,
    required this.fileId,
    required this.groupUserId,
    required this.name,
    required this.description,
    required this.sizeMb,
    required this.url,
    required this.diff,
    required this.userId,
    required this.userName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    fileId: json["file_id"],
    groupUserId: json["group_user_id"],
    name: json["name"],
    description: json["description"],
    sizeMb: json["size_MB"]?.toDouble(),
    url: json["url"],
    diff: json["diff"],
    userId: json["user_id"],
    userName: json["user_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file_id": fileId,
    "group_user_id": groupUserId,
    "name": name,
    "description": description,
    "size_MB": sizeMb,
    "url": url,
    "diff": diff,
    "user_id": userId,
    "user_name": userName,
  };
}
