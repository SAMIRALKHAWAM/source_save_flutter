// To parse this JSON data, do
//
//     final getFileModel = getFileModelFromJson(jsonString);

import 'dart:convert';

GetFileModel getFileModelFromJson(String str) => GetFileModel.fromJson(json.decode(str));

String getFileModelToJson(GetFileModel data) => json.encode(data.toJson());

class GetFileModel {
  bool success;
  String message;
  int code;
  List<Datum> data;

  GetFileModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory GetFileModel.fromJson(Map<String, dynamic> json) => GetFileModel(
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
  int groupUserId;
  String name;
  String description;
  double sizeMb;
  String url;
  int availability;
  String status;
  int? reservedBy;
  DateTime createdAt;
  int userId;
  String userName;
  int color;

  Datum({
    required this.id,
    required this.groupUserId,
    required this.name,
    required this.description,
    required this.sizeMb,
    required this.url,
    required this.availability,
    required this.status,
    required this.reservedBy,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.color,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    groupUserId: json["group_user_id"],
    name: json["name"],
    description: json["description"],
    sizeMb: json["size_MB"]?.toDouble(),
    url: json["url"],
    availability: json["availability"],
    status: json["status"],
    reservedBy: json["reserved_by"],
    createdAt: DateTime.parse(json["created_at"]),
    userId: json["user_id"],
    userName: json["user_name"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "group_user_id": groupUserId,
    "name": name,
    "description": description,
    "size_MB": sizeMb,
    "url": url,
    "availability": availability,
    "status": status,
    "reserved_by": reservedBy,
    "created_at": createdAt.toIso8601String(),
    "user_id": userId,
    "user_name": userName,
    "color": color,
  };
}
