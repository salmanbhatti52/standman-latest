import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:StandMan/Models/completeJobModels.dart';
import 'package:StandMan/Models/customerCompleteJobModels.dart';
import 'package:StandMan/Models/fineJobCustomerModel.dart';
import 'package:StandMan/Pages/Customer/JobsPage/CustomerJobProfile/CustomerJobProfile.dart';
import 'package:StandMan/Pages/Customer/MessagePage/customerInbox.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/chat_start_user_Model.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/MyButton.dart';
import '../../../../widgets/ToastMessage.dart';
import '../../../../widgets/TopBar.dart';
import '../../../Employee/HomePage/EmpHomePage.dart';
import '../../HomePage/HomePage.dart';
import '../../MessagePage/MessageDetails.dart';
import '../Customer_QR_Scanner/QRCodeScanner.dart';
import 'package:http/http.dart' as http;
import '../CustomerRatingSection/CustomerRatingSection.dart';
import '../Payment_Sheet/Customer_Payment_Sheet.dart';
import 'qrPageCustomerCompleteJob.dart';

class Customer_JobsDetails_Completed_with_QR extends StatefulWidget {
  String? image;
  String? jobName;
  String? totalPrice;
  String? address;
  String? completeJobTime;
  String? description;
  String? profilePic;
  String? employee_profilePic;
  String? name;
  String? employee_name;
  String? status;
  String? customerId;
  String? employeeId;
  String? jobId;
  String? oneSignalId;
  String? rating;
  String? fine;
  int? differenceInMinutes;
  String? jobRequestId;

  Customer_JobsDetails_Completed_with_QR(
      {Key? key,
      this.image,
      this.differenceInMinutes,
      this.jobRequestId,
      this.fine,
      this.oneSignalId,
      this.jobName,
      this.totalPrice,
      this.address,
      this.jobId,
      this.employeeId,
      this.completeJobTime,
      this.employee_name,
      this.employee_profilePic,
      this.description,
      this.customerId,
      this.profilePic,
      this.name,
      this.rating,
      this.status})
      : super(key: key);

  @override
  State<Customer_JobsDetails_Completed_with_QR> createState() =>
      _Customer_JobsDetails_Completed_with_QRState();
}

