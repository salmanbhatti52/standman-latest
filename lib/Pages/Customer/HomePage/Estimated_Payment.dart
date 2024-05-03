import 'dart:convert';
import 'package:StandMan/Models/createJobWallet.dart';
import 'package:StandMan/Models/createjobwalletwithDiscount.dart';
import 'package:StandMan/Models/customerDiscount.dart';
import 'package:StandMan/Models/getprofile.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Pages/Customer/HomePage/selectPayment.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/createJobByWalletDiscount.dart';
import '../../../Models/jobs_create_Model.dart';
import '../../../Utils/api_urls.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/ToastMessage.dart';
import '../../../widgets/TopBar.dart';
import '../../Bottombar.dart';
import 'package:http/http.dart' as http;
import 'Paymeny_details.dart';

Estimated_PaymentMethod(
    {double? wallet,
    String? img,
    double? finecharges,
    double? tex,
    double? serviceCharges,
    String? discountPercentAge,
    String? randomNumbers,
    String? jobName,
    String? date,
    String? long,
    String? lat,
    String? time,
    String? endtime,
    String? describe,
    BuildContext? ctx,
    String? price,
    String? amount,
    String? chargers,
    String? tax,
    String? discountApplicable,
    String? address,
    String? total}) {
  int _selected = 0;
  bool isInAsyncCall = false;
  double? paymentPrice;
  double? taxAmount;
  double? serviceChargesAmount;
  double? finalPrice;
  double? originalPrice;
  double? FineTotalPrice;
  double? discountedPrice;
  JobsCreateModel jobsCreateModel = JobsCreateModel();

  CreateJobWallet createJobWallet = CreateJobWallet();
  String? data;
  Map<String, dynamic>? discountsMap;

  CreateJobByWalletDiscount createJobByWalletDiscount =
      CreateJobByWalletDiscount();
  Future<void> createJobByWalletDiscountAPI() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://admin.standman.ca/api/create_discounted_job_by_wallet'));

    discountsMap = {
      "discount": "${discountedPrice.toString()}",
      "price": amount,
      "service_charges": "${serviceChargesAmount.toString()}",
      "tax": "${taxAmount.toString()}",
      "total_price": "${finalPrice.toString()}"
    };
    print("discountsMap1: $discountsMap");
    request.body = json.encode({
      "users_customers_id": usersCustomersId,
      "name": jobName ?? "",
      "location": address,
      "longitude": long,
      "latitude": lat,
      "job_date": "${date.toString()}",
      "start_time": "${time.toString()}:00",
      "end_time": "${endtime.toString()}:00",
      "special_instructions": describe!.isEmpty ? "" : describe,
      "price": amount,
      "service_charges": chargers,
      "tax": tax,
      "total_price": total,
      "jobs_discounts": discountsMap,
      "image": img ?? "",
    });

    // request.headers.addAll(headersList);

    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    //   // createJobByWalletDiscount = createJobByWalletDiscountFromJson(resBody);
    // } else {
    //   print(response.reasonPhrase);
    // }

    request.headers.addAll(headersList);

    http.StreamedResponse response = await request.send();
    final resBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      createJobByWalletDiscount = createJobByWalletDiscountFromJson(resBody);
      // print("body: ${resBody}");
      // print(request);
      // print(await response.stream.bytesToString());

      // print(resBody);
    } else {
      print(request);
      print("res.reasonPhrase: ${response.reasonPhrase}");
      // final resBody = await response.stream.bytesToString();
      // createJobByWalletDiscount = createJobByWalletDiscountFromJson(resBody);
    }
  }

  Future<void> createJobByWallet() async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://admin.standman.ca/api/create_job_by_wallet'));
    request.body = json.encode({
      "users_customers_id": usersCustomersId ?? "",
      "location": "${address.toString()}",
      "longitude": long ?? 0,
      "latitude": lat ?? 0,
      "name": jobName ?? "",
      "job_date": "${date.toString()}" ?? "",
      "start_time": "${time.toString()}:00" ?? "",
      "end_time": "${endtime.toString()}:00" ?? "",
      "special_instructions": describe!.isEmpty ? "" : describe,
      "price": amount ?? 0,
      "service_charges": chargers ?? 0,
      "tax": tax ?? 0,
      "total_price": total ?? 0,
      "image": img ?? "",
      // "users_customers_id": usersCustomersId ?? "",
      // "name": jobName ?? "",
      // "location": address ?? "",
      // "longitude": long ?? 0,
      // "latitude": lat ?? 0,
      // "job_date": "${date.toString()}" ?? "",
      // "start_time": "${time.toString()}:00" ?? "",
      // "end_time": "${endtime.toString()}:00" ?? "",
      // "special_instructions": describe.isEmpty ? "" : describe,
      // "price": amount ?? 0,
      // "service_charges": chargers ?? 0,
      // "tax": tax ?? 0,
      // "total_price": total ?? 0,
      // "image": img ?? "",
    });
    request.headers.addAll(headersList);

    http.StreamedResponse response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print("body: ${resBody}");

      createJobWallet = createJobWalletFromJson(resBody);
      print(resBody);
    } else {
      print("res.reasonPhrase: ${response.reasonPhrase}");
      createJobWallet = createJobWalletFromJson(resBody);
    }
  }

  GetProfile getProfile = GetProfile();

  getprofile() async {
    // try {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");

    String apiUrl = usersProfileApiUrl;
    print("getUserProfileApi: $apiUrl");

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
    }, body: {
      "users_customers_id": usersCustomersId.toString(),
    });
    final responseString = response.body;
    print("response getProfileModels: $responseString");
    print("status Code getProfileModels: ${response.statusCode}");
    print("in 200 getProfileModels");
    if (response.statusCode == 200) {
      print("SuccessFull");
      getProfile = getProfileFromJson(responseString);

      print('getProfileModels status: ${getProfile.status}');
    }
  }

  jobCreationPayment() async {
    String apiUrl = jobCreationPaymentApiUrl;
    print("working");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": jobsCreateModel.data?.usersCustomersId.toString(),
        "transaction_id": randomNumbers.toString(),
        "jobs_id": jobsCreateModel.data?.jobsId.toString(),
      },
    );
    final responseString = response.body;
    print("jobCreationPayment: ${responseString}");
    if (response.statusCode == 200) {
      print('jobCreationPayment status: ${jobsCreateModel.status}');
    }
  }

  Map<String, dynamic>? paymentIntent;

  calculateAmount(String amount) {
    amount = "${jobsCreateModel.data?.totalPrice}";
    final a = (int.parse(amount)) * 100;
    print("amount ${a}");
    final calculatedAmout = a;
    print("calculatedAmout ${calculatedAmout}");
    return calculatedAmout.toString();
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

  CustomerDiscount customerDiscount = CustomerDiscount();

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: ctx!,
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
                          child: mainButton(
                              "Go Back To Home", Color(0xff2B65EC), context)),
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
        );

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: ctx!,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('20', 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Hammad'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  String? fineTotalPriceFormatted;
  if (finecharges != null) {
    FineTotalPrice = (double.tryParse(total!) ?? 0.0) + finecharges;
    fineTotalPriceFormatted = FineTotalPrice.toStringAsFixed(2);
    print("FineTotalPrice $fineTotalPriceFormatted");
  }

  // Parse the original price
  if (discountApplicable == "Yes") {
    originalPrice = double.tryParse(amount!) ?? 0.0;
    print("originalPrice $originalPrice");
    double discountPercentAgeNum = double.parse(discountPercentAge!);
    print("discountPercentAgeNum ${discountPercentAgeNum}");
    discountedPrice = double.parse(
      (originalPrice * (1 - (discountPercentAgeNum / 100))).toStringAsFixed(2),
    );

    taxAmount =
        double.parse((discountedPrice * (tex! / 100)).toStringAsFixed(2));
    serviceChargesAmount = double.parse(
        (discountedPrice * (serviceCharges! / 100)).toStringAsFixed(2));
    finalPrice = double.parse(
        (discountedPrice + taxAmount + serviceChargesAmount)
            .toStringAsFixed(2));
    print("discountedPrice in if: ${discountedPrice}");
    print("taxAmount $taxAmount");
    print("serviceChargesAmount $serviceChargesAmount");
    print("finalPrice $finalPrice");
  } else if (discountApplicable == "No") {
    originalPrice = double.tryParse(price!) ?? 0.0;
    discountedPrice = null;
    taxAmount = null;
    serviceChargesAmount = null;
    finalPrice = null;
    originalPrice = null;

    print("discountedPrice in else if: ${discountedPrice}");
  } else {
    originalPrice = double.tryParse(price!) ?? 0.0;
    discountedPrice = null;
    print("discountedPrice in else ${discountedPrice}");
  }

  return showFlexibleBottomSheet(
      isExpand: false,
      initHeight: 0.46,
      maxHeight: 0.46,
      bottomSheetColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.1),
      context: ctx!,
      builder: (context, controller, offset) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetterObject) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
            width: width, //390,
            height: height * 0.55, // 547,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    paymentBar(
                      "assets/images/left.svg",
                      Colors.black,
                      "Estimated Payment",
                      Colors.black,
                      "assets/images/info.svg",
                      () {
                        Get.back();
                      },
                      () {
                        Payment_Details(ctx: context);
                      },
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    discountApplicable != "No"
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  discountedPrice != null
                                      ? Text(
                                          "\$${finalPrice!.toDouble()}",
                                          style: TextStyle(
                                            color: Color(0xff2B65EC),
                                            fontFamily: "Outfit",
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                32, // Adjust the size of the discounted price
                                          ),
                                        )
                                      : Text(
                                          "\$$originalPrice",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: "Outfit",
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                20, // Adjust the size of the original price
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                  SizedBox(
                                      height:
                                          4), // Adjust spacing between prices
                                  Container(
                                    width: 50, // Adjust the width of the line
                                    height: 2, // Adjust the height of the line
                                    color: Colors.black, // Adjust line color
                                  ),
                                ],
                              ),
                              SizedBox(
                                  width: 8), // Adjust spacing between prices
                              Text(
                                "\$$total",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      20, // Adjust the size of the original price
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          )
                        : fineTotalPriceFormatted != null
                            ? Text(
                                "\$$fineTotalPriceFormatted",
                                style: TextStyle(
                                  color: Color(0xff2B65EC),
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32,
                                ),
                              )
                            : Text(
                                "\$$total",
                                style: TextStyle(
                                  color: Color(0xff2B65EC),
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32,
                                ),
                              ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Amount",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.2,
                        ),
                        discountApplicable != "No"
                            ? Row(
                                children: [
                                  Text(
                                    "\$$originalPrice",
                                    style: TextStyle(
                                      color: Color(0xff000000),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  Text(
                                    "\$$discountedPrice",
                                    style: TextStyle(
                                      color: Color(0xff000000),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "\$$amount",
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Service Charges",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.1,
                          ),
                          serviceChargesAmount != null
                              ? Text(
                                  // "\$2",
                                  "\$$serviceChargesAmount",
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                )
                              : Text(
                                  // "\$2",
                                  "\$$chargers",
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Tax",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.29,
                        ),
                        taxAmount != null
                            ? Text(
                                // "\$20",
                                "\$$taxAmount",
                                // '\$$discountPrice',
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              )
                            : Text(
                                // "\$20",
                                "\$$tax",
                                // '\$$discountPrice',
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Fine Charges",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.16,
                        ),
                        finecharges != null
                            ? Text(
                                // "\$20",
                                "\$$finecharges",
                                // '\$$discountPrice',
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              )
                            : Text(
                                // "\$20",
                                "\$0.0",
                                // '\$$discountPrice',
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.012,
                    ),
                    Text(
                      "Base rate - \$21/hour (0.35¢/minute)",
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontFamily: "Outfit",
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        'Service fee - 10%',
                        style: TextStyle(
                          color: Color(0xff000000),
                          fontFamily: "Outfit",
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Text(
                      "Tax - 13%",
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontFamily: "Outfit",
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: GestureDetector(
                        onTap: () async {
                          stateSetterObject(() {
                            isInAsyncCall = true;
                          });
                          if (wallet != null &&
                              wallet >= double.parse(price!)) {
                            if (discountApplicable == "Yes") {
                              await createJobByWalletDiscountAPI();
                              if (createJobByWalletDiscount.status ==
                                  "success") {
                                showDialog(
                                  context: context,
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
                                          width: width * 0.9, //350,
                                          height: height * 0.3, // 321,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: Get.height * 0.05,
                                              ),
                                              const Text(
                                                "Job Posted\nSuccessfully!",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
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
                                                    Get.to(bottom_bar(
                                                      currentIndex: 0,
                                                    ));
                                                    // Get.back();
                                                  },
                                                  child: mainButton(
                                                      "Go Back To Home",
                                                      Color(0xff2B65EC),
                                                      context)),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            top: -48,
                                            child: Container(
                                              width: width,
                                              //106,
                                              height: height * 0.13,
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
                                );
                              } else {
                                toastSuccessMessage(
                                    "${createJobWallet.message.toString()}",
                                    Colors.red);
                              }
                            } else {
                              await createJobByWallet();
                              if (createJobWallet.status == "success") {
                                toastSuccessMessage(
                                    "Job Created Successfully", Colors.green);

                                showDialog(
                                  context: context,
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
                                          width: width * 0.9, //350,
                                          height: height * 0.3, // 321,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: Get.height * 0.05,
                                              ),
                                              const Text(
                                                "Job Posted\nSuccessfully!",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
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
                                                    Get.to(bottom_bar(
                                                      currentIndex: 0,
                                                    ));
                                                    // Get.back();
                                                  },
                                                  child: mainButton(
                                                      "Go Back To Home",
                                                      Color(0xff2B65EC),
                                                      context)),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            top: -48,
                                            child: Container(
                                              width: width,
                                              //106,
                                              height: height * 0.13,
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
                                );
                              } else {
                                toastSuccessMessage(
                                    "${createJobWallet.message.toString()}",
                                    Colors.red);
                              }
                            }
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectPaymentMethod(
                                  img: img,
                                  discountApplicable: discountApplicable,
                                  randomNumbers: randomNumbers,
                                  jobName: jobName,
                                  finecharges: finecharges.toString(),
                                  date: date,
                                  long: long,
                                  lat: lat,
                                  time: time,
                                  endtime: endtime,
                                  describe: describe,
                                  price: price,
                                  amount: amount,
                                  chargers: chargers,
                                  tax: tax,
                                  address: address,
                                  totalPrice: total,
                                  wallet: wallet,
                                  taxAmount: taxAmount,
                                  serviceChargesAmount: serviceChargesAmount,
                                  finalPrice: finalPrice,
                                  discountedPrice: discountedPrice,
                                ),
                              ),
                            );
                          }
                          // Navigator
                        },
                        child: isInAsyncCall
                            ? loadingBar(context)
                            : wallet != null && wallet >= double.parse(price!)
                                ? mainButton("Pay", Color(0xff2B65EC), context)
                                : mainButton("Select Payment Method",
                                    Color(0xff2B65EC), context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
