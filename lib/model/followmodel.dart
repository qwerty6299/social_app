// To parse this JSON data, do
//
//     final followModel = followModelFromJson(jsonString);

import 'dart:convert';

FollowModel followModelFromJson(String str) => FollowModel.fromJson(json.decode(str));

String followModelToJson(FollowModel data) => json.encode(data.toJson());

class FollowModel {
  FollowModel({
    required this.code,
    required  this.status,
    required  this.message,
    required this.action,

  });

  int code;
  String status;
  String message;
  String action;


  factory FollowModel.fromJson(Map<String, dynamic> json) => FollowModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    action: json["ACTION"],

  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "ACTION": action,

  };
}

