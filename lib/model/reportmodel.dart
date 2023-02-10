// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  ReportModel({
    required    this.message,
    required   this.data,
  });

  String message;
  Data data;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required  this.appKey,
    required   this.uid,
    required this.luid,
  });

  String appKey;
  String uid;
  String luid;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    appKey: json["APP_KEY"],
    uid: json["UID"],
    luid: json["LUID"],
  );

  Map<String, dynamic> toJson() => {
    "APP_KEY": appKey,
    "UID": uid,
    "LUID": luid,
  };
}
