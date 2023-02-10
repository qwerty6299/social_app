// To parse this JSON data, do
//
//     final trendingOneSearchModel = trendingOneSearchModelFromJson(jsonString);

import 'dart:convert';

TrendingOneSearchModel trendingOneSearchModelFromJson(String str) => TrendingOneSearchModel.fromJson(json.decode(str));

String trendingOneSearchModelToJson(TrendingOneSearchModel data) => json.encode(data.toJson());

class TrendingOneSearchModel {
  TrendingOneSearchModel({
    required  this.status,
    required  this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory TrendingOneSearchModel.fromJson(Map<String, dynamic> json) => TrendingOneSearchModel(
    status: json["status"],
    message: json["MESSAGE"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "MESSAGE": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required   this.trndingAccounts,
  });

  List<TrndingAccount> trndingAccounts;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    trndingAccounts: List<TrndingAccount>.from(json["trnding_accounts"].map((x) => TrndingAccount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "trnding_accounts": List<dynamic>.from(trndingAccounts.map((x) => x.toJson())),
  };
}

class TrndingAccount {
  TrndingAccount({
    required this.id,
    required this.name,
    required this.username,
    required this.image,
  });

  String id;
  String name;
  String username;
  String image;

  factory TrndingAccount.fromJson(Map<String, dynamic> json) => TrndingAccount(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "image": image,
  };
}
