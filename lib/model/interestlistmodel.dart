// To parse this JSON data, do
//
//     final interestListModel = interestListModelFromJson(jsonString);

import 'dart:convert';

InterestListModel interestListModelFromJson(String str) => InterestListModel.fromJson(json.decode(str));

String interestListModelToJson(InterestListModel data) => json.encode(data.toJson());

class InterestListModel {
  InterestListModel({
    required   this.code,
    required  this.status,
    required this.message,
    required this.interestList,
     this.token,
  });

  int code;
  String status;
  String message;
  List<InterestList> interestList;
  String? token;

  factory InterestListModel.fromJson(Map<String, dynamic> json) => InterestListModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    interestList: List<InterestList>.from(json["INTEREST_LIST"].map((x) => InterestList.fromJson(x))),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "INTEREST_LIST": List<dynamic>.from(interestList.map((x) => x.toJson())),
    "token": token,
  };
}

class InterestList {
  InterestList({
     this.status,
     this.createdTime,
      this.id,

    required   this.icon,
    required this.name,
  });

  int? status;
  DateTime? createdTime;
  String? id;

  String icon;
  String name;

  factory InterestList.fromJson(Map<String, dynamic> json) => InterestList(
    status: json["status"],
    createdTime: DateTime.parse(json["created_time"]),
    id: json["_id"],

    icon: json["icon"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "created_time": createdTime?.toIso8601String(),
    "_id": id,

    "icon": icon,
    "name": name,
  };
}
