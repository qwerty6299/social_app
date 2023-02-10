// To parse this JSON data, do
//
//     final comentListShowModel = comentListShowModelFromJson(jsonString);

import 'dart:convert';

ComentListShowModel comentListShowModelFromJson(String str) => ComentListShowModel.fromJson(json.decode(str));

String comentListShowModelToJson(ComentListShowModel data) => json.encode(data.toJson());

class   ComentListShowModel {
  ComentListShowModel({
    this.code,
    this.status,
    this.message,
  required  this.commentList,
  });

  int? code;
  String? status;
  String? message;
  List<CommentList> commentList;

  factory ComentListShowModel.fromJson(Map<String, dynamic> json) => ComentListShowModel(
    code: json["code"],
    status: json["STATUS"],
    message: json["MESSAGE"],
    commentList: List<CommentList>.from(json["COMMENT_LIST"].map((x) => CommentList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "STATUS": status,
    "MESSAGE": message,
    "COMMENT_LIST": List<dynamic>.from(commentList.map((x) => x.toJson())),
  };
}

class CommentList {
  CommentList({
    this.name,
    required this.profilePic,
    this.username,
    required   this.comment,

    this.commentTime,
   required this.isliked,
    required  this.uId,
   required this.commentLikes,
    this.commentReplies,
   required this.commentId,
  });

  String? name;
  String profilePic;
  String? username;
  String comment;

  String? commentTime;
  bool isliked;
  String uId;
  int commentLikes;
  int? commentReplies;
  String commentId;

  factory CommentList.fromJson(Map<String, dynamic> json) => CommentList(
    name: json["name"],
    profilePic: json["profile_pic"],
    username: json["username"],
    comment: json["comment"],

    commentTime: json["comment_time"],
    isliked: json["isliked"],
    uId: json["uId"],
    commentLikes: json["commentLikes"],
    commentReplies: json["commentReplies"],
    commentId: json["comment_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profile_pic": profilePic,
    "username": username,
    "comment": comment,

    "comment_time": commentTime,
    "isliked": isliked,
    "uId": uId,
    "commentLikes": commentLikes,
    "commentReplies": commentReplies,
    "comment_id": commentId,
  };
}


