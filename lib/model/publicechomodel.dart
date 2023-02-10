// To parse this JSON data, do
//
//     final publicechoModel = publicechoModelFromJson(jsonString);

import 'dart:convert';

PublicechoModel publicechoModelFromJson(String str) => PublicechoModel.fromJson(json.decode(str));

String publicechoModelToJson(PublicechoModel data) => json.encode(data.toJson());

class PublicechoModel {
  PublicechoModel({
    this.code,
    this.status,
    this.message,
    this.data,
  required  this.publicEcho,
    this.privatePhoto,
  });

  int? code;
  String? status;
  String? message;
  Data? data;
  List<PrivatePhoto> publicEcho;
  List<PrivatePhoto>? privatePhoto;

  factory PublicechoModel.fromJson(Map<String, dynamic> json) => PublicechoModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    data: Data.fromJson(json["data"]),
    publicEcho: List<PrivatePhoto>.from(json["publicEcho"].map((x) => PrivatePhoto.fromJson(x))),
    privatePhoto: List<PrivatePhoto>.from(json["privatePhoto"].map((x) => PrivatePhoto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "data": data!.toJson(),
    "publicEcho": List<dynamic>.from(publicEcho.map((x) => x.toJson())),
    "privatePhoto": List<dynamic>.from(privatePhoto!.map((x) => x.toJson())),
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
   required this.backgroundImage,
    this.isPublic,
    this.isAnonymous,
    this.postStatus,
    this.id,
    this.userId,
    this.type,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.v,
    required  this.audio,
  });

  String? title;
  String backgroundImage;
  bool? isPublic;
  bool? isAnonymous;
  int? postStatus;
  String? id;
  String? userId;
  String? type;
  List<String>? category;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String audio;

  factory PrivatePhoto.fromJson(Map<String, dynamic> json) => PrivatePhoto(
    title: json["title"],
    backgroundImage: json["background_image"] == null ? null : json["background_image"],
    isPublic: json["is_public"],
    isAnonymous: json["is_anonymous"],
    postStatus: json["post_status"],
    id: json["_id"],
    userId: json["user_id"],
    type: json["type"],
    category: List<String>.from(json["category"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    audio: json["audio"] == null ? null : json["audio"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "background_image": backgroundImage == null ? null : backgroundImage,
    "is_public": isPublic,
    "is_anonymous": isAnonymous,
    "post_status": postStatus,
    "_id": id,
    "user_id": userId,
    "type": type,
    "category": List<dynamic>.from(category!.map((x) => x)),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "audio": audio == null ? null : audio,
  };
}
