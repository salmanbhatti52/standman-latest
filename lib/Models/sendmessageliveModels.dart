// To parse this JSON data, do
//
//     final sendMessageLive = sendMessageLiveFromJson(jsonString);

import 'dart:convert';

SendMessageLive sendMessageLiveFromJson(String str) => SendMessageLive.fromJson(json.decode(str));

String sendMessageLiveToJson(SendMessageLive data) => json.encode(data.toJson());

class SendMessageLive {
    String? status;
    String? message;

    SendMessageLive({
         this.status,
         this.message,
    });

    factory SendMessageLive.fromJson(Map<String, dynamic> json) => SendMessageLive(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
