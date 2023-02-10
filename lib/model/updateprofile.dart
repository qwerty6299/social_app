// To parse this JSON data, do
//
//     final updateprofileModel = updateprofileModelFromJson(jsonString);

import 'dart:convert';

UpdateprofileModel updateprofileModelFromJson(String str) => UpdateprofileModel.fromJson(json.decode(str));

String updateprofileModelToJson(UpdateprofileModel data) => json.encode(data.toJson());

class UpdateprofileModel {
  UpdateprofileModel({
    required this.code,
    required  this.status,
    required   this.message,

  });

  int code;
  String status;
  String message;


  factory UpdateprofileModel.fromJson(Map<String, dynamic> json) => UpdateprofileModel(
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

class Data {
  Data({
    required   this.id,
  });

  String id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["ID"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
  };
}
