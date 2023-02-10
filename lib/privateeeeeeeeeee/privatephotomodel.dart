
// To parse this JSON data, do
//
//     final privatephotoModel = privatephotoModelFromJson(jsonString);

import 'dart:convert';

PrivatephotoModel privatephotoModelFromJson(String str) => PrivatephotoModel.fromJson(json.decode(str));

String privatephotoModelToJson(PrivatephotoModel data) => json.encode(data.toJson());

class PrivatephotoModel {
  PrivatephotoModel({
    this.code,
    this.status,
    this.message,
    this.data,
   required this.privatePhoto,
  });

  int? code;
  String? status;
  String? message;
  Data? data;
  List<PrivatePhoto> privatePhoto;

  factory PrivatephotoModel.fromJson(Map<String, dynamic> json) => PrivatephotoModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    data: Data.fromJson(json["data"]),
    privatePhoto: List<PrivatePhoto>.from(json["privatePhoto"].map((x) => PrivatePhoto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "data": data!.toJson(),
    "privatePhoto": List<dynamic>.from(privatePhoto.map((x) => x.toJson())),
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

class PrivatePhoto {
  PrivatePhoto({
    this.title,
  required  this.backgroundImage,
    this.isPublic,
    this.isAnonymous,
    this.postStatus,
    this.id,
    this.userId,
    this.audio,
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
  dynamic audio;
  String? type;
  List<String>? category;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory PrivatePhoto.fromJson(Map<String, dynamic> json) => PrivatePhoto(
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
