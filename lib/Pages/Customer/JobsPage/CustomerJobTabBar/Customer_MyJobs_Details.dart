import 'dart:convert';
import 'dart:math';

import 'package:StandMan/Models/cancelJobCustomerModel.dart';
import 'package:StandMan/Models/cancellationReasonModels.dart';
import 'package:StandMan/Pages/Bottombar.dart';
import 'package:StandMan/widgets/MyButton.dart';
import 'package:StandMan/widgets/ToastMessage.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/getprofile.dart';
import '../../../../Models/jobCreationPaymentModel.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/TopBar.dart';
import '../../HomePage/HomePage.dart';

class CustomerMyJobsDetails extends StatefulWidget {
  String? image;
  String? jobName;
  String? totalPrice;
  String? address;
  DateTime? completeJobTime;
  String? description;
  String? profilePic;
  String? name;
  String? status;
  String? employeeId;
  String? jobId;
  String? customerId;
  String? jobsRequestsId;
  String? paymentStatus;
  String? jobDiscountPrice;
  CustomerMyJobsDetails(
      {Key? key,
      this.image,
      this.jobDiscountPrice,
      this.paymentStatus,
      this.jobName,
      this.jobsRequestsId,
      this.totalPrice,
      this.address,
      this.completeJobTime,
      this.description,
      this.employeeId,
      this.profilePic,
      this.name,
      this.jobId,
      this.customerId,
      this.status})
      : super(key: key);

  @override
  State<CustomerMyJobsDetails> createState() => _CustomerMyJobsDetailsState();
}

class _CustomerMyJobsDetailsState extends State<CustomerMyJobsDetails> {
  CancelJobCustomerModel cancelJobCustomerModel = CancelJobCustomerModel();
  cancelJob(int selectedReason) async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse('https://admin.standman.ca/api/cancel_job_customer');
    setState(() {
      loading = true;
    });
    var body = {
      "jobs_id": "${widget.jobId}",
      "jobs_requests_id": "${widget.jobsRequestsId}",
      "users_customers_id": "${widget.employeeId}",
      "jobs_cancellations_reasons_id": "$selectedReason"
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      cancelJobCustomerModel = cancelJobCustomerModelFromJson(resBody);
      toastFailedMessage("Job Cancelled Successfully", Colors.green);
      Navigator.pop(context);

      print(resBody);
    } else if (res.statusCode != 200) {
      toastFailedMessage("Job Cancelled Failed", Colors.red);
      Navigator.pop(context);

      print(res.reasonPhrase);
    }
    setState(() {
      loading = false;
    });
  }

  double? finecharges;
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
    print("in 200 getCountrygetProfileModelsListModels");
    if (response.statusCode == 200) {
      print("SuccessFull");
      getProfile = getProfileFromJson(responseString);
      double? wallet = double.tryParse(getProfile.data!.walletAmount!);
      if (wallet != null && wallet < 0) {
        finecharges = wallet.abs();
      }
      print("finecharges $finecharges");

      print('getProfileModels status: ${getProfile.status}');
    }
  }

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

  var randomNumber;
  String generateFourDigitRandomNumber() {
    final random = Random();
    randomNumber = random.nextInt(9000) + 1000; // Ensures a range of 1000-9999
    return randomNumber.toString();
  }

  Future<void> jobCreationPayment() async {
    String apiUrl = jobCreationPaymentApiUrl;
    print("working");
    setState(() {
      isInAsyncCall1 = true;
    });

    // Check for null values and log them
    Map<String, String?> fields = {
      // "total_price": widget.totalPrice,
      "jobs_id": widget.jobId ?? "",
      "payment_status": "Paid",
      "transaction_id":
          isNumeric(randomNumber ?? "") ? randomNumber ?? "" : "0.0",
      "balance_wallet": isNumeric(finecharges?.toString() ?? "")
          ? finecharges?.toString() ?? ""
          : "0.0"
    };

    List<String> nullFields = [];
    fields.forEach((key, value) {
      if (value == null || value.isEmpty) {
        nullFields.add(key);
      }
    });

    if (nullFields.isNotEmpty) {
      print("The following fields are null or empty: $nullFields");
      setState(() {
        isInAsyncCall1 = true;
      });
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
      print("widget.finecharges ${finecharges}");
      print("widget.totalPrice ${widget.totalPrice}");

      // Use jobDiscountPrice if it's not null and is a numeric value, otherwise use totalPrice
      double numericAmount =
          widget.jobDiscountPrice != null && isNumeric(widget.jobDiscountPrice!)
              ? double.tryParse(widget.jobDiscountPrice!) ?? 0.0
              : double.tryParse(widget.totalPrice!) ?? 0.0;

      // Add finecharges if they are not null and are a numeric value
      numericAmount += finecharges != null && isNumeric(finecharges.toString())
          ? double.tryParse(finecharges.toString()) ?? 0.0
          : 0.0;

      print('Numeric amount after addition: $numericAmount');
      int amountInCents = (numericAmount * 100).toInt();
      if (amountInCents < 1) {
        print('Error: Amount must be at least 1 cent.');
        return "0"; // You can handle this error case as needed.
      }
      print("Amount in cents: $amountInCents");
      return amountInCents.toString();
    } catch (e) {
      // Handle the case where parsing the numeric amount fails
      print('Error parsing the numeric amount: $e');
      return "0"; // Return a default value or handle it based on your application's logic.
    }
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
  var price1;
  Future<void> makePayment() async {
    if (widget.jobDiscountPrice == null) {
      price1 = widget.totalPrice;
    } else {
      price1 = widget.jobDiscountPrice;
    }
    try {
      paymentIntent = await createPaymentIntent('${price1}', 'USD');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cancelReasons();
    print("widget.totall ${widget.totalPrice}");
    getprofile();
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
      backgroundColor: Color(0xff2B65EC),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                width: width,
                height: height * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: height * 0.03,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network("${widget.image}")),
                            Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  margin: EdgeInsets.only(top: 40, left: 2),
                                  width: 73,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFDACC),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${widget.status}",
                                      style: TextStyle(
                                        color: Color(0xffFF4700),
                                        fontFamily: "Outfit",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
// letterSpacing: -0.3,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
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
                              width: 20,
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
                                  DateFormat('EEE, MMM d, ' 'yy')
                                      .format(widget.completeJobTime!),
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
                                // "Donec dictum tristique porta. Etiam convallis lorem lobortis nulla molestie, nec tincidunt ex ullamcorper. Quisque ultrices lobortis elit sed euismod. Duis in ultrices dolor, ac rhoncus odio. Suspendisse tempor sollicitudin dui sed lacinia. Nulla quis enim posuere, congue libero quis, commodo purus. Cras iaculis massa ut elit.",
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
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Job Posted by",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: "Outfit",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                // letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.network(
                                        "${widget.profilePic}",
                                        fit: BoxFit.fill,
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${widget.name}",
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontFamily: "Outfit",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
// letterSpacing: -0.3,
                                  ),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        widget.paymentStatus == "Unpaid"
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isInAsyncCall1 = true;
                                      });
                                      await makePayment();
                                    },
                                    child: isInAsyncCall1
                                        ? loadingBar(context)
                                        : mainButton("Pay Now",
                                            Color(0xff2B65EC), context)),
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: GestureDetector(
                              onTap: () async {
                                if (widget.jobsRequestsId == "null") {
                                  toastSuccessMessage(
                                      "You Can't Cancel this job. Until Accepted",
                                      Colors.red);
                                } else if (widget.jobsRequestsId == null) {
                                  toastSuccessMessage(
                                      "You Can't Cancel this job. Until Accepted",
                                      Colors.red);
                                } else if (widget.jobsRequestsId != null) {
                                  _showCancelReasonDialog(context);
                                }

                                // await cancelJob();
                              },
                              child: isInAsyncCall
                                  ? loadingBar(context)
                                  : mainButton(
                                      "Cancel Job", Colors.red, context)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool loading = false;
  CancellationReasonModels cancellationReasonModels =
      CancellationReasonModels();

  cancelReasons() async {
    print("working");
    setState(() {
      loading = true;
    });
    String apiUrl =
        "https://admin.standman.ca/api/get_jobs_cancellations_reasons";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {"users_customers_type": "Customer"},
    );
    final responseString = response.body;
    print("CancellationReason: ${response.body}");
    print("status Code CancellationReason: ${response.statusCode}");
    print("in 200 CancellationReason");
    if (response.statusCode == 200) {
      cancellationReasonModels =
          cancellationReasonModelsFromJson(responseString);
      setState(() {
        loading = false;
      });
      print('CancellationReason status: ${cancellationReasonModels.status}');
      print('CancellationReason status: ${cancellationReasonModels}');
    }
  }

  String? selectedReason; // To store the selected reason

