// To parse this JSON data, do
//
//     final fetchProfilePublicEchoModel = fetchProfilePublicEchoModelFromJson(jsonString);

import 'dart:convert';

FetchProfilePublicEchoModel fetchProfilePublicEchoModelFromJson(String str) => FetchProfilePublicEchoModel.fromJson(json.decode(str));

String fetchProfilePublicEchoModelToJson(FetchProfilePublicEchoModel data) => json.encode(data.toJson());

class FetchProfilePublicEchoModel {
  FetchProfilePublicEchoModel({
    this.code,
    this.status,
    this.message,
    this.data,
   required this.publicEcho,
  });

  int? code;
  String? status;
  String? message;
  Data? data;
  List<PublicEcho> publicEcho;

  factory FetchProfilePublicEchoModel.fromJson(Map<String, dynamic> json) => FetchProfilePublicEchoModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    data: Data.fromJson(json["data"]),
    publicEcho: List<PublicEcho>.from(json["publicEcho"].map((x) => PublicEcho.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "data": data!.toJson(),
    "publicEcho": List<dynamic>.from(publicEcho.map((x) => x.toJson())),
  };
}

class Data {
  Data({
    this.name,
    this.profilePic,
    this.bio,
    this.postsCount,
    this.publicpostsCount,
    this.followingCount,
    this.followerCount,
  });

  String? name;
  String? profilePic;
  String? bio;
  int? postsCount;
  int? publicpostsCount;
  int? followingCount;
  int? followerCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    profilePic: json["profile_pic"],
    bio: json["bio"],
    postsCount: json["postsCount"],
    publicpostsCount: json["publicpostsCount"],
    followingCount: json["followingCount"],
    followerCount: json["followerCount"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profile_pic": profilePic,
    "bio": bio,
    "postsCount": postsCount,
    "publicpostsCount": publicpostsCount,
    "followingCount": followingCount,
    "followerCount": followerCount,
  };
}

class PublicEcho {
  PublicEcho({
    this.title,
   required this.backgroundImage,
    this.isPublic,
    this.isAnonymous,
    this.postStatus,
    this.id,
    this.userId,
  required  this.audio,
    this.type,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? title;
  String backgroundImage;
  bool? isPublic;
  bool? isAnonymous;
  int? postStatus;
  String? id;
  String? userId;
  String audio;
  String? type;
  List<String>? category;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory PublicEcho.fromJson(Map<String, dynamic> json) => PublicEcho(
    title: json["title"],
    backgroundImage: json["background_image"],
    isPublic: json["is_public"],
    isAnonymous: json["is_anonymous"],
    postStatus: json["post_status"],
    id: json["_id"],
    userId: json["user_id"],
    audio: json["audio"],
    type: json["type"],
    category: List<String>.from(json["category"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "background_image": backgroundImage,
    "is_public": isPublic,
    "is_anonymous": isAnonymous,
    "post_status": postStatus,
    "_id": id,
    "user_id": userId,
    "audio": audio,
    "type": type,
    "category": List<dynamic>.from(category!.map((x) => x)),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}
