import 'dart:convert';
import 'dart:math';

import 'package:StandMan/Models/tipModels.dart';
import 'package:StandMan/Pages/Bottombar.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../Models/add_job_rating_Model.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/MyButton.dart';
import '../../../../widgets/ToastMessage.dart';
import '../../../../widgets/TopBar.dart';
import '../CustomerJobProfile/CustomerJobProfile.dart';
import 'package:http/http.dart' as http;

class Customer_Rating extends StatefulWidget {
  String? image;
  String? jobName;
  String? jobId;
  String? totalPrice;
  String? address;
  String? completeJobTime;
  String? description;
  String? profilePic;
  String? name;
  String? status;
  String? employeeId;
  String? customerId;
  Customer_Rating({
    Key? key,
    this.image,
    this.jobId,
    this.jobName,
    this.totalPrice,
    this.address,
    this.customerId,
    this.completeJobTime,
    this.description,
    this.employeeId,
    this.profilePic,
    this.name,
    this.status,
  }) : super(key: key);

  @override
  State<Customer_Rating> createState() => _Customer_RatingState();
}

class _Customer_RatingState extends State<Customer_Rating> {
  double? _ratingValue;
  TextEditingController commentJob = TextEditingController();
  final key = GlobalKey<FormState>();
  bool isSelect = false;

  String generateRandomNumbers(int count) {
    Random random = Random();
    String numbers = '';

    for (int i = 0; i < count; i++) {
      int randomNumber =
          random.nextInt(10); // Generate random number between 0 and 9
      numbers += randomNumber.toString();
    }

    return numbers;
  }

  AddJobRatingModel addJobRatingModel = AddJobRatingModel();

