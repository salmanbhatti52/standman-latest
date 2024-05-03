import 'dart:convert';

import 'package:StandMan/Models/canceljobModels.dart';
import 'package:StandMan/Models/cancellationReasonModels.dart';
import 'package:StandMan/Models/chat_start_user_Model.dart';
import 'package:StandMan/Models/rejectJobsModels.dart';
import 'package:StandMan/Models/startJobsModels.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Pages/EmpBottombar.dart';
import 'package:StandMan/Pages/Employee/HomePage/EmpHomePage.dart';
import 'package:StandMan/Pages/Employee/MessagePage/employeeInBox.dart';
import 'package:StandMan/Utils/api_urls.dart';
import 'package:StandMan/widgets/MyButton.dart';
import 'package:StandMan/widgets/ToastMessage.dart';
import 'package:StandMan/widgets/TopBar.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EmployeeAcceptedJobDetails extends StatefulWidget {
  String? image;
  String? jobName;
  String? totalPrice;
  String? address;
  String? completeJobTime;
  String? description;
  String? profilePic;
  String? jobStatus;
  String? name, myJobId;
  String? customerID;
  String? time;
  String? jobsRequestsId;
  EmployeeAcceptedJobDetails(
      {Key? key,
      this.jobStatus,
      this.image,
      this.myJobId,
      this.jobName,
      this.totalPrice,
      this.address,
      this.completeJobTime,
      this.description,
      this.profilePic,
      this.customerID,
      this.time,
      this.jobsRequestsId,
      this.name})
      : super(key: key);

  @override
  State<EmployeeAcceptedJobDetails> createState() =>
      _EmployeeAcceptedJobDetailsState();
}

