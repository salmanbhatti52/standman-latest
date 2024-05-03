// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  String? status;
  List<Datum>? data;

  NotificationsModel({
    this.status,
    this.data,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int notificationsId;
  int senderId;
  int receiverId;
  String message;
  DateTime dateAdded;
  dynamic dateRead;
  String status;
  ErData senderData;
  ErData receiverData;

  Datum({
    required this.notificationsId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.dateAdded,
    required this.dateRead,
    required this.status,
    required this.senderData,
    required this.receiverData,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        notificationsId: json["notifications_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateRead: json["date_read"],
        status: json["status"],
        senderData: ErData.fromJson(json["sender_data"]),
        receiverData: ErData.fromJson(json["receiver_data"]),
      );

  Map<String, dynamic> toJson() => {
        "notifications_id": notificationsId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "date_added": dateAdded.toIso8601String(),
        "date_read": dateRead,
        "status": status,
        "sender_data": senderData.toJson(),
        "receiver_data": receiverData.toJson(),
      };
}

class ErData {
  int usersCustomersId;
  String oneSignalId;
  String walletAmount;
  dynamic jobsRatings;
  String usersCustomersType;
  String firstName;
  String lastName;
  String phone;
  String email;
  String password;
  String profilePic;
  String? identityDocument;
  String? workEligibilityDocument;
  dynamic googleAccessToken;
  String accountType;
  String socialAccountType;
  dynamic badgeVerified;
  String notifications;
  String messages;
  String? updateProfile;
  String verifyEmailOtp;
  String emailVerified;
  dynamic forgotPasswordOtp;
  DateTime dateAdded;
  DateTime? dateModified;
  String status;

  ErData({
    required this.usersCustomersId,
    required this.oneSignalId,
    required this.walletAmount,
    required this.jobsRatings,
    required this.usersCustomersType,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.identityDocument,
    required this.workEligibilityDocument,
    required this.googleAccessToken,
    required this.accountType,
    required this.socialAccountType,
    required this.badgeVerified,
    required this.notifications,
    required this.messages,
    required this.updateProfile,
    required this.verifyEmailOtp,
    required this.emailVerified,
    required this.forgotPasswordOtp,
    required this.dateAdded,
    required this.dateModified,
    required this.status,
  });

  factory ErData.fromJson(Map<String, dynamic> json) => ErData(
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
        dateModified: json["date_modified"] == null
            ? null
            : DateTime.parse(json["date_modified"]),
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
        "date_added": dateAdded.toIso8601String(),
        "date_modified": dateModified?.toIso8601String(),
        "status": status,
      };
}
