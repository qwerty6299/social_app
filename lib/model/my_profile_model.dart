// To parse this JSON data, do
//
//     final myPrModel = myPrModelFromJson(jsonString);

import 'dart:convert';

MyPrModel myPrModelFromJson(String str) => MyPrModel.fromJson(json.decode(str));

String myPrModelToJson(MyPrModel data) => json.encode(data.toJson());

class MyPrModel {
  MyPrModel({
    required this.code,
    required  this.status,
    required  this.message,
    required  this.data,
    required  this.publicphoto,
    required  this.privatePhoto,
   required this.privateEcho,
  });

  int code;
  String status;
  String message;
  Data data;
  List<Photo> publicphoto;
  List<Photo> privatePhoto;
  List<Private> privateEcho;


  factory MyPrModel.fromJson(Map<String, dynamic> json) => MyPrModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    data: Data.fromJson(json["data"]),
    privateEcho: List<Private>.from(json["privateEcho"].map((x) => Private.fromJson(x))),
    publicphoto: List<Photo>.from(json["publicphoto"].map((x) => Photo.fromJson(x))),
    privatePhoto: List<Photo>.from(json["privatePhoto"].map((x) => Photo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "data": data.toJson(),
    "privateEcho": List<dynamic>.from(privateEcho.map((x) => x.toJson())),
    "publicphoto": List<dynamic>.from(publicphoto.map((x) => x.toJson())),
    "privatePhoto": List<dynamic>.from(privatePhoto.map((x) => x.toJson())),
  };
}

class Data {
  Data({
    required  this.name,
    required   this.profilePic,
    required  this.bio,
    required  this.postsCount,
    required  this.publicpostsCount,
    required this.followingCount,
    required this.followerCount,
  });

  String name;
  String profilePic;
  String bio;
  int postsCount;
  int publicpostsCount;
  int followingCount;
  int followerCount;

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

class Photo {
  Photo({
       this.title,
    required   this.backgroundImage,
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
      this.audio,
  });

  String? title;
  String backgroundImage;
  bool? isPublic;
  bool? isAnonymous;
  int? postStatus;
  String? id;
  String? userId;
  String? type;
  List<Category>? category;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? audio;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    title: json["title"],
    backgroundImage: json["background_image"] == null ? null : json["background_image"],
    isPublic: json["is_public"],
    isAnonymous: json["is_anonymous"],
    postStatus: json["post_status"],
    id: json["_id"],
    userId: json["user_id"],
    type: json["type"],
    category: List<Category>.from(json["category"].map((x) => categoryValues.map[x])),
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
    "category": List<dynamic>.from(category!.map((x) => categoryValues.reverse[x])),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "audio": audio == null ? null : audio,
  };
}

enum Category { THE_62_B30_C852_F0_DCBC4_B47_EEA8_C, THE_62_B30_C852_F0_DCBC4_B47_EEA8_B, ALABAMA }

final categoryValues = EnumValues({
  "Alabama": Category.ALABAMA,
  "62b30c852f0dcbc4b47eea8b": Category.THE_62_B30_C852_F0_DCBC4_B47_EEA8_B,
  "62b30c852f0dcbc4b47eea8c": Category.THE_62_B30_C852_F0_DCBC4_B47_EEA8_C
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap={};

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class Private {
  Private({
     this.title,
      required  this.backgroundImage,
    required   this.isPublic,
    required  this.isAnonymous,
        this.postStatus,
        this.id,
        this.userId,
    required   this.audio,
       this.type,
       this.category,
       this.createdAt,
       this.updatedAt,
       this.v,
  });

  String? title;
  String backgroundImage;
  bool isPublic;
  bool isAnonymous;
  int? postStatus;
  String? id;
  String? userId;
  String audio;
  String? type;
  List<String>? category;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Private.fromJson(Map<String, dynamic> json) => Private(
    title: json["title"],
    backgroundImage: json["background_image"] == null ? null : json["background_image"],
    isPublic: json["is_public"],
    isAnonymous: json["is_anonymous"],
    postStatus: json["post_status"],
    id: json["_id"],
    userId: json["user_id"],
    audio: json["audio"] == null ? null : json["audio"],
    type: json["type"],
    category: List<String>.from(json["category"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "background_image": backgroundImage == null ? null : backgroundImage,
    "is_public": isPublic,
    "is_anonymous": isAnonymous,
    "post_status": postStatus,
    "_id": id,
    "user_id": userId,
    "audio": audio == null ? null : audio,
    "type": type,
    "category": List<dynamic>.from(category!.map((x) => x)),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}