  bool loading = false;
  addJobRating() async {
    setState(() {
      loading = true;
    });
    String apiUrl = addJobRatingModelApiUrl;
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": "${widget.customerId}",
        "other_users_customers_id": "${widget.employeeId}",
        "jobs_id": widget.jobId,
        "rating": _ratingValue.toString(),
        "comment": commentJob.text,
      },
    );
    final responseString = response.body;
    print("addJobRatingModelApi: ${response.body}");
    print("status Code addJobRatingModel: ${response.statusCode}");
    print("in 200 addJobRating");
    if (response.statusCode == 200) {
      addJobRatingModel = addJobRatingModelFromJson(responseString);
      // setState(() {});
      print('addJobRatingModel status: ${addJobRatingModel.status}');
      print('addJobRatingModel data: ${addJobRatingModel.data}');
      setState(() {
        loading = false;
      });
    }
    // Get.to(Customer_Profile());
  }

  String? randomNumbers;
  String selectedTip = '';
  Map<String, dynamic>? paymentIntent;
  calculateAmount(String amount) {
    amount = "$selectedTip";
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

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('$selectedTip', 'USD');
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

  bool progress = false;
  TipModel tipModel = TipModel();
  Future<void> tipPayment() async {
    String apiUrl = "https://admin.standman.ca/api/give_job_tip";
    print("working");
    setState(() {
      progress = true;
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        // "users_customers_id": jobsCreateModel.data?.usersCustomersId.toString(),
        "jobs_id": "${widget.jobId}",
        "amount": "$selectedTip",
        "transaction_id": randomNumbers.toString(),
      },
    );
    final responseString = response.body;
    print("jobCreationPayment: ${response.body}");
    print("status Code jobCreationPayment: ${response.statusCode}");
    print("in 200 jobCreationPayment");
    if (response.statusCode == 200) {
      tipModel = tipModelFromJson(responseString);
      setState(() {
        progress = false;
      });
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        await tipPayment();
        if (tipModel.status == "success") {
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
                          "Tip Paid\nSuccessfully!",
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
        
        
        } else {
          toastFailedMessage(tipModel.message, Colors.red);
        }
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("jobid : ${widget.jobId}");
    print(
      "users_customers_id: ${widget.customerId}",
    );
    print(
      "employee_users_customers_id : ${widget.employeeId}",
    );
    print(
      "rating : ${_ratingValue}",
    );
    print("jobid : ${widget.jobId}");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: StandManAppBar1(
        title: "Job Details",
        bgcolor: Color(0xff2B65EC),
        titlecolor: Colors.white,
        iconcolor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.jobName}",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: "Outfit",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          // letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "\$${widget.totalPrice}",
                        style: TextStyle(
                          color: Color(0xff2B65EC),
                          fontFamily: "Outfit",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          // letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/locationfill.svg',
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.8,
                            child: AutoSizeText(
                              "${widget.address}",
                              style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: "Outfit",
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              minFontSize: 12,
                              presetFontSizes: [12],
                              maxFontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${widget.completeJobTime}",
                            style: const TextStyle(
                              color: Color.fromRGBO(167, 169, 183, 1),
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.description}",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: "Outfit",
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            // letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 73,
                    height: 19,
                    decoration: BoxDecoration(
                      color: Color(0xffE9FFE7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "${widget.status}",
                        style: TextStyle(
                          color: Color(0xff10C900),
                          fontFamily: "Outfit",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Form(
                    key: key,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Give Ratings",
                              style: TextStyle(
                                color: Color.fromRGBO(25, 29, 49, 1),
                                fontFamily: "Outfit",
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                // letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            RatingBar(
                                initialRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemSize: 30,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                    full: const Icon(
                                      Icons.star,
                                      color: Color(0xffFFDF00),
                                    ),
                                    half: const Icon(
                                      Icons.star_half,
                                      color: Color(0xffFFDF00),
                                    ),
                                    empty: const Icon(
                                      Icons.star_outline,
                                      color: Color(0xffA7A9B7),
                                    )),
                                onRatingUpdate: (value) {
                                  setState(() {
                                    _ratingValue = value;
                                    print(_ratingValue);
                                  });
                                }),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Add Comment",
                              style: TextStyle(
                                color: Color.fromRGBO(25, 29, 49, 1),
                                fontFamily: "Outfit",
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                // letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color.fromRGBO(243, 243, 243, 1),
                                width: 1.0,
                              )),
                          height: height * 0.12, // 97,
                          child: TextField(
                            maxLines: null,
                            controller: commentJob,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color.fromRGBO(167, 169, 183, 1),
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.only(top: 5.0, left: 12),
                              hintText: "Type here....",
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(167, 169, 183, 1),
                                fontFamily: "Outfit",
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (key.currentState!.validate()) {
                        if (_ratingValue == null) {
                          toastFailedMessage('Please Add Rating', Colors.red);
                        } else if (commentJob.text.toString().isEmpty) {
                          toastFailedMessage('Please Add Comment', Colors.red);
                        } else {
                          await addJobRating();
                          randomNumbers = generateRandomNumbers(5);
                          print("randomNumbers ${randomNumbers}");
                          if (addJobRatingModel.status == "success") {
                            Future.delayed(const Duration(seconds: 1), () {
                              toastSuccessMessage(
                                  "Add Rating Successfully", Colors.green);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        height: 250,
                                        width: width,
                                        color: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Text('Do you want to give a tip?',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: "Outfit",
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: -0.3,
                                                )),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirm Tip Payment'),
                                                          content: Text(
                                                              'Are you sure you want to make a tip payment?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  Text('Yes'),
                                                              onPressed:
                                                                  () async {
                                                                selectedTip =
                                                                    '5';
                                                                // Run your function here
                                                                await makePayment();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: smallButton3(
                                                      '5',
                                                      isSelect == true
                                                          ? Colors.green
                                                          : Colors.blue,
                                                      context),
                                                ),
                                                SizedBox(width: 3),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirm Tip Payment'),
                                                          content: Text(
                                                              'Are you sure you want to make a tip payment?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  Text('Yes'),
                                                              onPressed:
                                                                  () async {
                                                                selectedTip =
                                                                    '10';
                                                                // Run your function here
                                                                await makePayment();

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: smallButton3(
                                                      '10',
                                                      isSelect == true
                                                          ? Colors.green
                                                          : Colors.blue,
                                                      context),
                                                ),
                                                SizedBox(width: 3),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirm Tip Payment'),
                                                          content: Text(
                                                              'Are you sure you want to make a tip payment?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  Text('Yes'),
                                                              onPressed:
                                                                  () async {
                                                                selectedTip =
                                                                    '15';
                                                                // Run your function here
                                                                await makePayment();

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: smallButton3(
                                                      '15',
                                                      isSelect == true
                                                          ? Colors.green
                                                          : Colors.blue,
                                                      context),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text('OR',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: "Outfit",
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: -0.3,
                                                )),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() => bottom_bar(
                                                    currentIndex: 0));
                                              },
                                              child: smallButton(
                                                  'Skip', Colors.red, context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                          } else {
                            toastFailedMessage(
                                "${addJobRatingModel.message}", Colors.red);
                          }
                        }
                      }
                    },
                    child: loading
                        ? mainButton("Submit", Colors.grey, context)
                        : mainButton(
                            "Submit", Color.fromRGBO(43, 101, 236, 1), context),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
