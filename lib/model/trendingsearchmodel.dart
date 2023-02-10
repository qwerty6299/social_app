// To parse this JSON data, do
//
//     final trendingSearchModel = trendingSearchModelFromJson(jsonString);

import 'dart:convert';

TrendingSearchModel trendingSearchModelFromJson(String str) => TrendingSearchModel.fromJson(json.decode(str));

String trendingSearchModelToJson(TrendingSearchModel data) => json.encode(data.toJson());

class TrendingSearchModel {
  TrendingSearchModel({
    required  this.status,
    required   this.message,
    required  this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory TrendingSearchModel.fromJson(Map<String, dynamic> json) => TrendingSearchModel(
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
    required   this.echoes,
    required   this.trendingGroup,
  });

  List<Echo>? trndingAccounts;
  List<Echo>? echoes;
  List<Echo>? trendingGroup;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    trndingAccounts: json["trnding_accounts"] == null ? null : List<Echo>.from(json["trnding_accounts"].map((x) => Echo.fromJson(x))),
    echoes: json["echoes"] == null ? null : List<Echo>.from(json["echoes"].map((x) => Echo.fromJson(x))),
    trendingGroup: json["trending_group"] == null ? null : List<Echo>.from(json["trending_group"].map((x) => Echo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "trnding_accounts": trndingAccounts == null ? null : List<dynamic>.from(trndingAccounts!.map((x) => x.toJson())),
    "echoes": echoes == null ? null : List<dynamic>.from(echoes!.map((x) => x.toJson())),
    "trending_group": trendingGroup == null ? null : List<dynamic>.from(trendingGroup!.map((x) => x.toJson())),
  };
}

class Echo {
  Echo({
    required   this.name,
    required   this.username,
    required  this.image,
    required  this.id
  });

  String  name;
  String username;
  String image;
  String id;

  factory Echo.fromJson(Map<String, dynamic> json) => Echo(
    name: json["name"],
    username: json["username"],
    image: json["image"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": nameValues.reverse[name],
    "username": usernameValues.reverse[username],
    "image": image,
    "id":usernameValues.reverse[id]
  };
}

enum Name { ADLERFINLEY }

final nameValues = EnumValues({
  "adlerfinley": Name.ADLERFINLEY
});

enum Username { AL }

final usernameValues = EnumValues({
  "al": Username.AL
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
