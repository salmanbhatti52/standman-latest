import 'dart:convert';
import 'package:StandMan/Models/createJobByStrpeDiscount.dart';
import 'package:StandMan/Models/getpaymentMethodModels.dart';
import 'package:StandMan/Models/jobCreationPaymentModel.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/jobs_create_Model.dart';
import '../../../Utils/api_urls.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/ToastMessage.dart';
import '../../../widgets/TopBar.dart';
import '../../Bottombar.dart';
import 'package:http/http.dart' as http;
import 'Paymeny_details.dart';

class SelectPaymentMethod extends StatefulWidget {
  final String? img;
  final String? randomNumbers;
  final String? jobName;
  final String? date;
  final String? long;
  final String? lat;
  final String? time;
  final String? endtime;
  final String? describe;
  final String? price;
  final String? amount;
  final String? chargers;
  final String? tax;
  final String? address;
  final String? totalPrice;
  final double? wallet;
  final double? taxAmount;
  final double? serviceChargesAmount;
  final double? finalPrice;
  final double? originalPrice;
  final double? discountedPrice;
  final String? discountApplicable;
  final String? finecharges;

  const SelectPaymentMethod(
      {super.key,
      this.finecharges,
      this.img,
      this.randomNumbers,
      this.jobName,
      this.date,
      this.long,
      this.lat,
      this.time,
      this.endtime,
      this.describe,
      this.price,
      this.amount,
      this.chargers,
      this.tax,
      this.address,
      this.totalPrice,
      this.wallet,
      this.taxAmount,
      this.serviceChargesAmount,
      this.finalPrice,
      this.originalPrice,
      this.discountedPrice,
      this.discountApplicable});

  @override
  State<SelectPaymentMethod> createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  bool isLoading = false;