class _Customer_JobsDetails_Completed_with_QRState
    extends State<Customer_JobsDetails_Completed_with_QR> {
  ChatStartUserModel chatStartUserModel = ChatStartUserModel();

  bool progress = false;
  bool isInAsyncCall = false;
  var getResult = 'QR Code Result';

  chatStartUser() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");
    print("empUsersCustomersId = $empUsersCustomersId");
    print(" usersCustomersId Iddddddddddd ${widget.customerId}");
    print(" EmployeeIdddddddddddddd ${widget.employeeId}");

    // try {
    String apiUrl = userChatApiUrl;
    print("userChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "requestType": "startChat",
        "users_customers_type": "Customer",
        "users_customers_id": widget.customerId,
        "other_users_customers_id": widget.employeeId,
      },
      headers: {'Accept': 'application/json'},
    );
    print('${response.statusCode}');
    print(response);
    print("responseStartChat: $response");
    print("status Code chat: ${response.statusCode}");
    print("in 200 chat");
    if (response.statusCode == 200) {
      final responseString = response.body;
      print("userChatResponse: ${responseString.toString()}");
      chatStartUserModel = chatStartUserModelFromJson(responseString);
      setState(() {});
    }
  }

  String? neededValue;
  FineJobModel fineJobModel = FineJobModel();
  fineJob() async {
    List<String> parts =
        widget.fine!.split(' '); // Split the string on space characters
    neededValue = parts[1]; // Get the second part
    print("neededValue ${neededValue}");
    // try {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse(
        'https://admin.standman.ca/api/complete_job_with_fine_customer');

    var body = {
      "jobs_id": "${widget.jobId}",
      "jobs_requests_id": "${widget.jobRequestId}",
      "jobs_fines": {
        "time": "${widget.differenceInMinutes}",
        "price": "${widget.fine}"
      }
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      fineJobModel = fineJobModelFromJson(resBody);
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${widget.fine}");
    if (widget.differenceInMinutes! > 15) {
      fineJob();
    }
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
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
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
                              "Job Taken by",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                GestureDetector(
                                  onTap: () {
                                    print("Heloooooooooooooooooooooooo");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Customer_Profile(
                                          customerId:
                                              widget.customerId.toString(),
                                          employeeId:
                                              widget.employeeId.toString(),
                                          rating: "${widget.rating.toString()}",
                                          profilePic: "${widget.profilePic}",
                                          name: "${widget.name}",
                                        ), // Replace SecondScreen() with your intended replacement screen
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                        ),
                                        widget.rating != null
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xffFFDF00),
                                                    size: 15,
                                                  ),
                                                  Text(
                                                    "${widget.rating}",
                                                    style: TextStyle(
                                                      color: Color(0xff000000),
                                                      fontFamily: "Outfit",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      // letterSpacing: -0.3,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  "No Ratings Yet",
                                                  style: TextStyle(
                                                    color: Color(0xff000000),
                                                    fontFamily: "Outfit",
                                                    fontSize: 6,

                                                    // letterSpacing: -0.3,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await chatStartUser();

                                  if (chatStartUserModel.status == "success") {
                                    print("${widget.customerId}");
                                    print("${widget.employeeId}");
                                    print("${widget.profilePic}");
                                    print("${widget.name}");

                                    Get.to(
                                      () => CustomerInbox(
                                        userId: widget.customerId,
                                        rId: widget.employeeId,
                                        profilepic: widget.profilePic,
                                        fullname: widget.name,
                                      ),
                                    );
                                  } else if (chatStartUserModel.message ==
                                      "Chat is already started.") {
                                    Get.to(
                                      () => CustomerInbox(
                                        userId: widget.customerId,
                                        rId: widget.employeeId,
                                        profilepic:
                                            widget.profilePic.toString(),
                                        fullname: widget.name.toString(),
                                      ),
                                    );
                                    //toast Message
                                  } else {
                                    toastSuccessMessage(
                                        "${chatStartUserModel.message}",
                                        Colors.red);
                                  }
                                },
                                child: smallButton(
                                    "Chat", Color(0xff2B65EC), context)),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        GestureDetector(
                            onTap: () async {
                              // DateTime buttonClickTime = DateTime.now();
                              Get.to(() => CustomerWithoutExtraTime(
                                    employeeId: widget.employeeId,
                                    customerId: widget.customerId,
                                    completeJobTime: widget.completeJobTime,
                                    description: widget.description,
                                    jobId: widget.jobId,
                                    address: widget.address,
                                    totalPrice: widget.totalPrice,
                                    jobName: widget.jobName,
                                    jobRequestId: widget.jobRequestId,
                                  ));

                              // String? formattedTime = DateFormat('HH:mm').format(buttonClickTime); // Format the time
                              // print("buttonClickTime ${formattedTime}");
                              //  // scanQRCode();
                              // // await makePayment();
                              // // Navigator.push(
                              // //   context,
                              // //   MaterialPageRoute(builder: (context) => QRScannerPage()),
                              // // );
                              //  Get.to(
                              //
                              //      CustomerQRCodeScanner(
                              //    customerId: widget.customerId,
                              //    employeeId: widget.employeeId,
                              //    jobId: "${widget.jobId}",
                              //    jobName: widget.jobName,
                              //    buttonClickTime: "${formattedTime}",
                              //  ),
                              // Payment(
                              //   ctx: context
                              // ),
                              // );
                              // Future.delayed(const Duration(seconds: 3), () {
                              //   if(getResult == "${widget.employeeId}${widget.jobId}${widget.jobName}"){
                              //     toastSuccessMessage("Success scan QR Code.", Colors.red);
                              //     Payment(ctx: context);
                              //   } else {
                              //     toastFailedMessage("Failed to scan QR Code.", Colors.red);
                              //   }
                              // });
                            },
                            child: progress
                                ? loadingBar(context)
                                : mainButton("Complete Job", Color(0xff2B65EC),
                                    context)),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 25, vertical: 20),
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height * 0.07,
                        //     // height: 48,
                        //     width: MediaQuery.of(context).size.width,
                        //     decoration: BoxDecoration(
                        //         // color: Color(0xff4DA0E6),
                        //         //   color: Colors.white,
                        //         borderRadius: BorderRadius.circular(12),
                        //         border: Border.all(
                        //             color: Color(0xffC70000), width: 1),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               spreadRadius: 0,
                        //               blurRadius: 15,
                        //               offset: Offset(1, 10),
                        //               color: Color.fromRGBO(7, 1, 87, 0.1)),
                        //         ]),
                        //     child: Center(
                        //       child: Text(
                        //         "Cancel Job",
                        //         style: TextStyle(
                        //             fontFamily: "Outfit",
                        //             fontSize: 14,
                        //             color: Color(0xffC70000),
                        //             fontWeight: FontWeight.w500),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     ),
                        //   ),
                        // )
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
}

