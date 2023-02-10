// To parse this JSON data, do
//
//     final homeTabModel = homeTabModelFromJson(jsonString);

import 'dart:convert';


HomeTabModel homeTabModelFromJson(String str) => HomeTabModel.fromJson(json.decode(str));

String homeTabModelToJson(HomeTabModel data) => json.encode(data.toJson());


class HomeTabModel {
    HomeTabModel({
        required    this.code,
        required   this.status,
        required   this.message,
        required  this.postList,
    });

    int code;
    String status;
    String message;
    List<PostList> postList;

    factory HomeTabModel.fromJson(Map<String, dynamic> json) => HomeTabModel(
        code: json["code"],
        status: json["STATUS"],
        message: json["MESSAGE"],
        postList: List<PostList>.from(json["POST_LIST"].map((x) => PostList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "STATUS": status,
        "MESSAGE": message,
        "POST_LIST": List<dynamic>.from(postList.map((x) => x.toJson())),
    };
}

class PostList {
    PostList({
        required  this.id,
        required   this.name,
        required  this.profilePic,

        required  this.uId,
        required  this.title,
        required  this.audio,
        required this.category,
        required  this.backgroundImage,
        required  this.type,
        required  this.likes,
        required   this.islike,
        required   this.comments,
        required this.isbookmark,
    });

    String? id;
    String? name;
    String? profilePic;

    String? uId;
    String? title;
    String? audio;
    List<String>? category;
    String? backgroundImage;
    String? type;
    int? likes;
    bool? islike;
    int? comments;
    String? isbookmark;

    factory PostList.fromJson(Map<String, dynamic> json) => PostList(
        name: json["name"],
        profilePic: json["profile_pic"],
        id: json["id"],
        uId: json["uId"],
        title: json["title"],
        audio: json["audio"],
        category: List<String>.from(json["category"].map((x) => x)),
        backgroundImage: json["background_image"],
        type: json["type"],
        likes:json["likes"]!=null? json["likes"]:[],
        comments: json["comments"],
        islike: json["islike"],
        isbookmark: json["isbookmark"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profile_pic": profilePic,
        "id": id,
        "uId": uId,
        "title": title,
        "audio": audio,
        "category": List<dynamic>.from(category!.map((x) => x)),
        "background_image": backgroundImage,
        "type": type,
        "likes": likes,
        "comments": comments,
        "isbookmark": isbookmark,
    };
}
