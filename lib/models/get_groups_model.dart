
class GetGroupsModel {
  bool success;
  String message;
  int code;
  List<Datum> data;

  GetGroupsModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory GetGroupsModel.fromJson(Map<String, dynamic> json) => GetGroupsModel(
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

  Datum({
    required this.id,
    required this.name,
    required this.approvedBy,
    required this.approvedAdminName,
    required this.approvedAdminEmail,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    approvedBy: json["approved_by"],
    approvedAdminName: json["approved_admin_name"],
    approvedAdminEmail: json["approved_admin_email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "approved_by": approvedBy,
    "approved_admin_name": approvedAdminName,
    "approved_admin_email": approvedAdminEmail,
  };
}
