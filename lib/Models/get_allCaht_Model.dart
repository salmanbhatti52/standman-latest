// To parse this JSON data, do
//
//     final getAllCahtModel = getAllCahtModelFromJson(jsonString);

import 'dart:convert';

GetAllCahtModel getAllCahtModelFromJson(String str) => GetAllCahtModel.fromJson(json.decode(str));

String getAllCahtModelToJson(GetAllCahtModel data) => json.encode(data.toJson());

class GetAllCahtModel {
    String? status;
    List<Datum>? data;

    GetAllCahtModel({
        this.status,
        this.data,
    });

    factory GetAllCahtModel.fromJson(Map<String, dynamic> json) => GetAllCahtModel(
        status: json["status"],
      
data: json["data"] != null ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))): null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? chatListId;
    String? senderType;
    int? senderId;
    int? receiverId;
    DateTime? dateAdded;
    UserData? userData;

    Datum({
        this.chatListId,
        this.senderType,
        this.senderId,
        this.receiverId,
        this.dateAdded,
        this.userData,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        chatListId: json["chat_list_id"],
        senderType: json["sender_type"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        dateAdded: DateTime.parse(json["date_added"]),
        userData: UserData.fromJson(json["user_data"]),
    );

    Map<String, dynamic> toJson() => {
        "chat_list_id": chatListId,
        "sender_type": senderType,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "date_added": dateAdded!.toIso8601String(),
        "user_data": userData!.toJson(),
    };
}

class UserData {
    int? usersCustomersId;
    String? oneSignalId;
    String? walletAmount;
    dynamic jobsRatings;
    String? usersCustomersType;
    String? firstName;
    String? lastName;
    String? phone;
    String? email;
    String? password;
    String? profilePic;
    dynamic identityDocument;
    dynamic workEligibilityDocument;
    String? jobRadius;
    dynamic googleAccessToken;
    String? accountType;
    String? socialAccountType;
    dynamic badgeVerified;
    String? notifications;
    String? messages;
    dynamic updateProfile;
    String? verifyEmailOtp;
    String? emailVerified;
    dynamic forgotPasswordOtp;
    DateTime? dateAdded;
    dynamic dateModified;
    String? status;

    UserData({
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
        this.jobRadius,
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

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
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
        jobRadius: json["job_radius"],
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
        "job_radius": jobRadius,
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
