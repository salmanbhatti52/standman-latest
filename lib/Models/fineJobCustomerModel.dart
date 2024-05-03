// To parse this JSON data, do
//
//     final fineJobModel = fineJobModelFromJson(jsonString);

import 'dart:convert';

FineJobModel fineJobModelFromJson(String str) =>
    FineJobModel.fromJson(json.decode(str));

String fineJobModelToJson(FineJobModel data) => json.encode(data.toJson());

class FineJobModel {
  String? status;
  Data? data;

  FineJobModel({
    this.status,
    this.data,
  });

  factory FineJobModel.fromJson(Map<String, dynamic> json) => FineJobModel(
        status: json["status"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
      };
}

class Data {
  int jobsId;
  int usersCustomersId;
  String location;
  String latitude;
  String longitude;
  String image;
  String name;
  DateTime jobDate;
  String startTime;
  String endTime;
  dynamic specialInstructions;
  String price;
  String serviceCharges;
  String tax;
  String totalPrice;
  dynamic extraTime;
  dynamic extraTimePrice;
  dynamic extraTimeServiceCharges;
  dynamic extraTimeTax;
  int paymentGatewaysId;
  String paymentStatus;
  int jobsCancellationsReasonsId;
  dynamic archivedBy;
  String discountGranted;
  DateTime dateAdded;
  DateTime dateModified;
  String status;
  UsersCustomers usersCustomers;
  PaymentGateways paymentGateways;
  JobsDiscounts jobsDiscounts;
  JobsFines jobsFines;
  JobsRequests jobsRequests;

  Data({
    required this.jobsId,
    required this.usersCustomersId,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.name,
    required this.jobDate,
    required this.startTime,
    required this.endTime,
    required this.specialInstructions,
    required this.price,
    required this.serviceCharges,
    required this.tax,
    required this.totalPrice,
    required this.extraTime,
    required this.extraTimePrice,
    required this.extraTimeServiceCharges,
    required this.extraTimeTax,
    required this.paymentGatewaysId,
    required this.paymentStatus,
    required this.jobsCancellationsReasonsId,
    required this.archivedBy,
    required this.discountGranted,
    required this.dateAdded,
    required this.dateModified,
    required this.status,
    required this.usersCustomers,
    required this.paymentGateways,
    required this.jobsDiscounts,
    required this.jobsFines,
    required this.jobsRequests,
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
        specialInstructions: json["special_instructions"],
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
        discountGranted: json["discount_granted"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: DateTime.parse(json["date_modified"]),
        status: json["status"],
        usersCustomers: UsersCustomers.fromJson(json["users_customers"]),
        paymentGateways: PaymentGateways.fromJson(json["payment_gateways"]),
        jobsDiscounts: JobsDiscounts.fromJson(json["jobs_discounts"]),
        jobsFines: JobsFines.fromJson(json["jobs_fines"]),
        jobsRequests: JobsRequests.fromJson(json["jobs_requests"]),
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
            "${jobDate.year.toString().padLeft(4, '0')}-${jobDate.month.toString().padLeft(2, '0')}-${jobDate.day.toString().padLeft(2, '0')}",
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
        "date_added": dateAdded.toIso8601String(),
        "date_modified": dateModified.toIso8601String(),
        "status": status,
        "users_customers": usersCustomers.toJson(),
        "payment_gateways": paymentGateways.toJson(),
        "jobs_discounts": jobsDiscounts.toJson(),
        "jobs_fines": jobsFines.toJson(),
        "jobs_requests": jobsRequests.toJson(),
      };
}

class JobsDiscounts {
  int jobsDiscountsId;
  int jobsId;
  String discount;
  String price;
  String serviceCharges;
  String tax;
  String totalPrice;
  DateTime dateAdded;

  JobsDiscounts({
    required this.jobsDiscountsId,
    required this.jobsId,
    required this.discount,
    required this.price,
    required this.serviceCharges,
    required this.tax,
    required this.totalPrice,
    required this.dateAdded,
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
        "date_added": dateAdded.toIso8601String(),
      };
}

class JobsFines {
  int jobsFinesId;
  int jobsId;
  String time;
  String price;
  DateTime dateAdded;
  dynamic dateModified;
  String status;

  JobsFines({
    required this.jobsFinesId,
    required this.jobsId,
    required this.time,
    required this.price,
    required this.dateAdded,
    required this.dateModified,
    required this.status,
  });

  factory JobsFines.fromJson(Map<String, dynamic> json) => JobsFines(
        jobsFinesId: json["jobs_fines_id"],
        jobsId: json["jobs_id"],
        time: json["time"],
        price: json["price"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: json["date_modified"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "jobs_fines_id": jobsFinesId,
        "jobs_id": jobsId,
        "time": time,
        "price": price,
        "date_added": dateAdded.toIso8601String(),
        "date_modified": dateModified,
        "status": status,
      };
}

class JobsRequests {
  int jobsRequestsId;
  int jobsId;
  int usersCustomersId;
  int jobsCancellationsReasonsId;
  DateTime dateAdded;
  DateTime dateModified;
  String status;
  UsersCustomers usersCustomers;

  JobsRequests({
    required this.jobsRequestsId,
    required this.jobsId,
    required this.usersCustomersId,
    required this.jobsCancellationsReasonsId,
    required this.dateAdded,
    required this.dateModified,
    required this.status,
    required this.usersCustomers,
  });

  factory JobsRequests.fromJson(Map<String, dynamic> json) => JobsRequests(
        jobsRequestsId: json["jobs_requests_id"],
        jobsId: json["jobs_id"],
        usersCustomersId: json["users_customers_id"],
        jobsCancellationsReasonsId: json["jobs_cancellations_reasons_id"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: DateTime.parse(json["date_modified"]),
        status: json["status"],
        usersCustomers: UsersCustomers.fromJson(json["users_customers"]),
      );

  Map<String, dynamic> toJson() => {
        "jobs_requests_id": jobsRequestsId,
        "jobs_id": jobsId,
        "users_customers_id": usersCustomersId,
        "jobs_cancellations_reasons_id": jobsCancellationsReasonsId,
        "date_added": dateAdded.toIso8601String(),
        "date_modified": dateModified.toIso8601String(),
        "status": status,
        "users_customers": usersCustomers.toJson(),
      };
}

class UsersCustomers {
  int usersCustomersId;
  String oneSignalId;
  String walletAmount;
  String? jobsRatings;
  String usersCustomersType;
  String firstName;
  String lastName;
  String phone;
  String email;
  String password;
  String profilePic;
  String? identityDocument;
  String? workEligibilityDocument;
  dynamic jobRadius;
  dynamic googleAccessToken;
  String accountType;
  String socialAccountType;
  String? badgeVerified;
  String notifications;
  String messages;
  String? updateProfile;
  String verifyEmailOtp;
  String emailVerified;
  dynamic forgotPasswordOtp;
  DateTime dateAdded;
  dynamic dateModified;
  String status;

  UsersCustomers({
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
    required this.jobRadius,
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
        "date_added": dateAdded.toIso8601String(),
        "date_modified": dateModified,
        "status": status,
      };
}

class PaymentGateways {
  int paymentGatewaysId;
  String name;
  DateTime dateAdded;
  dynamic dateModified;
  String status;

  PaymentGateways({
    required this.paymentGatewaysId,
    required this.name,
    required this.dateAdded,
    required this.dateModified,
    required this.status,
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
        "date_added": dateAdded.toIso8601String(),
        "date_modified": dateModified,
        "status": status,
      };
}
