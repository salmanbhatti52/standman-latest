// To parse this JSON data, do
//
//     final messagesPermissionModel = messagesPermissionModelFromJson(jsonString);

import 'dart:convert';

MessagesPermissionModel messagesPermissionModelFromJson(String str) => MessagesPermissionModel.fromJson(json.decode(str));

String messagesPermissionModelToJson(MessagesPermissionModel data) => json.encode(data.toJson());

class MessagesPermissionModel {
    String? status;
    Data? data;

    MessagesPermissionModel({
        this.status,
        this.data,
    });

    factory MessagesPermissionModel.fromJson(Map<String, dynamic> json) => MessagesPermissionModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
    };
}

class Data {
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
    String?profilePic;
    dynamic identityDocument;
    dynamic workEligibilityDocument;
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
    DateTime? dateModified;
    String? status;

    Data({
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

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        dateModified: DateTime.parse(json["date_modified"]),
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
        "date_modified": dateModified!.toIso8601String(),
        "status": status,
    };
}
