// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    ProfileModel({
        required this.code,
        required this.status,
        required this.message,
        required this.data,
    });

    int code;
    String status;
    String message;
    Data data;

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        code: json["code"],
        status: json["STATUS"],
        message: json["MESSAGE"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "STATUS": status,
        "MESSAGE": message,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.name,
        required this.profilePic,
        required this.bio,
        required this.postsCount,
        required this.publicpostsCount,
        required this.followingCount,
        required this.followerCount,
        required this.posts,
        required this.publicposts,
    });

    String name;
    String profilePic;
    String bio;
    int postsCount;
    int publicpostsCount;
    int followingCount;
    int followerCount;
    List<Post> posts;
    List<Post> publicposts;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        profilePic: json["profile_pic"],
        bio: json["bio"],
        postsCount: json["postsCount"],
        publicpostsCount: json["publicpostsCount"],
        followingCount: json["followingCount"],
        followerCount: json["followerCount"],
        posts:json["posts"]!=null? List<Post>.from(json["posts"].map((x) => Post.fromJson(x))): <Post>[],
        publicposts:json["publicposts"]!=null? List<Post>.from(json["publicposts"].map((x) => Post.fromJson(x))):<Post>[],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profile_pic": profilePic,
        "bio": bio,
        "postsCount": postsCount,
        "publicpostsCount": publicpostsCount,
        "followingCount": followingCount,
        "followerCount": followerCount,
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
        "publicposts": List<dynamic>.from(publicposts.map((x) => x.toJson())),
    };
}

class Post {
    Post({
        required this.title,
        required this.audio,
        required this.isPublic,
        required this.isAnonymous,
        required this.postStatus,
        required this.id,
        required this.userId,
        required this.backgroundImage,
        required this.category,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    String title;
    String audio;
    bool isPublic;
    bool isAnonymous;
    int postStatus;
    String id;
    String userId;
    String backgroundImage;
    List<String> category;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        title: json["title"],
        audio: json["audio"],
        isPublic: json["is_public"],
        isAnonymous: json["is_anonymous"],
        postStatus: json["post_status"],
        id: json["_id"],
        userId: json["user_id"],
        backgroundImage: json["background_image"],
        category: List<String>.from(json["category"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "audio": audio,
        "is_public": isPublic,
        "is_anonymous": isAnonymous,
        "post_status": postStatus,
        "_id": id,
        "user_id": userId,
        "background_image": backgroundImage,
        "category": List<dynamic>.from(category.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
