import 'package:StandMan/Models/canceljobModels.dart';
import 'package:StandMan/Models/completeJobModels.dart';
import 'package:StandMan/Pages/Customer/MessagePage/customerInbox.dart';
import 'package:StandMan/widgets/ToastMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Models/chat_start_user_Model.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/MyButton.dart';
import '../../../../widgets/TopBar.dart';
import '../../../Customer/HomePage/HomePage.dart';
import '../../../Customer/MessagePage/MessageDetails.dart';
import '../../../EmpBottombar.dart';
import '../../HomePage/EmpHomePage.dart';
import '../../MessagePage/MessageDetails.dart';
import '../Emp_QR_Scanner/EMp_QRScanned.dart';
import 'package:http/http.dart' as http;

class EMp_Job_Completed extends StatefulWidget {
  final String? customerId;
  final String? employeeID;
  String? image;
  String? jobName;
  String? totalPrice;
  String? address;
  String? completeJobTime;
  String? description;
  String? profilePic;
  String? status;
  String? ratings;
  String? name;
  String? myJobId;
  String? one_signal_id;

  EMp_Job_Completed(
      {Key? key,
      this.customerId,
      this.image,
      this.myJobId,
      this.jobName,
      this.one_signal_id,
      this.totalPrice,
      this.ratings,
      this.employeeID,
      this.status,
      this.address,
      this.completeJobTime,
      this.description,
      this.profilePic,
      this.name})
      : super(key: key);

  @override
  State<EMp_Job_Completed> createState() => _EMp_Job_CompletedState();
}

class _EMp_Job_CompletedState extends State<EMp_Job_Completed> {
  bool progress = false;
  // bool isInAsyncCall = false;

  ChatStartUserModel chatStartUserModel = ChatStartUserModel();

  chatStartUserEmp() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("empUsersCustomersId = $usersCustomersId");
    print("customerId = ${widget.customerId}");
    print("employeeID = ${widget.employeeID}");

    // try {
    String apiUrl = userChatApiUrl;
    print("userChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "requestType": "startChat",
        "users_customers_type": "Employee",
        "users_customers_id": widget.employeeID,
        "other_users_customers_id": widget.customerId,
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
      progress = false;
      setState(() {});
    }
  }

  CancelJobModels cancelJobModels = CancelJobModels();
  cancelJob() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("empUsersCustomersId = $usersCustomersId");
    print("customerId = ${widget.customerId}");

    // try {
    String apiUrl = cancelJobAPI;
    print("cancelJobAPI: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": "${widget.myJobId}"
      },
      headers: {'Accept': 'application/json'},
    );
    print('${response.statusCode}');
    print(response);
    print("cancelJobModels response: $response");
    print("status Code chat: ${response.statusCode}");
    print("in 200 cancelJobModels");
    if (response.statusCode == 200) {
      final responseString = response.body;
      cancelJobModels = cancelJobModelsFromJson(responseString);
      print("cancelJobModels: ${responseString.toString()}");

      progress = false;
      setState(() {});
    }
  }

  CompleteJobJobModels completeJobJobModels = CompleteJobJobModels();
  completeJob() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("empUsersCustomersId = $usersCustomersId");
    print("customerId = ${widget.customerId}");

    // try {
    String apiUrl = completeJobEmployeeAPI;
    print("userChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": "${widget.myJobId}"
      },
      headers: {'Accept': 'application/json'},
    );
    print('${response.statusCode}');
    print(response);
    print("completeJobJobModels response: $response");
    print("status Code chat: ${response.statusCode}");
    print("in 200 chat");
    if (response.statusCode == 200) {
      final responseString = response.body;
      print("userChatResponse: ${responseString.toString()}");
      completeJobJobModels = completeJobJobModelsFromJson(responseString);
      progress = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("customerID ${widget.customerId}");
    print("employeeID ${widget.employeeID}");
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
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding(
              //   padding:  EdgeInsets.symmetric(vertical: height * 0.02),
              //   child: Bar(
              //     "Job Details",
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
                // height:   658,
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
                            // Image.asset("assets/images/areaa.png"),
                            Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  margin: EdgeInsets.only(top: 40, left: 2),
                                  width: 73,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE9FFE7),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${widget.status}",
                                      // "Completed",
                                      style: TextStyle(
                                        color: Color(0xff10C900),
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
                              // "Eleanor Pena",
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
                              // "\$22",
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
                                  width: width * 0.5,
                                  child: Text(
                                    "${widget.address}",
                                    // "No 15 uti street off ovie palace road effurun delta state",
                                    style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${widget.completeJobTime}",
                                  // "Complete job time 03 March - 4:40 PM",
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
                            Text(
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
                                // Image.asset("assets/images/g2.png",),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.name}",
                                        // 'Wade Warren',
                                        style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: "Outfit",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
// letterSpacing: -0.3,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.star,
//                                             color: Color(0xffFFDF00),
//                                             size: 15,
//                                           ),
//                                           Text(
//                                             "${widget.ratings == null ? 0.0 : widget.ratings}",
//                                             style: TextStyle(
//                                               color: Color(0xff000000),
//                                               fontFamily: "Outfit",
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w400,
// // letterSpacing: -0.3,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ],
//                                       )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await chatStartUserEmp();

                                  if (chatStartUserModel.status == "success") {
                                    Get.to(
                                      () => CustomerInbox(
                                        userId: widget.employeeID,
                                        rId: widget.customerId,
                                        profilepic:
                                            widget.profilePic.toString(),
                                        fullname: widget.name.toString(),
                                      ),
                                    );
                                  } else if (chatStartUserModel.message ==
                                      "Chat is already started.") {
                                    Get.to(
                                      () => CustomerInbox(
                                        userId: widget.customerId,
                                        rId: widget.employeeID,
                                        profilepic:
                                            widget.profilePic.toString(),
                                        fullname: widget.name.toString(),
                                      ),
                                    );
                                  } else {
                                    //toast Message

                                    toastSuccessMessage(
                                        "${chatStartUserModel.message}",
                                        Colors.green);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Empbottom_bar(currentIndex: 1);
                                    }));
                                  }
                                },
                                child: smallButton(
                                    "Chat", Color(0xff2B65EC), context)),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        // GestureDetector(
                        //   onTap: (){
                        //     Get.to(EMpQRScanneer());
                        //   },
                        //     child: mainButton("Complete Job ", Color(0xff2B65EC), context)),
                        // SizedBox(
                        //   height: height * 0.03,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height*0.07,
                        //     // height: 48,
                        //     width: MediaQuery.of(context).size.width,
                        //     decoration: BoxDecoration(
                        //       // color: Color(0xff4DA0E6),
                        //       //   color: Colors.white,
                        //         borderRadius: BorderRadius.circular(12),
                        //         border: Border.all(color: Color(0xffC70000), width: 1),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               spreadRadius: 0,
                        //               blurRadius: 15,
                        //               offset: Offset(1 , 10),
                        //               color: Color.fromRGBO(7, 1, 87, 0.1)
                        //           ),
                        //         ]
                        //     ),
                        //     child:  Center(
                        //       child: Text("Cancel Job",
                        //         style: TextStyle(
                        //             fontFamily: "Outfit",
                        //             fontSize: 14,
                        //             color: Color(0xffC70000),
                        //             fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                        //     ),
                        //
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
