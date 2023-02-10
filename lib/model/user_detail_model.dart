// To parse this JSON data, do
//
//     final userdetailModel = userdetailModelFromJson(jsonString);

import 'dart:convert';

UserdetailModel userdetailModelFromJson(String str) => UserdetailModel.fromJson(json.decode(str));

String userdetailModelToJson(UserdetailModel data) => json.encode(data.toJson());

class UserdetailModel {
  UserdetailModel({
    required this.status,
    required  this.code,
    required  this.data,
  });

  String status;
  int code;
  Data data;

  factory UserdetailModel.fromJson(Map<String, dynamic> json) => UserdetailModel(
    status: json["status"],
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required  this.username,
    required  this.firstName,
    required  this.lastName,
    required  this.profilePic,
    required  this.bio,
    required   this.id,
  });

  String username;
  String firstName;
  String lastName;
  String profilePic;
  String bio;
  String id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePic: json["profile_pic"],
    bio: json["bio"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "profile_pic": profilePic,
    "bio": bio,
    "_id": id,
  };
}
