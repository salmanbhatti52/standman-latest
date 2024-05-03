import 'dart:convert';
import 'package:StandMan/Models/createJobWallet.dart';
import 'package:StandMan/Models/editJobByWalletOrStripe.dart';
import 'package:StandMan/Models/getprofile.dart';
import 'package:StandMan/Models/jobs_create_Model.dart';
import 'package:StandMan/Pages/Bottombar.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Pages/Customer/HomePage/Paymeny_details.dart';
import 'package:StandMan/Pages/Customer/HomePage/selectPayment.dart';
import 'package:StandMan/Pages/Customer/JobsPage/Edit%20Jobs%20Section/stripePayment.dart';
import 'package:StandMan/Utils/api_urls.dart';
import 'package:StandMan/widgets/MyButton.dart';
import 'package:StandMan/widgets/ToastMessage.dart';
import 'package:StandMan/widgets/TopBar.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

ChargesSheet(
    {double? wallet,
    String? img,
    String? extraCharges,
    String? jobId,
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
    String? totalPrice,
    String? serviceCharges,
    String? amount,
    String? chargers,
    String? tax,
    String? address,
    String? total}) {
  int _selected = 0;
  bool isInAsyncCall = false;

  EditJobWalletOrStripe editJobWalletOrStripe = EditJobWalletOrStripe();

  editJobByWallet() async {
    print("working");
    String apiUrl = "https://admin.standman.ca/api/edit_job_other";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "jobs_id": "${jobId}",
        "job_date": "${date}",
        "start_time": time,
        "end_time": endtime,
        "price": "${price}",
        "service_charges": "${serviceCharges}",
        "tax": "${tax}",
        "total_price": "${totalPrice}",
        "extra_charges": "${extraCharges}",
        "requestType": "payByWallet", // "refundAmount" or "payByWallet" or ""
        "transaction_id": ""
      },
    );
    final responseString = response.body;
    print("editJobWalletOrStripe: ${response.body}");
    print("status Code jobPriceModel: ${response.statusCode}");
    print("in 200 jobPrice");
    if (response.statusCode == 200) {
      editJobWalletOrStripe = editJobWalletOrStripeFromJson(responseString);
      // setState(() {});
      print('jobsCreateModel status: ${editJobWalletOrStripe.status}');
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

  // jobCreationPayment() async {
  //   String apiUrl = jobCreationPaymentApiUrl;
  //   print("working");

  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {"Accept": "application/json"},
  //     body: {
  //       "users_customers_id": jobsCreateModel.data?.usersCustomersId.toString(),
  //       "transaction_id": randomNumbers.toString(),
  //       "jobs_id": jobsCreateModel.data?.jobsId.toString(),
  //     },
  //   );
  //   final responseString = response.body;
  //   print("jobCreationPayment: ${responseString}");
  //   if (response.statusCode == 200) {
  //     print('jobCreationPayment status: ${jobsCreateModel.status}');
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

  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     print("hello");
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization':
  //             'Bearer sk_test_51MV6RqJ1o3iGht9r8pNwA1f92pJOs9vweMCsMA6HJuTQtCiy0HTlPIAXFiI57ffEiu7EmmmfU0IHbjBGw4k5IliP0017I4MuHw',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //     // ignore: avoid_print
  //     print('Payment Intent Body->>> ${response.body.toString()}');
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     // ignore: avoid_print
  //     print('err charging user: ${err.toString()}');
  //   }
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //         context: ctx!,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) => Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(30.0),
  //           ),
  //           child: Stack(
  //             clipBehavior: Clip.none,
  //             alignment: Alignment.topCenter,
  //             children: [
  //               Container(
  //                 width: Get.width * 0.9, //350,
  //                 height: Get.height * 0.3, // 321,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     SizedBox(
  //                       height: Get.height * 0.05,
  //                     ),
  //                     const Text(
  //                       "Job Posted\nSuccessfully!",
  //                       style: TextStyle(
  //                         color: Color.fromRGBO(0, 0, 0, 1),
  //                         fontFamily: "Outfit",
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w500,
  //                         // letterSpacing: -0.3,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                     SizedBox(
  //                       height: Get.height * 0.04,
  //                     ),
  //                     GestureDetector(
  //                         onTap: () {
  //                           Get.to(() => bottom_bar(
  //                                 currentIndex: 0,
  //                               ));
  //                           // Get.back();
  //                         },
  //                         child: mainButton(
  //                             "Go Back To Home", Color(0xff2B65EC), context)),
  //                   ],
  //                 ),
  //               ),
  //               Positioned(
  //                   top: -48,
  //                   child: Container(
  //                     width: Get.width,
  //                     //106,
  //                     height: Get.height * 0.13,
  //                     //106,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: Color(0xffFF9900),
  //                     ),
  //                     child: Icon(
  //                       Icons.check,
  //                       size: 40,
  //                       color: Colors.white,
  //                     ),
  //                   ))
  //             ],
  //           ),
  //         ),
  //       );
  //       // showDialog(
  //       //   context: ctx!,
  //       //   barrierDismissible: false,
  //       //   builder: (BuildContext context) => Dialog(
  //       //     shape: RoundedRectangleBorder(
  //       //       borderRadius: BorderRadius.circular(30.0),
  //       //     ),
  //       //     child: Stack(
  //       //       clipBehavior: Clip.none,
  //       //       alignment: Alignment.topCenter,
  //       //       children: [
  //       //         Container(
  //       //           width: Get.width, //350,
  //       //           height: 537,
  //       //           decoration: BoxDecoration(
  //       //             color: const Color(0xFFFFFF),
  //       //             borderRadius: BorderRadius.circular(32),
  //       //           ),
  //       //           child: Column(
  //       //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       //             crossAxisAlignment: CrossAxisAlignment.center,
  //       //             children: [
  //       //               SizedBox(
  //       //                 height: Get.height * 0.02,
  //       //               ),
  //       //               const Text(
  //       //                 "Job Completed, Amount Paid",
  //       //                 style: TextStyle(
  //       //                   color: Color.fromRGBO(0, 0, 0, 1),
  //       //                   fontFamily: "Outfit",
  //       //                   fontSize: 20,
  //       //                   fontWeight: FontWeight.w500,
  //       //                   // letterSpacing: -0.3,
  //       //                 ),
  //       //                 textAlign: TextAlign.center,
  //       //               ),
  //       //               Container(
  //       //                 width: Get.width * 0.6, //241,
  //       //                 height: Get.height * 0.095, // 70,
  //       //                 decoration: BoxDecoration(
  //       //                   borderRadius: BorderRadius.circular(12),
  //       //                   color: Color(0xffF3F3F3),
  //       //                   border:
  //       //                   Border.all(color: Color(0xffF3F3F3), width: 1),
  //       //                 ),
  //       //                 child: Column(
  //       //                   mainAxisAlignment: MainAxisAlignment.center,
  //       //                   crossAxisAlignment: CrossAxisAlignment.center,
  //       //                   children: [
  //       //                     SizedBox(
  //       //                       width: 5,
  //       //                     ),
  //       //                     Column(
  //       //                       mainAxisAlignment: MainAxisAlignment.center,
  //       //                       crossAxisAlignment: CrossAxisAlignment.center,
  //       //                       children: [
  //       //                         Row(
  //       //                           mainAxisAlignment: MainAxisAlignment.center,
  //       //                           crossAxisAlignment: CrossAxisAlignment.center,
  //       //                           children: [
  //       //                             Text(
  //       //                               '\$',
  //       //                               style: TextStyle(
  //       //                                 color: Color(0xff21335B),
  //       //                                 fontFamily: "Outfit",
  //       //                                 fontSize: 18,
  //       //                                 fontWeight: FontWeight.w400,
  //       //                                 // letterSpacing: -0.3,
  //       //                               ),
  //       //                               textAlign: TextAlign.left,
  //       //                             ),
  //       //                             Text(
  //       //                               jobsCustomersCompleteModel
  //       //                                   .data!.job!.totalPrice
  //       //                                   .toString(),
  //       //                               // ' 22.00',
  //       //                               style: TextStyle(
  //       //                                 color: Color(0xff2B65EC),
  //       //                                 fontFamily: "Outfit",
  //       //                                 fontSize: 36,
  //       //                                 fontWeight: FontWeight.w600,
  //       //                                 // letterSpacing: -0.3,
  //       //                               ),
  //       //                               textAlign: TextAlign.center,
  //       //                             ),
  //       //                           ],
  //       //                         ),
  //       //                         Text(
  //       //                           'you paid',
  //       //                           style: TextStyle(
  //       //                             color: Color(0xffA7A9B7),
  //       //                             fontFamily: "Outfit",
  //       //                             fontSize: 12,
  //       //                             fontWeight: FontWeight.w500,
  //       //                             // letterSpacing: -0.3,
  //       //                           ),
  //       //                           textAlign: TextAlign.center,
  //       //                         ),
  //       //                       ],
  //       //                     ),
  //       //                   ],
  //       //                 ),
  //       //               ),
  //       //               Padding(
  //       //                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
  //       //                 child: Row(
  //       //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       //                   children: [
  //       //                     const Text(
  //       //                       "From",
  //       //                       style: TextStyle(
  //       //                         color: Color(0xff2B65EC),
  //       //                         fontFamily: "Outfit",
  //       //                         fontSize: 14,
  //       //                         fontWeight: FontWeight.w600,
  //       //                         // letterSpacing: -0.3,
  //       //                       ),
  //       //                       textAlign: TextAlign.left,
  //       //                     ),
  //       //                     Text(
  //       //                       "${jobsCustomersCompleteModel.data!.customer!.firstName} ${jobsCustomersCompleteModel.data!.customer!.lastName}",
  //       //                       // "Beby Jovanca",
  //       //                       style: TextStyle(
  //       //                         color: Color.fromRGBO(0, 0, 0, 1),
  //       //                         fontFamily: "Outfit",
  //       //                         fontSize: 14,
  //       //                         fontWeight: FontWeight.w400,
  //       //                         // letterSpacing: -0.3,
  //       //                       ),
  //       //                       textAlign: TextAlign.right,
  //       //                     ),
  //       //                   ],
  //       //                 ),
  //       //               ),
  //       //               Divider(
  //       //                 color: Color(0xffF3F3F3),
  //       //                 height: 1,
  //       //                 indent: 40,
  //       //                 endIndent: 40,
  //       //                 thickness: 1,
  //       //               ),
  //       //               Padding(
  //       //                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
  //       //                 child: Row(
  //       //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       //                   children: [
  //       //                     const Text(
  //       //                       "To",
  //       //                       style: TextStyle(
  //       //                         color: Color(0xff2B65EC),
  //       //                         fontFamily: "Outfit",
  //       //                         fontSize: 14,
  //       //                         fontWeight: FontWeight.w600,
  //       //                         // letterSpacing: -0.3,
  //       //                       ),
  //       //                       textAlign: TextAlign.left,
  //       //                     ),
  //       //                     Text(
  //       //                       "${jobsCustomersCompleteModel.data!.employee!.firstName} ${jobsCustomersCompleteModel.data!.employee!.lastName}",
  //       //                       // "Annette Black",
  //       //                       style: TextStyle(
  //       //                         color: Color.fromRGBO(0, 0, 0, 1),
  //       //                         fontFamily: "Outfit",
  //       //                         fontSize: 14,
  //       //                         fontWeight: FontWeight.w400,
  //       //                         // letterSpacing: -0.3,
  //       //                       ),
  //       //                       textAlign: TextAlign.right,
  //       //                     ),
  //       //                   ],
  //       //                 ),
  //       //               ),
  //       //               Divider(
  //       //                 color: Color(0xffF3F3F3),
  //       //                 height: 1,
  //       //                 indent: 40,
  //       //                 endIndent: 40,
  //       //                 thickness: 1,
  //       //               ),
  //       //               Padding(
  //       //                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
  //       //                 child: Row(
  //       //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       //                   children: [
  //       //                     const Text(
  //       //                       "Date",
  //       //                       style: TextStyle(
  //       //                         color: Color(0xff2B65EC),
  //       //                         fontFamily: "Outfit",
  //       //                         fontSize: 14,
  //       //                         fontWeight: FontWeight.w600,
  //       //                         // letterSpacing: -0.3,
  //       //                       ),
  //       //                       textAlign: TextAlign.left,
  //       //                     ),
  //       //                     Column(
  //       //                       mainAxisAlignment: MainAxisAlignment.end,
  //       //                       crossAxisAlignment: CrossAxisAlignment.end,
  //       //                       children: [
  //       //                         Text(
  //       //                           "${jobsCustomersCompleteModel.data?.job?.dateAdded}",
  //       //                           // "24 Jul 2020",
  //       //                           style: TextStyle(
  //       //                             color: Color.fromRGBO(0, 0, 0, 1),
  //       //                             fontFamily: "Outfit",
  //       //                             fontSize: 14,
  //       //                             fontWeight: FontWeight.w400,
  //       //                             // letterSpacing: -0.3,
  //       //                           ),
  //       //                           textAlign: TextAlign.right,
  //       //                         ),
  //       //                         Text(
  //       //                           "${jobsCustomersCompleteModel.data?.job?.startTime}",
  //       //                           // '15:30',
  //       //                           style: TextStyle(
  //       //                             color: Color(0xffA7A9B7),
  //       //                             fontFamily: "Outfit",
  //       //                             fontSize: 14,
  //       //                             fontWeight: FontWeight.w400,
  //       //                             // letterSpacing: -0.3,
  //       //                           ),
  //       //                           textAlign: TextAlign.right,
  //       //                         ),
  //       //                       ],
  //       //                     )
  //       //                   ],
  //       //                 ),
  //       //               ),
  //       //               SizedBox(
  //       //                 height: Get.height * 0.02,
  //       //               ),
  //       //               GestureDetector(
  //       //                   onTap: () {
  //       //                     Get.to(Customer_Rating(
  //       //                       jobName:
  //       //                       "${jobsCustomersCompleteModel.data?.job?.name}",
  //       //                       totalPrice:
  //       //                       "${jobsCustomersCompleteModel.data?.job?.totalPrice}",
  //       //                       address:
  //       //                       "${jobsCustomersCompleteModel.data?.job?.location}",
  //       //                       jobId:
  //       //                       "${jobsCustomersCompleteModel.data?.job?.jobsId}",
  //       //                       completeJobTime:
  //       //                       "${jobsCustomersCompleteModel.data?.job?.dateAdded}",
  //       //                       description: "${jobsCustomersCompleteModel.data?.job?.description != null ? {jobsCustomersCompleteModel.data?.job?.description} : ""}",
  //       //                       status:
  //       //                       "${jobsCustomersCompleteModel.data?.job?.status}",
  //       //                       customerId:
  //       //                       "${jobsCustomersCompleteModel.data?.customer?.usersCustomersId}",
  //       //                       employeeId:
  //       //                       "${jobsCustomersCompleteModel.data?.employee?.usersCustomersId}",
  //       //                     ));
  //       //                   },
  //       //                   child: mainButton(
  //       //                       "Add Ratings", Color(0xff2B65EC), context)),
  //       //             ],
  //       //           ),
  //       //         ),
  //       //         Positioned(
  //       //             top: -48,
  //       //             child: Container(
  //       //               width: Get.width, //106,
  //       //               height: Get.height * 0.13, //106,
  //       //               decoration: BoxDecoration(
  //       //                 shape: BoxShape.circle,
  //       //                 color: Color(0xffFF9900),
  //       //               ),
  //       //               child: Icon(
  //       //                 Icons.check,
  //       //                 size: 40,
  //       //                 color: Colors.white,
  //       //               ),
  //       //             ))
  //       //       ],
  //       //     ),
  //       //   ),
  //       // );
  //       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       print('Error is:--->$error $stackTrace');
  //     });
  //   } on StripeException catch (e) {
  //     print('Error is:---> $e');
  //     showDialog(
  //         context: ctx!,
  //         builder: (_) => const AlertDialog(
  //               content: Text("Cancelled "),
  //             ));
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  // Future<void> makePayment() async {
  //   try {
  //     paymentIntent = await createPaymentIntent('20', 'USD');
  //     //Payment Sheet
  //     await Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: SetupPaymentSheetParameters(
  //                 paymentIntentClientSecret: paymentIntent?['client_secret'],
  //                 // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
  //                 // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
  //                 style: ThemeMode.dark,
  //                 merchantDisplayName: 'Hammad'))
  //         .then((value) {});

  //     ///now finally display payment sheeet
  //     displayPaymentSheet();
  //   } catch (e, s) {
  //     print('exception:$e$s');
  //   }
  // }

  return showFlexibleBottomSheet(
      isExpand: false,
      initHeight: 0.44,
      maxHeight: 0.44,
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
            height: height * 0.5, // 547,
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
                    Text(
                      "\$${price}",
                      // "\$22.00",
                      // "\$$price",
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
                        Text(
                          // "\$20",
                          "\$$amount",
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
                          Text(
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
                          width: Get.width * 0.28,
                        ),
                        Text(
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
                          print("users_customers_id: ${usersCustomersId}");
                          print("jobName: ${jobName}");
                          print("location: ${address}");
                          print("longitude: ${long}");
                          print("lattitude: ${lat}");
                          print("start_date: ${date}");
                          print("start_time: ${time}");
                          print("end_time: ${endtime}");
                          print("description: ${describe}");
                          print("price: ${price}");
                          print("service_charges: ${chargers}");
                          print("tax: ${tax}");
                          print("image: ${img}");
                          print("total: ${totalPrice}");
                          print("wallet: ${wallet}");

                          stateSetterObject(() {
                            isInAsyncCall = true;
                          });

                          if (wallet != null &&
                              price != null &&
                              wallet >= double.parse(price)) {
                            await editJobByWallet();
                            if (editJobWalletOrStripe.status == "success") {
                              toastSuccessMessage(
                                  "Job Updated Successfully", Colors.green);

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
                                              "Job Updated\nSuccessfully!",
                                              style: TextStyle(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
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
                                                   Get.to(() =>
                                                bottom_bar(currentIndex: 0));
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
                                  "Job Posting Failed", Colors.red);
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StripePayment(
                                  jobId: jobId,
                                  extraCharges: extraCharges,
                                  serviceCharges: serviceCharges,
                                  date: date,
                                  time: time,
                                  endtime: endtime,
                                  price: price,
                                  amount: amount,
                                  chargers: chargers,
                                  tax: tax,
                                  address: address,
                                  totalPrice: total,
                                  wallet: wallet,
                                ),
                              ),
                            );
                          }
                          // Navigator
                        },
                        child: isInAsyncCall
                            ? loadingBar(context)
                            : wallet != null &&
                                    price != null &&
                                    wallet >= double.parse(price)
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
