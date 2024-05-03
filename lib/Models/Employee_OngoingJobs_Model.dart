// To parse this JSON data, do
//
//     final employeeOngoingJobsModel = employeeOngoingJobsModelFromJson(jsonString);

import 'dart:convert';

EmployeeOngoingJobsModel employeeOngoingJobsModelFromJson(String str) =>
    EmployeeOngoingJobsModel.fromJson(json.decode(str));

String employeeOngoingJobsModelToJson(EmployeeOngoingJobsModel data) =>
    json.encode(data.toJson());

class EmployeeOngoingJobsModel {
  String? status;
  List<Datum1>? data;

  EmployeeOngoingJobsModel({
    this.status,
    this.data,
  });

  factory EmployeeOngoingJobsModel.fromJson(Map<String, dynamic> json) =>
      EmployeeOngoingJobsModel(
        status: json["status"],
        data: json["data"] != null
            ? List<Datum1>.from(json["data"].map((x) => Datum1.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum1 {
  int? jobsRequestsId;
  int? usersCustomersId;
  int? jobsId;
  DateTime? dateAdded;
  dynamic dateModified;
  String? status;
  UsersCustomers? usersCustomers;
  Jobs? jobs;

  Datum1({
    this.jobsRequestsId,
    this.usersCustomersId,
    this.jobsId,
    this.dateAdded,
    this.dateModified,
    this.status,
    this.usersCustomers,
    this.jobs,
  });

  factory Datum1.fromJson(Map<String, dynamic> json) => Datum1(
        jobsRequestsId: json["jobs_requests_id"],
        usersCustomersId: json["users_customers_id"],
        jobsId: json["jobs_id"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: json["date_modified"],
        status: json["status"],
        usersCustomers: UsersCustomers.fromJson(json["users_customers"]),
        jobs: Jobs.fromJson(json["jobs"]),
      );

  Map<String, dynamic> toJson() => {
        "jobs_requests_id": jobsRequestsId,
        "users_customers_id": usersCustomersId,
        "jobs_id": jobsId,
        "date_added": dateAdded!.toIso8601String(),
        "date_modified": dateModified,
        "status": status,
        "users_customers": usersCustomers!.toJson(),
        "jobs": jobs!.toJson(),
      };
}

class Jobs {
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
  dynamic extraTimeTotalPrice;
  int? paymentGatewaysId;
  String? paymentStatus;
  DateTime? dateAdded;
  DateTime? dateModified;
  String? status;
  UsersCustomers? usersCustomers;
  PaymentGateways? paymentGateways;

  Jobs({
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
    this.extraTimeTotalPrice,
    this.paymentGatewaysId,
    this.paymentStatus,
    this.dateAdded,
    this.dateModified,
    this.status,
    this.usersCustomers,
    this.paymentGateways,
  });

  factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
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
        specialInstructions: json["special_instructions"],
        price: json["price"],
        serviceCharges: json["service_charges"],
        tax: json["tax"],
        totalPrice: json["total_price"],
        extraTime: json["extra_time"],
        extraTimePrice: json["extra_time_price"],
        extraTimeServiceCharges: json["extra_time_service_charges"],
        extraTimeTax: json["extra_time_tax"],
        extraTimeTotalPrice: json["extra_time_total_price"],
        paymentGatewaysId: json["payment_gateways_id"],
        paymentStatus: json["payment_status"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: DateTime.parse(json["date_modified"]),
        status: json["status"],
        usersCustomers: UsersCustomers.fromJson(json["users_customers"]),
      paymentGateways: json["payment_gateways"] != null ? PaymentGateways.fromJson(json["payment_gateways"]) : null,

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
        "extra_time_total_price": extraTimeTotalPrice,
        "payment_gateways_id": paymentGatewaysId,
        "payment_status": paymentStatus,
        "date_added": dateAdded!.toIso8601String(),
        "date_modified": dateModified!.toIso8601String(),
        "status": status,
        "users_customers": usersCustomers!.toJson(),
        "payment_gateways": paymentGateways!.toJson(),
      };
}

class PaymentGateways {
  int? paymentGatewaysId;
  String? name;
  DateTime? dateAdded;
  dynamic dateModified;
  String? status;

  PaymentGateways({
    this.paymentGatewaysId,
    this.name,
    this.dateAdded,
    this.dateModified,
    this.status,
  });

  factory PaymentGateways.fromJson(Map<String, dynamic> json) =>
      PaymentGateways(
        paymentGatewaysId: json["payment_gateways_id"],
        name: json["name"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: json["date_modified"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "payment_gateways_id": paymentGatewaysId,
        "name": name,
        "date_added": dateAdded!.toIso8601String(),
        "date_modified": dateModified,
        "status": status,
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
  String? dateModified;
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