  GetPaymentModels getPaymentModels = GetPaymentModels();
  getpaymentlist() async {
    // try {

    String apiUrl = "https://admin.standman.ca/api/get_payment_gateways";
    print("api: $apiUrl");
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
      },
    );
    final responseString = response.body;
    print("response getProfileModels: $responseString");
    print("status Code getProfileModels: ${response.statusCode}");
    print("in 200 getProfileModels");
    if (response.statusCode == 200) {
      print("SuccessFull");
      getPaymentModels = getPaymentModelsFromJson(responseString);
      setState(() {
        isLoading = false;
      });
      print('getProfileModels status: ${getPaymentModels.status}');
    }
  }

  bool isInAsyncCall = false;
  int buttonPressCount = 0;
  JobsCreateModel jobsCreateModel = JobsCreateModel();
  Map<String, dynamic>? discountsMap;
  jobCreated() async {
    print("working");
    print("""" 
    "total_price": ${widget.discountedPrice ?? widget.price},""");
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("userId in Prefs is = $usersCustomersId");
    String apiUrl = 'https://admin.standman.ca/api/create_job';
    print("""
    "job_date": "${widget.date.toString()}",
        "start_time": "${widget.time.toString()}",
        "end_time": "${widget.endtime.toString()}",
""");
    // var headers = {
    //   'Accept': 'application/json',
    //   'Content-Type': 'application/json'
    // };
    // var request = http.Request(
    //     'POST', Uri.parse('https://admin.standman.ca/api/create_job'));
    // request.body = json.encode({
    //   "users_customers_id": usersCustomersId,
    //   "name": widget.jobName != null ? widget.jobName : "",
    //   "location": widget.address,
    //   "longitude": widget.long,
    //   "latitude": widget.lat,
    //   "start_time": widget.time,
    //   "end_time": widget.endtime,
    //   "payment_gateways_id": selectedPayment,
    //   "special_instructions": widget.describe == "" ? "" : widget.describe,
    //   "price": widget.amount,
    //   "service_charges": widget.chargers,
    //   "tax": widget.tax,
    //   "job_date": "${widget.date}",
    //   "total_price": widget.price,
    //   "image": widget.img != null ? widget.img : "",
    // });
    // request.headers.addAll(headers);

    // var res = await request.send();
    // final resBody = await res.stream.bytesToString();

    // if (res.statusCode == 200) {
    //   print(await res.stream.bytesToString());
    //   jobsCreateModel = jobsCreateModelFromJson(resBody);
    //   print("jobsCreateModelApi: ${resBody}");
    // } else {
    //   print(res.reasonPhrase);
    //   jobsCreateModel = jobsCreateModelFromJson(resBody);
    //   print("in 500");
    //   print("jobsCreateModelApi: ${resBody}");
    //   print("status Code jobsCreateModel: ${res.statusCode}");
    //   print("in 500 jobsCreate");
    //   print('jobsCreateModel status: ${jobsCreateModel.status}');
    //   print('jobCreationPayment status: ${jobsCreateModel}');
    //   jobsCreateModel = jobsCreateModelFromJson(resBody);
    // }

    // var headersList = {'Accept': 'application/json'};
    // var url = Uri.parse('https://admin.standman.ca/api/create_job');
    // // if (widget.discountApplicable == "Yes") {
    // //   discountsMap = {
    // //     "discount": "${widget.discountedPrice.toString()}",
    // //     "price": widget.amount,
    // //     "service_charges": "${widget.serviceChargesAmount.toString()}",
    // //     "tax": "${widget.taxAmount.toString()}",
    // //     "total_price": "${widget.finalPrice.toString()}"
    // //   };
    // //   print("discountsMap1: $discountsMap");
    // // }

    // var body = {
    // "users_customers_id": usersCustomersId,
    // "name": widget.jobName != null ? widget.jobName : "",
    // "location": widget.address,
    // "longitude": widget.long,
    // "latitude": widget.lat,
    // "start_time": widget.time,
    // "end_time": widget.endtime,
    // "payment_gateways_id": selectedPayment,
    // "special_instructions": widget.describe == "" ? "" : widget.describe,
    // "price": widget.amount,
    // "service_charges": widget.chargers,
    // "tax": widget.tax,
    // "job_date": "${widget.date}",
    // "total_price": widget.price,
    // "image": widget.img != null ? widget.img : "",
    // "users_customers_id": "133",
    // "location": "Pakistan",
    // "latitude": "33.738045",
    // "longitude": "73.084488",
    // "name": "Test App",
    // "job_date": "2024-01-12",
    // "start_time": "18:30:00",
    // "end_time": "19:30:00",
    // "special_instructions": "Special instructions for test job.",
    // "price": "21.00",
    // "service_charges": "2.10",
    // "tax": "3.47",
    // "total_price": "26.57",
    // "payment_gateways_id": "1",
    // "image": "UklGRlBI",

    // };

    // var req = http.Request('POST', url);
    // req.headers.addAll(headersList);
    // req.body = json.encode(body);

    // var res = await req.send();
    // final resBody = await res.stream.bytesToString();

    // if (res.statusCode == 200) {
    //   print('Request body: ${jsonEncode(body)}');
    //   jobsCreateModel = jobsCreateModelFromJson(resBody);
    //   print(resBody);
    // } else {
    //   print(res.reasonPhrase);
    // }
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
        "name": widget.jobName != null ? widget.jobName : "",
        "location": "${widget.address.toString()}",
        "longitude": widget.long,
        "latitude": widget.lat,
        "job_date": "${widget.date.toString()}",
        "start_time": "${widget.time.toString()}:00",
        "end_time": "${widget.endtime.toString()}:00",
        "special_instructions":
            "${widget.describe.toString() == "" ? "" : widget.describe.toString()}",
        "price": widget.amount,
        "service_charges": widget.chargers,
        "tax": widget.tax,
        "total_price": widget.price,
        "payment_gateways_id": "$selectedPayment",
        "image": widget.img != null ? widget.img : "",
        // "users_customers_id": usersCustomersId,
        // "name": widget.jobName != null ? widget.jobName : "",
        // "location": widget.address,
        // "longitude": widget.long,
        // "latitude": widget.lat,
        // "start_date": widget.date,
        // "start_time": widget.time,
        // "end_time": widget.endtime,
        // "special_instructions": widget.describe == "" ? "" : widget.describe,
        // "price": widget.amount,
        // "service_charges": widget.chargers,
        // "tax": widget.tax,
        // "image": widget.img != null ? widget.img : "",
        // "job_date": "${widget.date}",
        // "total_price": widget.price,
        // "payment_gateways_id": selectedPayment,

        // "jobs_discounts": {
        //   "discount": "${widget.discountedPrice}",
        //   "price": "${widget.amount}",
        //   "service_charges": "${widget.serviceChargesAmount}",
        //   "tax": "${widget.taxAmount}",
        //   "total_price": "${widget.finalPrice}"
        // },
      },
    );
    final responseString = response.body;
    print("jobsCreateModelApi: ${response.body}");
    print("status Code jobsCreateModel: ${response.statusCode}");
    print("in 200 jobsCreate");
    if (response.statusCode == 200) {
      jobsCreateModel = jobsCreateModelFromJson(responseString);
      // setState(() {});
      print('jobsCreateModel status: ${jobsCreateModel.status}');
      print('jobCreationPayment status: ${jobsCreateModel}');
    } else if (response.statusCode == 500) {
      print("in 500");
      print("jobsCreateModelApi: ${response.body}");
      print("status Code jobsCreateModel: ${response.statusCode}");
      print("in 500 jobsCreate");
      print('jobsCreateModel status: ${jobsCreateModel.status}');
      print('jobCreationPayment status: ${jobsCreateModel}');
      jobsCreateModel = jobsCreateModelFromJson(responseString);
    }
  }

  bool progress1 = false;
  CreateJobByStripeDiscount createJobByStripeDiscount =
      CreateJobByStripeDiscount();

  Future<void> createDiscountedJob() async {
    var url = Uri.parse('https://admin.standman.ca/api/create_discounted_job');

    var headers = {
      'Content-Type': 'application/json',
    };

    var body = jsonEncode({
      "users_customers_id": usersCustomersId.toString(),
      "name": widget.jobName?.toString() ?? "",
      "location": widget.address?.toString() ?? "",
      "longitude": widget.long.toString(), // Already a string
      "latitude": widget.lat.toString(), // Already a string
      "job_date": "${widget.date.toString() ?? ""}",
      "start_time": "${widget.time ?? ""}:00",
      "end_time": "${widget.endtime ?? ""}:00",
      "special_instructions": widget.describe?.toString() ?? "",
      "price": widget.amount?.toString() ?? "0.0",
      "service_charges": widget.chargers?.toString() ?? "0.0",
      "tax": widget.tax?.toString() ?? "0.0",
      "total_price": widget.price?.toString() ?? "0.0",
      "payment_gateways_id": "${selectedPayment.toString()}",
      "jobs_discounts": {
        "discount": widget.discountedPrice?.toString() ?? "0.0",
        "price": widget.amount?.toString() ?? "0.0",
        "service_charges": widget.serviceChargesAmount?.toString() ?? "0.0",
        "tax": widget.taxAmount?.toString() ?? "0.0",
        "total_price": widget.finalPrice?.toString() ?? "0.0"
      },
      "image": widget.img?.toString() ?? "",
      // "users_customers_id": usersCustomersId,
      // "name": widget.jobName ?? "",
      // "location": widget.address ?? "",
      // "longitude": widget.long.toString(), // Parse to double
      // "latitude": widget.lat.toString(), // Parse to double
      // "job_date": "2024-01-18",
      // "start_time": "09:44:00",
      // "end_time": "09:50:00",
      // "job_date": "${widget.date.toString() ?? ""}",
      // "start_time": "${widget.time ?? ""}:00",
      // "end_time": "${widget.endtime ?? ""}:00",
      // "special_instructions": widget.describe ?? "",
      // "price": widget.amount ?? 0.0, // Provide default value
      // "service_charges": widget.chargers ?? 0.0, // Provide default value
      // "tax": widget.tax ?? 0.0, // Provide default value
      // "total_price": widget.price ?? 0.0, // Provide default value
      // "jobs_discounts": {
      //   "discount": widget.discountedPrice ?? 0.0, // Provide default value
      //   "price": widget.amount ?? 0.0, // Provide default value
      //   "service_charges":
      //       widget.serviceChargesAmount ?? 0.0, // Provide default value
      //   "tax": widget.taxAmount ?? 0.0, // Provide default value
      //   "total_price": widget.finalPrice ?? 0.0 // Provide default value
      // },
      // "image": widget.img ?? "",
    });

    var response = await http.post(url, headers: headers, body: body);
    var responseString = response.body; // Define responseString here

    if (response.statusCode == 200) {
      print("body: ${body}");
      createJobByStripeDiscount =
          createJobByStripeDiscountFromJson(responseString);
      print("responseString: ${createJobByStripeDiscount.data}");
      print("responseString Message: ${createJobByStripeDiscount.message}");
      print("status Code jobsCreateModel: ${response.statusCode}");
    } else {
      print('Failed to create job');
    }
  }

  Future<void> createJobByStripeDiscountAPI() async {
    String apiUrl = 'https://admin.standman.ca/api/create_discounted_job';
    print("working");
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");
    setState(() {
      progress1 = true;
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: json.encode({
        "users_customers_id": usersCustomersId.toString(),
        "name": widget.jobName?.toString() ?? "",
        "location": widget.address?.toString() ?? "",
        "longitude": widget.long.toString(), // Already a string
        "latitude": widget.lat.toString(), // Already a string
        "job_date": "${widget.date.toString() ?? ""}",
        "start_time": "${widget.time ?? ""}:00",
        "end_time": "${widget.endtime ?? ""}:00",
        "special_instructions": widget.describe?.toString() ?? "",
        "price": widget.amount?.toString() ?? "0.0",
        "service_charges": widget.chargers?.toString() ?? "0.0",
        "tax": widget.tax?.toString() ?? "0.0",
        "total_price": widget.price?.toString() ?? "0.0",
        "payment_gateways_id": "${selectedPayment.toString()}",
        "jobs_discounts": {
          "discount": widget.discountedPrice?.toString() ?? "0.0",
          "price": widget.amount?.toString() ?? "0.0",
          "service_charges": widget.serviceChargesAmount?.toString() ?? "0.0",
          "tax": widget.taxAmount?.toString() ?? "0.0",
          "total_price": widget.finalPrice?.toString() ?? "0.0"
        },
        "image": widget.img?.toString() ?? "",
      }),
    );
    final responseString = response.body;

    print("createJobByStripeDiscount: ${response.body}");
    print("status Code createJobByStripeDiscount: ${response.statusCode}");
    print("in 200 createJobByStripeDiscount");
    if (response.statusCode == 200) {
      createJobByStripeDiscount =
          createJobByStripeDiscountFromJson(responseString);
      setState(() {
        progress1 = false;
      });
      print(
          'createJobByStripeDiscount status: ${createJobByStripeDiscount.status}');
      print(
          'createJobByStripeDiscount status: ${createJobByStripeDiscount.data}');
    } else {
      setState(() {
        progress1 = false;
      });
      print("in 500");
      print("createJobByStripeDiscount: ${response.body}");
      print("status Code createJobByStripeDiscount: ${response.statusCode}");
      print("in 500 createJobByStripeDiscount");
      print(
          'createJobByStripeDiscount status: ${createJobByStripeDiscount.status}');
      print(
          'createJobByStripeDiscount status: ${createJobByStripeDiscount.data}');
    }

    // prefs = await SharedPreferences.getInstance();
    // usersCustomersId = prefs!.getString('usersCustomersId');
    // print("usersCustomersId = $usersCustomersId");
    // try {
    //   print("${widget.discountApplicable}");
    //   var headersList = {
    //     'Accept': 'application/json',
    //     'Content-Type': 'application/json'
    //   };

    //   // Check for null values before constructing the request body
    //   if (usersCustomersId == null ||
    //       widget.address == null ||
    //       widget.lat == null ||
    //       widget.long == null ||
    //       widget.jobName == null ||
    //       widget.date == null ||
    //       widget.time == null ||
    //       widget.endtime == null ||
    //       widget.describe == null ||
    //       widget.amount == null ||
    //       widget.chargers == null ||
    //       widget.tax == null ||
    //       widget.price == null ||
    //       widget.discountedPrice == null ||
    //       widget.serviceChargesAmount == null ||
    //       widget.taxAmount == null ||
    //       widget.finalPrice == null) {
    //     print("Error: Some fields are null. Aborting API call.");
    //     return;
    //   }

    //   var request = http.Request('POST',
    //       Uri.parse('https://admin.standman.ca/api/create_discounted_job'));

    //   // Check for null values and use consistent string interpolation
    //   var requestBody = {
    //     "users_customers_id": usersCustomersId,
    //     "name": widget.jobName ?? "",
    //     "location": widget.address ?? "",
    //     "longitude": double.parse(widget.long.toString()), // Parse to double
    //     "latitude": double.parse(widget.lat.toString()), // Parse to double
    //     "job_date": widget.date ?? "",
    //     "start_time": "${widget.time ?? ""}:00",
    //     "end_time": "${widget.endtime ?? ""}:00",
    //     "special_instructions": widget.describe ?? "",
    //     "price": widget.amount ?? 0.0, // Provide default value
    //     "service_charges": widget.chargers ?? 0.0, // Provide default value
    //     "tax": widget.tax ?? 0.0, // Provide default value
    //     "total_price": widget.price ?? 0.0, // Provide default value
    //     "jobs_discounts": {
    //       "discount": widget.discountedPrice ?? 0.0, // Provide default value
    //       "price": widget.amount ?? 0.0, // Provide default value
    //       "service_charges":
    //           widget.serviceChargesAmount ?? 0.0, // Provide default value
    //       "tax": widget.taxAmount ?? 0.0, // Provide default value
    //       "total_price": widget.finalPrice ?? 0.0 // Provide default value
    //     },
    //     "image": widget.img ?? "",
    //   };

    //   print("Request Body: $requestBody");

    //   request.body = json.encode(requestBody);
    //   request.headers.addAll(headersList);

    //   http.StreamedResponse response = await request.send();
    //   final resBody = await response.stream.bytesToString();

    //   if (response.statusCode == 200) {
    //     print("Response Body: $resBody");
    //     createJobByStripeDiscount = createJobByStripeDiscountFromJson(resBody);
    //   } else {
    //     print("Request: $request");
    //     print("Response Reason: ${response.reasonPhrase}");
    //   }
    // } catch (e) {
    //   print("Error: $e");
    // }
  }

  // Future<void> createJobByStripeDiscountAPI() async {
  //   print("${widget.discountApplicable}");
  //   var headersList = {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json'
  //   };
  //   var request = http.Request('POST',
  //       Uri.parse('https://admin.standman.ca/api/create_discounted_job'));

  //   discountsMap = {
  //     "discount": "${widget.discountedPrice.toString()}",
  //     "price": "${widget.amount}",
  //     "service_charges": "${widget.serviceChargesAmount.toString()}",
  //     "tax": "${widget.taxAmount.toString()}",
  //     "total_price": "${widget.finalPrice.toString()}"
  //   };
  //   print("discountsMap1: $discountsMap");

  //   request.body = json.encode({
  //     "users_customers_id": usersCustomersId,
  //     "name": widget.jobName != null ? widget.jobName : "",
  //     "location": "${widget.address.toString()}",
  //     "longitude": widget.long,
  //     "latitude": widget.lat,
  //     "job_date": "${widget.date.toString()}",
  //     "start_time": "${widget.time.toString()}:00",
  //     "end_time": "${widget.endtime.toString()}:00",
  //     "special_instructions":
  //         "${widget.describe.toString() == "" ? "" : widget.describe.toString()}",
  //     "price": widget.amount,
  //     "service_charges": widget.chargers,
  //     "tax": widget.tax,
  //     "total_price": widget.price,
  //     "jobs_discounts": discountsMap,
  //     "image": widget.img != null ? widget.img : "",
  //   });

  //   request.headers.addAll(headersList);

  //   http.StreamedResponse response = await request.send();
  //   final resBody = await response.stream.bytesToString();
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //     createJobByStripeDiscount = createJobByStripeDiscountFromJson(resBody);
  //   } else {
  //     print(request);
  //     print(response.reasonPhrase);
  //   }
  //   // request.headers.addAll(headersList);

  //   // http.StreamedResponse response = await request.send();
  //   // final resBody = await response.stream.bytesToString();
  //   // if (response.statusCode == 200) {
  //   //   createJobByStripeDiscount = createJobByStripeDiscountFromJson(resBody);
  //   //   print("body: ${resBody}");
  //   //   print(request);
  //   //   // print(await response.stream.bytesToString());

  //   //   print(resBody);
  //   // } else {
  //   //   print(request);
  //   //   print("res.reasonPhrase: ${response.reasonPhrase}");
  //   //   // final resBody = await response.stream.bytesToString();
  //   //   // createJobByWalletDiscount = createJobByWalletDiscountFromJson(resBody);
  //   // }
  //   // var req = http.Request('POST', url);
  //   // req.headers.addAll(headersList);
  //   // req.body = json.encode(body);

  //   // var res = await req.send();
  //   // final resBody = await res.stream.bytesToString();

  //   // if (res.statusCode == 200) {
  //   //   print("body: ${body}");
  //   //   print(jsonEncode(body));
  //   //   createJobByStripeDiscount = createJobByStripeDiscountFromJson(resBody);
  //   //   print(resBody);
  //   // } else {
  //   //   print("res.reasonPhrase: ${res.reasonPhrase}");
  //   // }
  // }

  // jobCreationPayment() async {
  //   String apiUrl = jobCreationPaymentApiUrl;
  //   print("working");

  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {"Accept": "application/json"},
  //     body: {
  //       // "users_customers_id": jobsCreateModel.data?.usersCustomersId.toString(),
  //       "transaction_id": widget.randomNumbers.toString(),
  //       "jobs_id": jobsCreateModel.data?.jobsId.toString(),
  //       "payment_gateways_id": selectedPayment.toString(),
  //       "payment_status": "Paid",
  //     },
  //   );
  //   final responseString = response.body;
  //   print("jobCreationPayment: ${responseString}");
  //   if (response.statusCode == 200) {
  //     print('jobCreationPayment status: ${jobsCreateModel.status}');
  //   }
  // }
  JobCreationPaymentModel jobCreationPaymentModel = JobCreationPaymentModel();
  bool progress = false;
  // jobCreationPayment() async {
  //   String apiUrl = "https://admin.standman.ca/api/pay_created_job_price";
  //   print("working");
  //   setState(() {
  //     progress = true;
  //   });

  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {"Accept": "application/json"},
  //     body: {
  //       "jobs_id": jobsCreateModel.data?.jobsId?.toString() ?? "",
  //       "payment_status": "Paid",
  //       "transaction_id": widget.randomNumbers ?? "",
  //       "balance_wallet": widget.finecharges ?? ""
  //     },
  //   );
  //   final responseString = response.body;
  //   print("jobCreationPayment: ${response.body}");
  //   print("status Code jobCreationPayment: ${response.statusCode}");
  //   print("in 200 jobCreationPayment");
  //   if (response.statusCode == 200) {
  //     jobCreationPaymentModel = jobCreationPaymentModelFromJson(responseString);
  //     setState(() {
  //       progress = false;
  //     });
  //     print('jobCreationPayment status: ${jobCreationPaymentModel.status}');
  //     print('jobCreationPayment status: ${jobCreationPaymentModel.data}');
  //   }
  // }

  Future<void> jobCreationPayment() async {
    String apiUrl = jobCreationPaymentApiUrl;
    print("working");

    // Check for null values and log them
    Map<String, String?> fields = {
      // "total_price": widget.totalPrice,
      "jobs_id": jobsCreateModel.data?.jobsId?.toString() ??
          createJobByStripeDiscount.data?.jobsId.toString() ??
          "",
      "payment_status": "Paid",
      "transaction_id": isNumeric(widget.randomNumbers ?? "")
          ? widget.randomNumbers ?? ""
          : "0.0",
      "balance_wallet":
          isNumeric(widget.finecharges ?? "") ? widget.finecharges ?? "" : "0.0"
    };

    List<String> nullFields = [];
    fields.forEach((key, value) {
      if (value == null || value.isEmpty) {
        nullFields.add(key);
      }
    });

    if (nullFields.isNotEmpty) {
      print("The following fields are null or empty: $nullFields");
      return; // Stop execution if any required field is null or empty
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: fields.map((key, value) =>
          MapEntry(key, value ?? "")), // Convert null values to empty strings
    );

    final responseString = response.body;
    print("jobCreationPayment: $responseString");
    print("status Code jobCreationPayment: ${response.statusCode}");
    if (response.statusCode == 200) {
      jobCreationPaymentModel = jobCreationPaymentModelFromJson(responseString);
      setState(() {
        progress = false;
      });
      print('jobCreationPayment status: ${jobCreationPaymentModel.status}');
      print('jobCreationPayment data: ${jobCreationPaymentModel.data}');
    } else {
      // Handle non-200 responses
      setState(() {
        progress = false;
      });
    }
  }
  // Future<void> jobCreationPayment() async {
  //   String apiUrl = jobCreationPaymentApiUrl;
  //   print("working");
  //   print(
  //       " createJobByStripeDiscount.data!.jobsId.toString(): ${createJobByStripeDiscount.data!.jobsId.toString()}");
  //   setState(() {
  //     progress = true;
  //   });

  //   // Check for null values and log them
  // Map<String, String?> fields = {
  //   // "total_price": widget.totalPrice,
  //   "jobs_id": jobsCreateModel.data?.jobsId?.toString() ??
  //       createJobByStripeDiscount.data?.jobsId.toString() ??
  //       "",
  //   "payment_status": "Paid",
  //   "transaction_id": isNumeric(widget.randomNumbers ?? "")
  //       ? widget.randomNumbers ?? ""
  //       : "0.0",
  //   "balance_wallet":
  //       isNumeric(widget.finecharges ?? "") ? widget.finecharges ?? "" : "0.0"
  // };

  //   List<String> nullFields = [];
  //   fields.forEach((key, value) {
  //     if (value == null || value.isEmpty) {
  //       nullFields.add(key);
  //     }
  //   });

  //   if (nullFields.isNotEmpty) {
  //     print("The following fields are null or empty: $nullFields");
  //     setState(() {
  //       progress = false;
  //     });
  //     return; // Stop execution if any required field is null or empty
  //   }

  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {"Accept": "application/json"},
  //     body: fields.map((key, value) =>
  //         MapEntry(key, value ?? "")), // Convert null values to empty strings
  //   );

  //   final responseString = response.body;
  //   print("jobCreationPayment: $responseString");
  //   print("status Code jobCreationPayment: ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     jobCreationPaymentModel = jobCreationPaymentModelFromJson(responseString);
  //     setState(() {
  //       progress = false;
  //     });
  //     print('jobCreationPayment status: ${jobCreationPaymentModel.status}');
  //     print('jobCreationPayment data: ${jobCreationPaymentModel.data}');
  //   } else {
  //     // Handle non-200 responses
  //     setState(() {
  //       progress = false;
  //     });
  //   }
  // }

  Map<String, dynamic>? paymentIntent;

  // calculateAmount(String amount) {
  //   amount = "${jobsCreateModel.data?.totalPrice}";
  //   final a = (int.parse(amount)) * 100;
  //   print("amount ${a}");
  //   final calculatedAmout = a;
  //   print("calculatedAmout ${calculatedAmout}");
  //   return calculatedAmout.toString();
  // }
  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  String calculateAmount(String amount) {
    try {
      print("widget.finecharges ${widget.finecharges}");
      print('Amount before addition: $amount');
      print('Final price: ${widget.finalPrice}');
      double numericAmount =
          (widget.finalPrice == null ? double.parse(amount) : 0.0) +
              (widget.finalPrice != null ? widget.finalPrice! : 0.0) +
              (widget.finecharges != null && isNumeric(widget.finecharges!)
                  ? double.parse(widget.finecharges!)
                  : 0.0);
      print('Numeric amount after addition: $numericAmount');
      print("numericAmount $numericAmount");
      int amountInCents = (numericAmount * 100).toInt();
      print("Amount in cents: $amountInCents");
      return amountInCents.toString();
    } catch (e) {
      // Handle the case where parsing the numeric amount fails
      print('Error parsing the numeric amount: $e');
    }
    // Handle cases where the amount is null or not a valid numeric string
    return "0"; // Return a default value or handle it based on your application's logic.
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      print("hello");
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51MV6RqJ1o3iGht9r8pNwA1f92pJOs9vweMCsMA6HJuTQtCiy0HTlPIAXFiI57ffEiu7EmmmfU0IHbjBGw4k5IliP0017I4MuHw',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  final DraggableScrollableController scrollController =
      DraggableScrollableController();

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('${widget.price}', 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'StandMan'))
          .then((value) {});

      ///now finally display payment sheeet
      await displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        await jobCreationPayment();
        if (jobCreationPaymentModel.status == "success") {
          showDialog(
              barrierDismissible: false,
              builder: (BuildContext context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: Get.width * 0.9, //350,
                          height: Get.height * 0.3, // 321,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: Get.height * 0.05,
                              ),
                              const Text(
                                "Job Posted\nSuccessfully!",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: "Outfit",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: -0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: Get.height * 0.04,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(() => bottom_bar(
                                          currentIndex: 0,
                                        ));
                                    // Get.back();
                                  },
                                  child: mainButton("Go Back To Home",
                                      Color(0xff2B65EC), context)),
                            ],
                          ),
                        ),
                        Positioned(
                            top: -48,
                            child: Container(
                              width: Get.width,
                              //106,
                              height: Get.height * 0.13,
                              //106,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffFF9900),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 40,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
              context: context);
        } else {
          toastFailedMessage("Job Posting Failed", Colors.red);
        }
        paymentIntent = null;
      }).onError((error, stackTrace) {
        if (error != null) {
          throw Exception(error.toString());
        } else {
          throw Exception('An unknown error occurred');
        }
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ),
          context: context);
    } catch (e) {
      print('$e');
    }
  }

  String? selectedPayment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpaymentlist();
    print("Total Price: ${widget.totalPrice}");
    print("discountedprice  init:  ${widget.discountedPrice}");
    print("price in inti ${widget.price}");
    print("Final Price in inti ${widget.finalPrice}");
  }

  void showGoBackDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Please go back'),
          content: Text('Please go back and create the job again.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Get.to(() => bottom_bar(currentIndex: 0));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    buttonPressCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          buttonPressCount = 0;
        });
        Get.back();
        Get.to(() => bottom_bar(currentIndex: 0));
        return false;
      },
      child: Scaffold(
          appBar: StandManAppBar1(
            title: "Select Payment Mothods",
            bgcolor: Color(0xff2B65EC),
            titlecolor: Colors.white,
            iconcolor: Colors.white,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: DropdownButtonFormField<String>(
                  iconDisabledColor: Colors.transparent,
                  iconEnabledColor: Colors.transparent,
                  value: selectedPayment,
                  onChanged: (newValue) {
                    setState(() {
                      selectedPayment = newValue;
                      print(selectedPayment);
                    });
                  },
                  items: getPaymentModels.data?.map((payment) {
                        return DropdownMenuItem<String>(
                          value: payment.paymentGatewaysId.toString(),
                          child: Text(payment.name ?? ''),
                        );
                      }).toList() ??
                      [],
                  decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.arrow_drop_down_sharp)],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff2B65EC)),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: "Select Payment Method",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFFF3F3F3),
                      ),
                    ),
                    hintStyle: const TextStyle(
                      color: Color(0xFFA7A9B7),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      fontFamily: "Satoshi",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: GestureDetector(
                    onTap: () async {
                      print("buttonPressCount main $buttonPressCount");

                      if (buttonPressCount >= 1) {
                        print("buttonPressCount if $buttonPressCount");
                        showGoBackDialog(context);
                      } else {
                        print("buttonPressCount else if $buttonPressCount");

                        if (selectedPayment == null) {
                          toastMessage(
                              "Please Select Payment Method", Colors.red);
                        } else {
                          setState(() {
                            isInAsyncCall = true;
                          });
                          prefs = await SharedPreferences.getInstance();
                          usersCustomersId =
                              prefs!.getString('usersCustomersId');
                          print("usersCustomersId: $usersCustomersId");
                          print("img: ${widget.img}");
                          print("randomNumbers: ${widget.randomNumbers}");
                          print("jobName: ${widget.jobName}");
                          print("date: ${widget.date}");
                          print("long: ${widget.long}");
                          print("lat: ${widget.lat}");
                          print("time: ${widget.time}");
                          print("endtime: ${widget.endtime}");
                          print("describe: ${widget.describe}");
                          print("price: ${widget.price}");
                          print("amount: ${widget.amount}");
                          print("chargers: ${widget.chargers}");
                          print("tax: ${widget.tax}");
                          print("address: ${widget.address}");
                          print("selectedPayment: $selectedPayment");
                          print(
                              """"total_price": ${widget.discountedPrice ?? widget.price},""");
                          if (widget.discountApplicable == "Yes") {
                            await createDiscountedJob();
                            if (createJobByStripeDiscount.status == "success") {
                              setState(() {
                                buttonPressCount++;
                              });
                              print(
                                  "buttonPressCount in success $buttonPressCount");
                              await makePayment();
                            } else {
                              toastFailedMessage(
                                  createJobByStripeDiscount.message,
                                  Colors.red);
                            }
                            setState(() {
                              isInAsyncCall = false;
                            });
                          } else {
                            await jobCreated();

                            if (jobsCreateModel.status == "success") {
                              setState(() {
                                buttonPressCount++;
                              });
                              print(
                                  "buttonPressCount in success $buttonPressCount");

                              await makePayment();
                            } else {
                              toastFailedMessage(
                                  jobsCreateModel.message, Colors.red);
                            }
                            setState(() {
                              isInAsyncCall = false;
                            });
                          }
                        }
                      }
                    },
                    child: isInAsyncCall
                        ? loadingBar(context)
                        : mainButton("Proceed", Color(0xff2B65EC), context)),
              ),
            ],
          )),
    );
  }
}

