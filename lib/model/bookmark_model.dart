// To parse this JSON data, do
//
//     final bookmarkModel = bookmarkModelFromJson(jsonString);

import 'dart:convert';

BookmarkModel bookmarkModelFromJson(String str) => BookmarkModel.fromJson(json.decode(str));

String bookmarkModelToJson(BookmarkModel data) => json.encode(data.toJson());

class BookmarkModel {
  BookmarkModel({
    required  this.code,
    required this.status,
    required   this.message,

  });

  int code;
  String status;
  String message;


  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
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
    required this.id,
  });

  String id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["ID"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
  };
}
