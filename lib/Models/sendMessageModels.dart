// To parse this JSON data, do
//
//     final sendMessagesModel = sendMessagesModelFromJson(jsonString);

import 'dart:convert';

SendMessagesModel sendMessagesModelFromJson(String str) => SendMessagesModel.fromJson(json.decode(str));

String sendMessagesModelToJson(SendMessagesModel data) => json.encode(data.toJson());

class SendMessagesModel {
    String? status;
    String? message;

    SendMessagesModel({
        this.status,
        this.message,
    });

    factory SendMessagesModel.fromJson(Map<String, dynamic> json) => SendMessagesModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
