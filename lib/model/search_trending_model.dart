// To parse this JSON data, do
//
//     final searchtrendingModel = searchtrendingModelFromJson(jsonString);

import 'dart:convert';

SearchtrendingModel searchtrendingModelFromJson(String str) => SearchtrendingModel.fromJson(json.decode(str));

String searchtrendingModelToJson(SearchtrendingModel data) => json.encode(data.toJson());

class SearchtrendingModel {
  SearchtrendingModel({
    this.status,
    this.worker,
  required  this.dat,
    required  this.echos,
    required  this.groups,
  });

  String? status;
  String? worker;
  List<Dat> dat;
 List<Echo> echos;
 List<Group> groups;

  factory SearchtrendingModel.fromJson(Map<String, dynamic> json) => SearchtrendingModel(
    status: json["status"],
    worker: json["worker"],
    dat: List<Dat>.from(json["dat"].map((x) => Dat.fromJson(x))),
    echos: List<Echo>.from(json["echos"].map((x) => Echo.fromJson(x))),
    groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "worker": worker,
    "dat": List<dynamic>.from(dat.map((x) => x.toJson())),
    "echos": List<dynamic>.from(echos.map((x) => x.toJson())),
   // "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
  };
}

class Dat {
  Dat({
    required this.username,
    required  this.firstName,
    required  this.lastName,
    required  this.profilePic,
    required this.id,
  });

  String username;
  String firstName;
  String lastName;
  String profilePic;
  String id;

  factory Dat.fromJson(Map<String, dynamic> json) => Dat(
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePic: json["profile_pic"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "profile_pic": profilePic,
    "_id": id,
  };
}

class Echo {
  Echo({
    this.title,
    required this.backgroundImage,
    this.id,
    required this.audio,
  });

  String? title;
  String backgroundImage;
  String? id;
  String audio;

  factory Echo.fromJson(Map<String, dynamic> json) => Echo(
    title: json["title"],
    backgroundImage: json["background_image"],
    id: json["_id"],
    audio: json["audio"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "background_image": backgroundImage,
    "_id": id,
    "audio": audio,
  };
}

class Group {
  Group({
    this.id,
   required this.url,
    required this.name,
       this.desc,
  });

  String? id;
  String url;
  String name;
  String? desc;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["_id"],
    url: json["url"],
    name: json["name"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "url": url,
    "name": name,
    "desc": desc,
  };
}
