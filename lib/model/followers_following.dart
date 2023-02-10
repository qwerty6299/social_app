// To parse this JSON data, do
//
//     final followersFollowingModel = followersFollowingModelFromJson(jsonString);

import 'dart:convert';

  FollowersFollowingModel followersFollowingModelFromJson(String str) => FollowersFollowingModel.fromJson(json.decode(str));

String followersFollowingModelToJson(FollowersFollowingModel data) => json.encode(data.toJson());

class FollowersFollowingModel {
  FollowersFollowingModel({
    required this.code,
    required  this.status,
    required  this.message,
    required  this.followArray,
    required  this.followerArray,
  });

  int code;
  String status;
  String message;
  List<FollowArray> followArray;
  List<FollowerArray> followerArray;

  factory FollowersFollowingModel.fromJson(Map<String, dynamic> json) => FollowersFollowingModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    followArray:json["followArray"]!=null? List<FollowArray>.from(json["followArray"].map((x) => FollowArray.fromJson(x))):<FollowArray>[],
    followerArray:json["followerArray"]!=null? List<FollowerArray>.from(json["followerArray"].map((x) => FollowerArray.fromJson(x))):<FollowerArray>[],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "followArray": List<dynamic>.from(followArray.map((x) => x.toJson())),
    "followerArray": List<dynamic>.from(followerArray.map((x) => x.toJson())),
  };
}

class FollowArray {
  FollowArray({
   required this.id,
    required  this.name,
    required  this.profilePic,
    required  this.username,
  });

  String id;
  String name;
  String profilePic;
  String username;

  factory FollowArray.fromJson(Map<String, dynamic> json) => FollowArray(
    id: json["_id"],
    name: json["name"],
    profilePic: json["profile_pic"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profile_pic": profilePic,
    "username": username,
  };
}
class FollowerArray {
  FollowerArray({
    required this.id,
    required  this.name,
    required  this.profilePic,
    required  this.username,
  });

  String id;
  String name;
  String profilePic;
  String username;

  factory FollowerArray.fromJson(Map<String, dynamic> json) => FollowerArray(
    id: json["_id"],
    name: json["name"],
    profilePic: json["profile_pic"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profile_pic": profilePic,
    "username": username,
  };
}