// selectPayment(
//   String? img,
//   String? randomNumbers,
//   String? jobName,
//   String? date,
//   String? long,
//   String? lat,
//   String? time,
//   String? endtime,
//   String? describe,
//   String? price,
//   String? amount,
//   String? chargers,
//   String? tax,
//   String? address,
//   BuildContext ctx,
// ) {
//   int _selected = 0;
//   bool isInAsyncCall = false;

//   JobsCreateModel jobsCreateModel = JobsCreateModel();
//   jobCreationPayment() async {
//     String apiUrl = jobCreationPaymentApiUrl;
//     print("working");

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {"Accept": "application/json"},
//       body: {
//         // "users_customers_id": jobsCreateModel.data?.usersCustomersId.toString(),
//         "transaction_id": randomNumbers.toString(),
//         "jobs_id": jobsCreateModel.data?.jobsId.toString(),
//         "payment_gateways_id": "1",
//         "payment_status": "Paid",
//       },
//     );
//     final responseString = response.body;
//     print("jobCreationPayment: ${responseString}");
//     if (response.statusCode == 200) {
//       print('jobCreationPayment status: ${jobsCreateModel.status}');
//     }
//   }

//   Map<String, dynamic>? paymentIntent;

//   calculateAmount(String amount) {
//     amount = "${jobsCreateModel.data?.totalPrice}";
//     print("amount ${amount}");
//     final a = (int.parse(amount)) * 100;
//     print("amount ${a}");
//     final calculatedAmout = a;
//     print("calculatedAmout ${calculatedAmout}");
//     return calculatedAmout.toString();
//   }

