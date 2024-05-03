// To parse this JSON data, do
//
//     final createJobWallet = createJobWalletFromJson(jsonString);

import 'dart:convert';

CreateJobWallet createJobWalletFromJson(String str) =>
    CreateJobWallet.fromJson(json.decode(str));

String createJobWalletToJson(CreateJobWallet data) =>
    json.encode(data.toJson());

class CreateJobWallet {
  String? status;
  String? message;
  Data? data;

  CreateJobWallet({
    this.status,
    this.message,
    this.data,
  });

  factory CreateJobWallet.fromJson(Map<String, dynamic> json) =>
      CreateJobWallet(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  int? jobsId;
  int? usersCustomersId;
  String? location;
  String? latitude;
  String? longitude;
  String? image;
  String? name;
  DateTime? jobDate;
  String? startTime;
  String? endTime;
  String? specialInstructions;
  String? price;
  String? serviceCharges;
  String? tax;
  String? totalPrice;
  dynamic extraTime;
  dynamic extraTimePrice;
  dynamic extraTimeServiceCharges;
  dynamic extraTimeTax;
  int? paymentGatewaysId;
  String? paymentStatus;
  int? jobsCancellationsReasonsId;
  dynamic archivedBy;
  String? discountGranted;
  DateTime? dateAdded;
  dynamic dateModified;
  String? status;
  UsersCustomers? usersCustomers;
  JobsDiscounts? jobsDiscounts;

  Data({
    this.jobsId,
    this.usersCustomersId,
    this.location,
    this.latitude,
    this.longitude,
    this.image,
    this.name,
    this.jobDate,
    this.startTime,
    this.endTime,
    this.specialInstructions,
    this.price,
    this.serviceCharges,
    this.tax,
    this.totalPrice,
    this.extraTime,
    this.extraTimePrice,
    this.extraTimeServiceCharges,
    this.extraTimeTax,
    this.paymentGatewaysId,
    this.paymentStatus,
    this.jobsCancellationsReasonsId,
    this.archivedBy,
    this.discountGranted,
    this.dateAdded,
    this.dateModified,
    this.status,
    this.usersCustomers,
    this.jobsDiscounts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        jobsId: json["jobs_id"],
        usersCustomersId: json["users_customers_id"],
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        image: json["image"],
        name: json["name"],
        jobDate: DateTime.parse(json["job_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        specialInstructions: json["special_instructions"] ?? "",
        price: json["price"],
        serviceCharges: json["service_charges"],
        tax: json["tax"],
        totalPrice: json["total_price"],
        extraTime: json["extra_time"],
        extraTimePrice: json["extra_time_price"],
        extraTimeServiceCharges: json["extra_time_service_charges"],
        extraTimeTax: json["extra_time_tax"],
        paymentGatewaysId: json["payment_gateways_id"],
        paymentStatus: json["payment_status"],
        jobsCancellationsReasonsId: json["jobs_cancellations_reasons_id"],
        archivedBy: json["archived_by"],
        discountGranted: json["discount_granted"] ?? "",
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: json["date_modified"],
        status: json["status"],
        usersCustomers: UsersCustomers.fromJson(json["users_customers"]),
        jobsDiscounts: json["jobs_discounts"] != null
            ? JobsDiscounts.fromJson(json["jobs_discounts"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "jobs_id": jobsId,
        "users_customers_id": usersCustomersId,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "image": image,
        "name": name,
        "job_date":
            "${jobDate!.year.toString().padLeft(4, '0')}-${jobDate!.month.toString().padLeft(2, '0')}-${jobDate!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "special_instructions": specialInstructions,
        "price": price,
        "service_charges": serviceCharges,
        "tax": tax,
        "total_price": totalPrice,
        "extra_time": extraTime,
        "extra_time_price": extraTimePrice,
        "extra_time_service_charges": extraTimeServiceCharges,
        "extra_time_tax": extraTimeTax,
        "payment_gateways_id": paymentGatewaysId,
        "payment_status": paymentStatus,
        "jobs_cancellations_reasons_id": jobsCancellationsReasonsId,
        "archived_by": archivedBy,
        "discount_granted": discountGranted,
        "date_added": dateAdded!.toIso8601String(),
        "date_modified": dateModified,
        "status": status,
        "users_customers": usersCustomers!.toJson(),
        "jobs_discounts": jobsDiscounts!.toJson(),
      };
}

class JobsDiscounts {
  int? jobsDiscountsId;
  int? jobsId;
  String? discount;
  String? price;
  String? serviceCharges;
  String? tax;
  String? totalPrice;
  DateTime? dateAdded;

  JobsDiscounts({
    this.jobsDiscountsId,
    this.jobsId,
    this.discount,
    this.price,
    this.serviceCharges,
    this.tax,
    this.totalPrice,
    this.dateAdded,
  });

  factory JobsDiscounts.fromJson(Map<String, dynamic> json) => JobsDiscounts(
        jobsDiscountsId: json["jobs_discounts_id"],
        jobsId: json["jobs_id"],
        discount: json["discount"],
        price: json["price"],
        serviceCharges: json["service_charges"],
        tax: json["tax"],
        totalPrice: json["total_price"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "jobs_discounts_id": jobsDiscountsId,
        "jobs_id": jobsId,
        "discount": discount,
        "price": price,
        "service_charges": serviceCharges,
        "tax": tax,
        "total_price": totalPrice,
        "date_added": dateAdded!.toIso8601String(),
      };
}

class UsersCustomers {
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

  UsersCustomers({
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

  factory UsersCustomers.fromJson(Map<String, dynamic> json) => UsersCustomers(
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
