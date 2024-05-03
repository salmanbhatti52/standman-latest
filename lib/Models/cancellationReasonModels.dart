// To parse this JSON data, do
//
//     final cancellationReasonModels = cancellationReasonModelsFromJson(jsonString);

import 'dart:convert';

CancellationReasonModels cancellationReasonModelsFromJson(String str) =>
    CancellationReasonModels.fromJson(json.decode(str));

String cancellationReasonModelsToJson(CancellationReasonModels data) =>
    json.encode(data.toJson());

class CancellationReasonModels {
  String? status;
  List<Datum>? data;

  CancellationReasonModels({
    this.status,
    this.data,
  });

  factory CancellationReasonModels.fromJson(Map<String, dynamic> json) =>
      CancellationReasonModels(
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
  int? jobsCancellationsReasonsId;
  String? reason;
  String? customer;
  String? employee;
  DateTime? dateAdded;
  dynamic dateModified;
  String? status;

  Datum({
    this.jobsCancellationsReasonsId,
    this.reason,
    this.customer,
    this.employee,
    this.dateAdded,
    this.dateModified,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        jobsCancellationsReasonsId: json["jobs_cancellations_reasons_id"],
        reason: json["reason"],
        customer: json["Customer"],
        employee: json["Employee"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateModified: json["date_modified"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "jobs_cancellations_reasons_id": jobsCancellationsReasonsId,
        "reason": reason,
        "Customer": customer,
        "Employee": employee,
        "date_added": dateAdded!.toIso8601String(),
        "date_modified": dateModified,
        "status": status,
      };
}