// Function to show the dialog box
  void _showCancelReasonDialog(BuildContext context) {
    int? selectedReasonIndex; // Track the selected reason index

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Please Select the Reason',
            style: TextStyle(
              color: CupertinoColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Container(
            height: 100, // Adjust the height as needed
            child: CupertinoPicker.builder(
              itemExtent: 40,
              onSelectedItemChanged: (int index) {
                selectedReasonIndex = index;
              },
              childCount: cancellationReasonModels.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Datum reason = cancellationReasonModels.data![index];
                final isSelected = index == selectedReasonIndex;
                return Container(
                  color: isSelected ? Colors.blue.withOpacity(0.3) : null,
                  child: Center(
                    child: Text(
                      reason.reason ?? "",
                      style: TextStyle(
                        fontSize: 17,
                        color: isSelected ? Colors.blue : CupertinoColors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                print("widget.jobsRequestsId : ${widget.jobsRequestsId}");
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () async {
                if (selectedReasonIndex != null) {
                  final selectedReason = cancellationReasonModels
                      .data![selectedReasonIndex!].jobsCancellationsReasonsId;
                  // Execute cancel job function
                  print(selectedReason);
                  await cancelJob(selectedReason!);
                  if (cancelJobCustomerModel.status == "success") {
                    toastSuccessMessage(
                        "${cancelJobCustomerModel.message}", Colors.green);
                  } else {
                    toastSuccessMessage(
                        "${cancelJobCustomerModel.message}", Colors.green);
                  }

                  // Navigator.of(context).pop();
                } else {
                  // Show error or handle empty selection
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool isInAsyncCall = false;
  bool isInAsyncCall1 = false;
}
