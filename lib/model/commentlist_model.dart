// To parse this JSON data, do
//
//     final commentListModel = commentListModelFromJson(jsonString);

import 'dart:convert';

CommentListModel commentListModelFromJson(String str) => CommentListModel.fromJson(json.decode(str));

String commentListModelToJson(CommentListModel data) => json.encode(data.toJson());

class CommentListModel {
  CommentListModel({
    required   this.code,
    required  this.status,
    required  this.message,
    required this.commentList,
  });

  int code;
  String status;
  String message;
  List<CommentList> commentList;

  factory CommentListModel.fromJson(Map<String, dynamic> json) => CommentListModel(
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
    required this.name,
    required  this.profilePic,
    required this.username,
    required this.comment,
    required this.commentType,
    required this.commentTime,
    required  this.commentLikes,
    required this.commentReplies,
    required this.commentId,
  });

  String name;
  String profilePic;
  String username;
  String comment;
  String commentType;
  String commentTime;
  int commentLikes;
  int commentReplies;
  String commentId;

  factory CommentList.fromJson(Map<String, dynamic> json) => CommentList(
    name: json["name"],
    profilePic: json["profile_pic"],
    username: json["username"],
    comment: json["comment"],
    commentType: json["comment_type"],
    commentTime: json["comment_time"],
    commentLikes: json["commentLikes"],
    commentReplies: json["commentReplies"],
    commentId: json["comment_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profile_pic": profilePic,
    "username": username,
    "comment": comment,
    "comment_type": commentType,
    "comment_time": commentTime,
    "commentLikes": commentLikes,
    "commentReplies": commentReplies,
    "comment_id": commentId,
  };
}
