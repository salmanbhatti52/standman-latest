// To parse this JSON data, do
//
//     final customerDiscount = customerDiscountFromJson(jsonString);

import 'dart:convert';

CustomerDiscount customerDiscountFromJson(String str) => CustomerDiscount.fromJson(json.decode(str));

String customerDiscountToJson(CustomerDiscount data) => json.encode(data.toJson());

class CustomerDiscount {
    String? status;
    Data? data;

    CustomerDiscount({
         this.status,
         this.data,
    });

    factory CustomerDiscount.fromJson(Map<String, dynamic> json) => CustomerDiscount(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
    };
}

class Data {
    String discountApplicable;

    Data({
        required this.discountApplicable,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        discountApplicable: json["discount_applicable"],
    );

    Map<String, dynamic> toJson() => {
        "discount_applicable": discountApplicable,
    };
}