class _EmployeeAcceptedJobDetailsState
    extends State<EmployeeAcceptedJobDetails> {
  // UsersProfileModel usersProfileModel = UsersProfileModel();

  Future<String?> fetchSystemSettingsDescription28() async {
    final String apiUrl = 'https://admin.standman.ca/api/get_system_settings';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Find the setting with system_settings_id equal to 28
        final setting28 = data['data'].firstWhere(
            (setting) => setting['system_settings_id'] == 28,
            orElse: () => null);

        if (setting28 != null) {
          // Extract and return the description if setting 28 exists
          final String description = setting28['description'];
          return description;
        } else {
          throw Exception('System setting with ID 28 not found');
        }
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to fetch system settings');
      }
    } catch (e) {
      // Catch any exception that might occur during the process
      print('Error fetching system settings: $e');
      return null;
    }
  }

  bool isCancelButtonEnabled = false;

  Future<void> checkCancellationPermission() async {
    final description = await fetchSystemSettingsDescription28();
    if (description != null) {
      final int descriptionInMinutes = int.tryParse(description) ?? 0;

      // Assuming widget.time is the job's start time
      final jobStartTime =
          DateTime.parse(widget.time!); // Convert string to DateTime

      final currentTime = DateTime.now();
      final difference = jobStartTime.difference(currentTime).inMinutes;

      if (difference <= descriptionInMinutes) {
        // Job start time is less than or equal to the set duration, disable cancel button
        setState(() {
          isCancelButtonEnabled = false;
        });

        // Show a pop-up or display a message informing the user
        // Example:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cannot Cancel Job'),
              content: Text(
                  'The job start time is too close to allow cancellation.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Job start time is greater than the set duration, enable cancel button
        setState(() {
          isCancelButtonEnabled = true;
        });
      }
    }
  }

  bool progress = false;
  bool isInAsyncCall = false;
  ChatStartUserModel chatStartUserModel = ChatStartUserModel();

  chatStartUserEmp() async {
    prefs = await SharedPreferences.getInstance();
    // usersCustomersId = prefs!.getString('usersCustomersId');
    empUsersCustomersId = empPrefs?.getString('empUsersCustomersId');
    print("empUsersCustomersId = $empUsersCustomersId");
    print("usersCustomersId = ${widget.customerID}");

    // try {
    String apiUrl = userChatApiUrl;
    print("userChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "requestType": "startChat",
        "users_customers_type": "Employee",
        "users_customers_id": empUsersCustomersId,
        "other_users_customers_id": widget.customerID,
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
    // } catch (e) {
    //   print('Error in userChatApiUrl: ${e.toString()}');
    // }
  }
  // JobsActionEmployeesModel jobsActionEmployeesModel = JobsActionEmployeesModel();

  bool isLoading = false;
  dynamic arriveJob = [];

  arrivedJob() async {
    setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("empUsersCustomersId = $usersCustomersId");
    print("jobid = ${widget.myJobId}");

    http.Response response = await http.post(
      Uri.parse(employeeArrived),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": widget.myJobId,
      },
    );
    if (mounted) {
      setState(() {
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          arriveJob = json.decode(response.body);
          print("arriveJob: $arriveJob");
          // if (jsonResponse['status'] == 'success') {
          //   String Message = jsonResponse['message'];
          //   print("message: $Message");
          // }
          isLoading = false;
        } else {
          print("Response Body ::${response.body}");
          isLoading = false;
        }
      });
    }
  }

  StartJobJobModels startJobJobModels = StartJobJobModels();
  startJob() async {
    setState(() {
      progress = true;
    });
    print("jobIndex in start Job ${widget.myJobId}");
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    String apiUrl = "https://admin.standman.ca/api/start_job";
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": "${widget.myJobId}",
        "jobs_requests_id": "${widget.jobsRequestsId}",
      },
    );
    final responseString = response.body;
    print("startJobJobModelsApiUrl: ${response.body}");
    print("status Code startJobJobModels: ${response.statusCode}");
    print("in 200 startJobJobModels");
    if (response.statusCode == 200) {
      startJobJobModels = startJobJobModelsFromJson(responseString);
      // setState(() {});
      print('startJobJobModels status: ${startJobJobModels.status}');
      // print('startJobJobModels message: ${startJobJobModels.message}');
    }
    setState(() {
      progress = false;
    });
  }

  CancelJobModels cancelJobModels = CancelJobModels();

  CancelJob(String? selectedReason) async {
    setState(() {
      progress = true;
    });

    String apiUrl = "https://admin.standman.ca/api/cancel_job_employee";
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": "${widget.myJobId}",
        "jobs_requests_id": "${widget.jobsRequestsId}",
        "jobs_cancellations_reasons_id": "${selectedReason}",
      },
    );
    final responseString = response.body;
    print("cancelJobModelsApiUrl: ${response.body}");
    print("status Code cancelJobModels: ${response.statusCode}");
    print("in 200 cancelJobModels");
    if (response.statusCode == 200) {
      cancelJobModels = cancelJobModelsFromJson(responseString);
      Navigator.of(context).pop();
      // setState(() {});
      print('cancelJobModels status: ${cancelJobModels.status}');
      print('cancelJobModels message: ${cancelJobModels.message}');
    }
    setState(() {
      progress = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSystemSettingsDescription28();
    cancelReasons();
    // getUserProfileWidget();
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
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network("${widget.image}")),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   "${widget.jobName}",
                            //   style: TextStyle(
                            //     color: Color.fromRGBO(0, 0, 0, 1),
                            //     fontFamily: "Outfit",
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w500,
                            //     // letterSpacing: -0.3,
                            //   ),
                            //   textAlign: TextAlign.left,
                            // ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.72),
                              child: AutoSizeText(
                                "${widget.jobName}",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: "Outfit",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: -0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 15,
                              ),
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
                                  width: width * 0.8,
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
                                    fontWeight: FontWeight.w400,
                                    fontSize: 8,
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
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                // "${widget.name}",
                                "${widget.name}",
                                // "    Alex Buckmaster",
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: "Outfit",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: -0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: width * 0.22),
                            GestureDetector(
                              onTap: () async {
                                await chatStartUserEmp();
                                if (chatStartUserModel.status == "success") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EmployeeInbox(
                                        userId: empUsersCustomersId,
                                        rId: widget.customerID,
                                        profilepic: widget.profilePic,
                                        fullname: widget.name,
                                      ), // Replace SecondScreen() with your intended replacement screen
                                    ),
                                  );
                                } else if (chatStartUserModel.message ==
                                    "Chat is already started.") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EmployeeInbox(
                                        userId: empUsersCustomersId,
                                        rId: widget.customerID,
                                        profilepic: widget.profilePic,
                                        fullname: widget.name,
                                      ), // Replace SecondScreen() with your intended replacement screen
                                    ),
                                  );
                                } else {
                                  toastSuccessMessage(
                                      "${chatStartUserModel.message}",
                                      Colors.green);
                                }
                              },
                              child: smallButton(
                                  "Chat", Color(0xff2B65EC), context),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: height * 0.02,
                        ),

                        Column(children: [
                          GestureDetector(
                              onTap: () async {
                                await startJob();
                                if (startJobJobModels.status == 'success') {
                                  setState(() {
                                    isClicked = true;
                                  });
                                  Future.delayed(const Duration(seconds: 1),
                                      () async {
                                    toastSuccessMessage(
                                        "${startJobJobModels.status}",
                                        Colors.green);

                                    Get.to(
                                        () => Empbottom_bar(currentIndex: 0));
                                    print("false: $isLoading");
                                  });
                                } else {
                                  toastFailedMessage(
                                      "${startJobJobModels.message}",
                                      Colors.red);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Empbottom_bar(currentIndex: 0),
                                    ),
                                  );
                                }
                              },
                              child: mainButton(
                                  "Start", Color(0xff2B65EC), context)),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final description =
                                  await fetchSystemSettingsDescription28();

                              if (description != null) {
                                final int descriptionInMinutes =
                                    int.tryParse(description) ?? 0;

                                final jobStartTime = TimeOfDay.fromDateTime(
                                    DateFormat('HH:mm:ss').parse(widget.time!));
                                final currentTime =
                                    TimeOfDay.fromDateTime(DateTime.now());

                                final jobStartTimeDateTime = DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  jobStartTime.hour,
                                  jobStartTime.minute,
                                );

                                final difference = jobStartTimeDateTime
                                    .difference(DateTime.now())
                                    .inMinutes;

                                print(
                                    'Description In Minutes: $descriptionInMinutes');
                                print('Job Start Time: $jobStartTime');
                                print('Current Time: $currentTime');
                                print('Difference in Minutes: $difference');

                                if (difference <= descriptionInMinutes) {
                                  // Show a pop-up or a message that job cannot be canceled
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: Text('Cannot Cancel Job'),
                                        content: Text(
                                            'The job start time is too close to allow cancellation.'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              print("difference $difference");

                                              print(
                                                  "descriptionInMinutes $descriptionInMinutes");
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    isInAsyncCall = true; // Activate loader
                                  });
                                  _showCancelReasonDialog(context);

                                  setState(() {
                                    isInAsyncCall = false; // Deactivate loader
                                  });
                                }
                              } else {
                                toastFailedMessage("Time Problem", Colors.red);
                                // Handle the case where system settings description is null
                                // Show an error message or handle it accordingly
                              }
                            },
                            child: isInAsyncCall
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ) // Show loader if isInAsyncCall is true
                                : mainButton("Cancel", Colors.red,
                                    context), // Show the cancel button otherwise
                          )
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //     child: GestureDetector(
                        //   onTap: () async {
                        //     await arrivedJob();
                        //     if (arriveJob['status'] == 'success') {
                        //       toastSuccessMessage(
                        //           "Now, Your Job has been  Started",
                        //           Colors.green);
                        //       Get.to(() => Empbottom_bar(currentIndex: 0));
                        //     } else {
                        //       toastFailedMessage(
                        //           arriveJob['message'], Colors.red);
                        //       Get.to(() => Empbottom_bar(currentIndex: 0));
                        //     }
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 25, vertical: 20),
                        //     child: Container(
                        //       height: MediaQuery.of(context).size.height * 0.07,
                        //       // height: 48,
                        //       width: MediaQuery.of(context).size.width,
                        //       decoration: BoxDecoration(
                        //           color: Color(0xff2B65EC),
                        //           //   color: Colors.white,
                        //           borderRadius: BorderRadius.circular(12),
                        //           // border:
                        //           // Border.all(color: Color(0xffC70000), width: 1),
                        //           boxShadow: [
                        //             BoxShadow(
                        //                 spreadRadius: 0,
                        //                 blurRadius: 15,
                        //                 offset: Offset(1, 10),
                        //                 color: Color.fromRGBO(7, 1, 87, 0.1)),
                        //           ]),
                        //       child: Center(
                        //         child: Text(
                        //           "Arrived job location",
                        //           style: TextStyle(
                        //               fontFamily: "Outfit",
                        //               fontSize: 14,
                        //               color: Color(0xffffffff),
                        //               fontWeight: FontWeight.w500),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )),
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
      body: {"users_customers_type": "Employee"},
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
                final isSelected = index == selectedReasonIndex;
                final reason = cancellationReasonModels.data![index];
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
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () async {
                if (selectedReasonIndex != null) {
                  final selectedReason = cancellationReasonModels
                      .data![selectedReasonIndex!].reason;
                  // Execute cancel job function
                  print(selectedReason);
                  // await cancelJob();
                  await CancelJob(selectedReason);
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

  bool isClicked = false;
}
