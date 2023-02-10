// To parse this JSON data, do
//
//     final blockModel = blockModelFromJson(jsonString);

import 'dart:convert';

BlockModel blockModelFromJson(String str) => BlockModel.fromJson(json.decode(str));

String blockModelToJson(BlockModel data) => json.encode(data.toJson());

class BlockModel {
  BlockModel({
    required   this.message,
    required  this.data,
  });

  String message;
  Data data;

  factory BlockModel.fromJson(Map<String, dynamic> json) => BlockModel(
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
    required this.appKey,
    required  this.uid,
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
