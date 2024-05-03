// To parse this JSON data, do
//
//     final getMessageLiveModel = getMessageLiveModelFromJson(jsonString);

import 'dart:convert';

GetMessageLiveModel getMessageLiveModelFromJson(String str) =>
    GetMessageLiveModel.fromJson(json.decode(str));

String getMessageLiveModelToJson(GetMessageLiveModel data) =>
    json.encode(data.toJson());

class GetMessageLiveModel {
  String? status;
  List<Datum>? data;

  GetMessageLiveModel({
    this.status,
    this.data,
  });

  factory GetMessageLiveModel.fromJson(Map<String, dynamic> json) =>
      GetMessageLiveModel(
        status: json["status"],
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? chatMessagesLiveId;
  String? senderType;
  int? senderId;
  int? receiverId;
  String? messageType;
  String? message;
  DateTime? dateAdded;
  dynamic dateRead;
  String? status;
  SenderData? senderData;
  ReceiverData? receiverData;

  Datum({
    this.chatMessagesLiveId,
    this.senderType,
    this.senderId,
    this.receiverId,
    this.messageType,
    this.message,
    this.dateAdded,
    this.dateRead,
    this.status,
    this.senderData,
    this.receiverData,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        chatMessagesLiveId: json["chat_messages_live_id"],
        senderType: json["sender_type"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        messageType: json["message_type"],
        message: json["message"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateRead: json["date_read"],
        status: json["status"],
        senderData: json["sender_data"] != null
            ? SenderData.fromJson(json["sender_data"])
            : null,
        receiverData: json["receiver_data"] != null
            ? ReceiverData.fromJson(json["receiver_data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "chat_messages_live_id": chatMessagesLiveId,
        "sender_type": senderType,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message_type": messageType,
        "message": message,
        "date_added": dateAdded!.toIso8601String(),
        "date_read": dateRead,
        "status": status,
        "sender_data": senderData!.toJson(),
        "receiver_data": receiverData!.toJson(),
      };
}

class ReceiverData {
  int? usersSystemId;
  int? usersSystemRolesId;
  String? firstName;
  String? email;
  String? password;
  String? mobile;
  String? city;
  String? address;
  String? userImage;
  String? isDeleted;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String? status;

  ReceiverData({
    this.usersSystemId,
    this.usersSystemRolesId,
    this.firstName,
    this.email,
    this.password,
    this.mobile,
    this.city,
    this.address,
    this.userImage,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.status,
  });

  factory ReceiverData.fromJson(Map<String, dynamic> json) => ReceiverData(
        usersSystemId: json["users_system_id"],
        usersSystemRolesId: json["users_system_roles_id"],
        firstName: json["first_name"],
        email: json["email"],
        password: json["password"],
        mobile: json["mobile"],
        city: json["city"],
        address: json["address"],
        userImage: json["user_image"],
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "users_system_id": usersSystemId,
        "users_system_roles_id": usersSystemRolesId,
        "first_name": firstName,
        "email": email,
        "password": password,
        "mobile": mobile,
        "city": city,
        "address": address,
        "user_image": userImage,
        "is_deleted": isDeleted,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "status": status,
      };
}

class SenderData {
  int? usersCustomersId;
  String? oneSignalId;
  String? walletAmount;
  String? jobsRatings;
  String? usersCustomersType;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? password;
  String? profilePic;
  String? identityDocument;
  String? workEligibilityDocument;
  dynamic googleAccessToken;
  String? accountType;
  String? socialAccountType;
  dynamic badgeVerified;
  String? notifications;
  String? messages;
  String? updateProfile;
  String? verifyEmailOtp;
  String? emailVerified;
  dynamic forgotPasswordOtp;
  DateTime? dateAdded;
  dynamic dateModified;
  String? status;

  SenderData({
    this.usersCustomersId,
    this.oneSignalId,
    this.walletAmount,
    this.jobsRatings,
    this.usersCustomersType,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.password,
    this.profilePic,
    this.identityDocument,
    this.workEligibilityDocument,
    this.googleAccessToken,
    this.accountType,
    this.socialAccountType,
    this.badgeVerified,
    this.notifications,
    this.messages,
    this.updateProfile,
    this.verifyEmailOtp,
    this.emailVerified,
    this.forgotPasswordOtp,
    this.dateAdded,
    this.dateModified,
    this.status,
  });

  factory SenderData.fromJson(Map<String, dynamic> json) => SenderData(
        usersCustomersId: json["users_customers_id"],
        oneSignalId: json["one_signal_id"],
        walletAmount: json["wallet_amount"],
        jobsRatings: json["jobs_ratings"],
        usersCustomersType: json["users_customers_type"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        profilePic: json["profile_pic"],
        identityDocument: json["identity_document"],
        workEligibilityDocument: json["work_eligibility_document"],
        googleAccessToken: json["google_access_token"],
        accountType: json["account_type"],
        socialAccountType: json["social_account_type"],
        badgeVerified: json["badge_verified"],
        notifications: json["notifications"],
        messages: json["messages"],
        updateProfile: json["update_profile"],
        verifyEmailOtp: json["verify_email_otp"],
        emailVerified: json["email_verified"],
        forgotPasswordOtp: json["forgot_password_otp"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: json["date_modified"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "users_customers_id": usersCustomersId,
        "one_signal_id": oneSignalId,
        "wallet_amount": walletAmount,
        "jobs_ratings": jobsRatings,
        "users_customers_type": usersCustomersType,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "password": password,
        "profile_pic": profilePic,
        "identity_document": identityDocument,
        "work_eligibility_document": workEligibilityDocument,
        "google_access_token": googleAccessToken,
        "account_type": accountType,
        "social_account_type": socialAccountType,
        "badge_verified": badgeVerified,
        "notifications": notifications,
        "messages": messages,
        "update_profile": updateProfile,
        "verify_email_otp": verifyEmailOtp,
        "email_verified": emailVerified,
        "forgot_password_otp": forgotPasswordOtp,
        "date_added": dateAdded!.toIso8601String(),
        "date_modified": dateModified,
        "status": status,
      };
}
