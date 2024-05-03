import 'package:StandMan/Models/completeJobModels.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Utils/api_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/TopBar.dart';
import 'package:http/http.dart' as http;

class EMpQRScanneer extends StatefulWidget {
  final String? customerId;
  String? jobName;
  String? jobrequestId;

  String? myJobId;
  EMpQRScanneer({
    Key? key,
    this.customerId,
    this.myJobId,
    this.jobrequestId,
    this.jobName,
  }) : super(key: key);

  @override
  State<EMpQRScanneer> createState() => _EMpQRScanneerState();
}

class _EMpQRScanneerState extends State<EMpQRScanneer> {
  CompleteJobJobModels completeJobJobModels = CompleteJobJobModels();
  completeJob() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("empUsersCustomersId = $usersCustomersId");
    print("customerId = ${widget.customerId}");

    // try {
    String apiUrl = completeJobEmployeeAPI;
    print("userChatApiUrl: $apiUrl");
    print("""
    "users_customers_id": ${usersCustomersId},
        "jobs_id": "${widget.myJobId}",
        "jobs_requests_id": "${widget.jobrequestId}",

""");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": "${widget.myJobId}",
        "jobs_requests_id": "${widget.jobrequestId}",
      },
      headers: {'Accept': 'application/json'},
    );
    print('${response.statusCode}');
    print(response);
    print("completeJobJobModels response: ${response.body}");
    print("status Code chat: ${response.statusCode}");
    print("in 200 chat");
    if (response.statusCode == 200) {
      final responseString = response.body;
      print("completeJobJobModels: ${responseString.toString()}");
      completeJobJobModels = completeJobJobModelsFromJson(responseString);

      if (mounted) {
        setState(() {
          progress = false;
        });
      }
    }
  }

  bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      completeJob();
    });
    print(
        "CustomerId, jobId, jobName ${widget.customerId} ${widget.myJobId} ${widget.jobName}");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: StandManAppBar1(
        title: "Get your QR Scanned",
        bgcolor: Color(0xff2B65EC),
        titlecolor: Colors.white,
        iconcolor: Colors.white,
      ),
      backgroundColor: Color(0xff2B65EC),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding(
              //   padding:  EdgeInsets.symmetric(vertical: height * 0.02),
              //   child: Bar(
              //     "Get your QR Scanned",
              //     'assets/images/arrow-back.svg',
              //     Colors.white,
              //     Colors.white,
              //         () {
              //       Get.back();
              //     },
              //   ),
              // ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                width: width,
                height: height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: height * 0.06,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "If your job is completed, then tell your customer to scan this in order to mark the job as Completed.",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontFamily: "Outfit",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
// letterSpacing: -0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      // Image.asset("assets/images/qrcode.png"),
                      QrImageView(
                        data:
                            "${widget.customerId} ${widget.myJobId} ${widget.jobName}",
                        version: QrVersions.auto,
                        size: 300.0,
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                    ],
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
