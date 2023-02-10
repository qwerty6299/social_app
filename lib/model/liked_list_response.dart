// To parse this JSON data, do
//
//     final likedListresponse = likedListresponseFromJson(jsonString);

import 'dart:convert';

LikedListresponse likedListresponseFromJson(String str) => LikedListresponse.fromJson(json.decode(str));

String likedListresponseToJson(LikedListresponse data) => json.encode(data.toJson());

class LikedListresponse {
  LikedListresponse({
    this.code,
    this.status,
    this.message,
  required this.likeList,
  });

  int? code;
  String? status;
  String? message;
  List<LikeList> likeList;

  factory LikedListresponse.fromJson(Map<String, dynamic> json) => LikedListresponse(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    likeList: List<LikeList>.from(json["LIKE_LIST"].map((x) => LikeList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "LIKE_LIST": List<dynamic>.from(likeList.map((x) => x.toJson())),
  };
}

class LikeList {
  LikeList({
   required this.name,
    required this.profilePic,
    required this.username,
    required this.uId,
  });

  String name;
  String profilePic;
  String username;
  String uId;

  factory LikeList.fromJson(Map<String, dynamic> json) => LikeList(
    name: json["name"],
    profilePic: json["profile_pic"],
    username: json["username"],
    uId: json["uId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profile_pic": profilePic,
    "username": username,
    "uId": uId,
  };
}
