// To parse this JSON data, do
//
//     final comementLikeModel = comementLikeModelFromJson(jsonString);

import 'dart:convert';

ComementLikeModel comementLikeModelFromJson(String str) => ComementLikeModel.fromJson(json.decode(str));

String comementLikeModelToJson(ComementLikeModel data) => json.encode(data.toJson());

class ComementLikeModel {
  ComementLikeModel({
   required this.code,
    required  this.status,
    required  this.message,

  });

  int code;
  String status;
  String message;


  factory ComementLikeModel.fromJson(Map<String, dynamic> json) => ComementLikeModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],

  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,

  };
}