//   createPaymentIntent(String amount, String currency) async {
//     try {
//       print("hello");
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization':
//               'Bearer sk_test_51MV6RqJ1o3iGht9r8pNwA1f92pJOs9vweMCsMA6HJuTQtCiy0HTlPIAXFiI57ffEiu7EmmmfU0IHbjBGw4k5IliP0017I4MuHw',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       // ignore: avoid_print
//       print('Payment Intent Body->>> ${response.body.toString()}');
//       return jsonDecode(response.body);
//     } catch (err) {
//       // ignore: avoid_print
//       print('err charging user: ${err.toString()}');
//     }
//   }

//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         showDialog(
//           context: ctx,
//           barrierDismissible: false,
//           builder: (BuildContext context) => Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30.0),
//             ),
//             child: Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.topCenter,
//               children: [
//                 Container(
//                   width: Get.width * 0.9, //350,
//                   height: Get.height * 0.3, // 321,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: Get.height * 0.05,
//                       ),
//                       const Text(
//                         "Job Posted\nSuccessfully!",
//                         style: TextStyle(
//                           color: Color.fromRGBO(0, 0, 0, 1),
//                           fontFamily: "Outfit",
//                           fontSize: 20,
//                           fontWeight: FontWeight.w500,
//                           // letterSpacing: -0.3,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(
//                         height: Get.height * 0.04,
//                       ),
//                       GestureDetector(
//                           onTap: () {
//                             Get.to(() => bottom_bar(
//                                   currentIndex: 0,
//                                 ));
//                             // Get.back();
//                           },
//                           child: mainButton(
//                               "Go Back To Home", Color(0xff2B65EC), context)),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                     top: -48,
//                     child: Container(
//                       width: Get.width,
//                       //106,
//                       height: Get.height * 0.13,
//                       //106,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xffFF9900),
//                       ),
//                       child: Icon(
//                         Icons.check,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                     ))
//               ],
//             ),
//           ),
//         );

