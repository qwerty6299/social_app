// To parse this JSON data, do
//
//     final likedresponse = likedresponseFromJson(jsonString);

import 'dart:convert';

Likedresponse likedresponseFromJson(String str) => Likedresponse.fromJson(json.decode(str));

String likedresponseToJson(Likedresponse data) => json.encode(data.toJson());

class Likedresponse {
  Likedresponse({
    required this.code,
    required this.status,
    required  this.check,
    required  this.message,
  });

  int code;
  String status;
  bool check;
  String message;

  factory Likedresponse.fromJson(Map<String, dynamic> json) => Likedresponse(
    code: json["code"],
    status: json["STATUS"],
    check: json["CHECK"],
    message: json["MESSAGE"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "CHECK": check,
    "MESSAGE": message,
  };
}
