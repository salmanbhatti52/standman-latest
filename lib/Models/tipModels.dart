// To parse this JSON data, do
//
//     final tipModel = tipModelFromJson(jsonString);

import 'dart:convert';

TipModel tipModelFromJson(String str) => TipModel.fromJson(json.decode(str));

String tipModelToJson(TipModel data) => json.encode(data.toJson());

class TipModel {
    String? status;
    String? message;

    TipModel({
        this.status,
        this.message,
    });

    factory TipModel.fromJson(Map<String, dynamic> json) => TipModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