//         paymentIntent = null;
//       }).onError((error, stackTrace) {
//         print('Error is:--->$error $stackTrace');
//       });
//     } on StripeException catch (e) {
//       print('Error is:---> $e');
//       showDialog(
//           context: ctx,
//           builder: (_) => const AlertDialog(
//                 content: Text("Cancelled "),
//               ));
//     } catch (e) {
//       print('$e');
//     }
//   }

//   Future<void> makePayment() async {
//     try {
//       paymentIntent = await createPaymentIntent('20', 'USD');
//       //Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters: SetupPaymentSheetParameters(
//                   paymentIntentClientSecret: paymentIntent?['client_secret'],
//                   // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
//                   // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
//                   style: ThemeMode.dark,
//                   merchantDisplayName: 'Hammad'))
//           .then((value) {});

//       ///now finally display payment sheeet
//       displayPaymentSheet();
//     } catch (e, s) {
//       print('exception:$e$s');
//     }
//   }

//   return showFlexibleBottomSheet(
//       isExpand: false,
//       initHeight: 0.44,
//       maxHeight: 0.44,
//       bottomSheetColor: Colors.transparent,
//       barrierColor: Colors.black.withOpacity(0.1),
//       context: ctx,
//       builder: (context, controller, offset) {
//         return StatefulBuilder(
//             builder: (BuildContext context, StateSetter stateSetterObject) {
//           var height = MediaQuery.of(context).size.height;
//           var width = MediaQuery.of(context).size.width;
//           return Container(
//             width: width, //390,
//             height: height * 0.5, // 547,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 topLeft: Radius.circular(30),
//               ),
//             ),
//             child: SingleChildScrollView(
//               child: Padding(
//                   padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Payment Method",
//                             style: TextStyle(
//                               color: Color.fromRGBO(0, 0, 0, 1),
//                               fontFamily: "Outfit",
//                               fontSize: 20,
//                               fontWeight: FontWeight.w500,
//                               // letterSpacing: -0.3,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Icon(
//                               Icons.close,
//                               color: Colors.black,
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: Get.height * 0.02,
//                       ),
//                     ],
//                   )),
//             ),
//           );
//         });
//       });
// }
