
class GetFileModel {
  bool success;
  String message;
  int code;
  Data data;

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
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  Headers headers;
  Original original;
  dynamic exception;

  Data({
    required this.headers,
    required this.original,
    required this.exception,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    headers: Headers.fromJson(json["headers"]),
    original: Original.fromJson(json["original"]),
    exception: json["exception"],
  );

  Map<String, dynamic> toJson() => {
    "headers": headers.toJson(),
    "original": original.toJson(),
    "exception": exception,
  };
}

class Headers {
  Headers();

  factory Headers.fromJson(Map<String, dynamic> json) => Headers(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Original {
  bool success;
  String message;
  int code;
  List<Datum> data;

  Original({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory Original.fromJson(Map<String, dynamic> json) => Original(
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
  dynamic reservedBy;
  int userId;
  String userName;

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
    required this.userId,
    required this.userName,
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
    userId: json["user_id"],
    userName: json["user_name"],
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
    "user_id": userId,
    "user_name": userName,
  };
}
