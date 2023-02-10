// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    CategoryModel({
       required this.code,
      required  this.status,
       required this.message,
       required this.categoryList,
    });

    int code;
    String status;
    String message;
    List<CategoryList> categoryList;

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        code: json["code"],
        status: json["STATUS"],
        message: json["MESSAGE"],
        categoryList: List<CategoryList>.from(json["CATEGORY_LIST"].map((x) => CategoryList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "STATUS": status,
        "MESSAGE": message,
        "CATEGORY_LIST": List<dynamic>.from(categoryList.map((x) => x.toJson())),
    };
}

class CategoryList {
    CategoryList({
     required   this.status,
     required   this.createdTime,
     required   this.id,
     required   this.categoryListId,
     required   this.name,
    });

    int status;
    DateTime createdTime;
    String id;
    int categoryListId;
    String name;

    factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        status: json["status"],
        createdTime: DateTime.parse(json["created_time"]),
        id: json["_id"],
        categoryListId: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "created_time": createdTime.toIso8601String(),
        "_id": id,
        "id": categoryListId,
        "name": name,
    };
}
