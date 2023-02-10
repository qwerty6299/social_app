// To parse this JSON data, do
//
//     final bucketmodel = bucketmodelFromJson(jsonString);

import 'dart:convert';

Bucketmodel bucketmodelFromJson(String str) => Bucketmodel.fromJson(json.decode(str));

String bucketmodelToJson(Bucketmodel data) => json.encode(data.toJson());

class Bucketmodel {
  Bucketmodel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory Bucketmodel.fromJson(Map<String, dynamic> json) => Bucketmodel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.bucket,

    required this.region,
    required this.poolId,
  });

  String bucket;

  String region;
  String poolId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bucket: json["bucket"],

    region: json["region"],
    poolId: json["poolId"],
  );

  Map<String, dynamic> toJson() => {
    "bucket": bucket,

    "region": region,
    "poolId": poolId,
  };
}
