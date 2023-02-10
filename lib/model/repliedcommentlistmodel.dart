// To parse this JSON data, do
//
//     final repliedCommentListShowModel = repliedCommentListShowModelFromJson(jsonString);

import 'dart:convert';

RepliedCommentListShowModel repliedCommentListShowModelFromJson(String str) => RepliedCommentListShowModel.fromJson(json.decode(str));

String repliedCommentListShowModelToJson(RepliedCommentListShowModel data) => json.encode(data.toJson());

class RepliedCommentListShowModel {
    RepliedCommentListShowModel({
      required  this.code,
     required   this.status,
      required  this.message,
       required this.replyList,
    });

    int code;
    String status;
    String message;
    List<ReplyList> replyList;

    factory RepliedCommentListShowModel.fromJson(Map<String, dynamic> json) => RepliedCommentListShowModel(
        code: json["code"],
        status: json["STATUS"],
        message: json["MESSAGE"],
        replyList: List<ReplyList>.from(json["REPLY_LIST"].map((x) => ReplyList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "STATUS": status,
        "MESSAGE": message,
        "REPLY_LIST": List<dynamic>.from(replyList.map((x) => x.toJson())),
    };
}

class ReplyList {
    ReplyList({
     required   this.name,
     required   this.profilePic,
      required  this.username,
      required  this.reply,
      required  this.replyTime,
      required  this.replyLikes,
     required   this.replyid,
    });

    String name;
    String profilePic;
    String username;
    String reply;
    String replyTime;
    int replyLikes;
    String replyid;

    factory ReplyList.fromJson(Map<String, dynamic> json) => ReplyList(
        name: json["name"],
        profilePic: json["profile_pic"],
        username: json["username"],
        reply: json["reply"],
        replyTime: json["reply_time"],
        replyLikes: json["replyLikes"],
        replyid: json["replyid"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "profile_pic": profilePic,
        "username": username,
        "reply": reply,
        "reply_time": replyTime,
        "replyLikes": replyLikes,
        "replyid": replyid,
    };
}
