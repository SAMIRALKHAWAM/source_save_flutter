// To parse this JSON data, do
//
//     final getGroupAdminModel = getGroupAdminModelFromJson(jsonString);

import 'dart:convert';

GetGroupAdminModel getGroupAdminModelFromJson(String str) => GetGroupAdminModel.fromJson(json.decode(str));

String getGroupAdminModelToJson(GetGroupAdminModel data) => json.encode(data.toJson());

class GetGroupAdminModel {
  bool success;
  String message;
  int code;
  List<Datum> data;

  GetGroupAdminModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory GetGroupAdminModel.fromJson(Map<String, dynamic> json) => GetGroupAdminModel(
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
  String name;
  dynamic approvedBy;
  dynamic approvedAdminName;
  dynamic approvedAdminEmail;
  bool isAdmin;

  Datum({
    required this.id,
    required this.name,
    required this.approvedBy,
    required this.approvedAdminName,
    required this.approvedAdminEmail,
    required this.isAdmin,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    approvedBy: json["approved_by"],
    approvedAdminName: json["approved_admin_name"],
    approvedAdminEmail: json["approved_admin_email"],
    isAdmin: json["is_admin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "approved_by": approvedBy,
    "approved_admin_name": approvedAdminName,
    "approved_admin_email": approvedAdminEmail,
    "is_admin": isAdmin,
  };
}
