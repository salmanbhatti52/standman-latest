import 'dart:convert';
import 'package:StandMan/Models/acceptedJobListModels.dart';
import 'package:StandMan/Models/canceljobModels.dart';
import 'package:StandMan/Models/cancellationReasonModels.dart';
import 'package:StandMan/Models/rejectJobsModels.dart';
import 'package:StandMan/Models/startJobsModels.dart';
import 'package:StandMan/Pages/Employee/JobsPage/Emp_Search_Jobs.dart';
import 'package:StandMan/Pages/Employee/JobsPage/Emp_Accepted_Jobs/employeeAcceptedJobsDetailsPage.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/get_jobs_employees_Model.dart';
import '../../../../Models/acceptJobsModels.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/MyButton.dart';
import '../../../../widgets/ToastMessage.dart';
import '../../../Customer/HomePage/HomePage.dart';
import 'package:http/http.dart' as http;
import '../../../EmpBottombar.dart';
import '../../HomePage/EmpJobsDetails.dart';

class EmployeeAcceptedJobList extends StatefulWidget {
  const EmployeeAcceptedJobList({Key? key}) : super(key: key);

  @override
  State<EmployeeAcceptedJobList> createState() =>
      _EmployeeAcceptedJobListState();
}

class _EmployeeAcceptedJobListState extends State<EmployeeAcceptedJobList> {
  AcceptedJobsList acceptedJobsList = AcceptedJobsList();
  bool isLoading = false;
  bool isClicked = false;
  String? jobsRequestsId;
  GetJobsEmployees() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    // longitude = prefs!.getString('longitude1');
    // lattitude = prefs!.getString('lattitude1');
    print("usersCustomersId = $usersCustomersId");
    // print("longitude1111: ${longitude}");
    // print("lattitude1111: ${lattitude}");

    String apiUrl = "https://admin.standman.ca/api/get_jobs_accepted_employee";
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
      },
    );
    final responseString = response.body;
    print("acceptedJobsListApiUrl: ${response.body}");
    print("status Code acceptedJobsList: ${response.statusCode}");
    print("in 200 acceptedJobsList");
    if (response.statusCode == 200) {
      acceptedJobsList = acceptedJobsListFromJson(responseString);
      // setState(() {});
      print('acceptedJobsList status: ${acceptedJobsList.status}');
      print('acceptedJobsList Length: ${acceptedJobsList.data?.length}');

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      // print('getJobsModelImage: $baseUrlImage${getJobsModel.data![0].image}');
    }
  }

  // sharedPref() async {
  //   // prefs = await SharedPreferences.getInstance();
  //   // usersCustomersId = prefs!.getString('empUsersCustomersId');
  //   GetJobsEmployees();
  // }

  String? jobIndex;
  StartJobJobModels startJobJobModels = StartJobJobModels();
  startJob() async {
    setState(() {
      progress = true;
    });
    print("jobIndex in start Job ${jobIndex}");
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    String apiUrl = "https://admin.standman.ca/api/start_job";
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": "$jobIndex",
        "jobs_requests_id": "$jobsRequestsId",
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

  bool progress = false;
  CancelJob() async {
    setState(() {
      progress = true;
    });

    String apiUrl = "https://admin.standman.ca/api/cancel_job_employee";
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {"users_customers_id": usersCustomersId, "jobs_id": "$jobIndex",
  
      
      },
    );
    final responseString = response.body;
    print("cancelJobModelsApiUrl: ${response.body}");
    print("status Code cancelJobModels: ${response.statusCode}");
    print("in 200 cancelJobModels");
    if (response.statusCode == 200) {
      cancelJobModels = cancelJobModelsFromJson(responseString);
      // setState(() {});
      print('cancelJobModels status: ${cancelJobModels.status}');
      print('cancelJobModels message: ${cancelJobModels.message}');
    }
    setState(() {
      progress = false;
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    print("users_employee_id: ${usersCustomersId}");
    super.initState();
    // sharedPref();
    GetJobsEmployees();
    fetchSystemSettingsDescription28();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        // backgroundColor: Colors.white,
        // appBar: AppBar(
        //   toolbarHeight: height * 0.10,
        //   backgroundColor: Color(0xff2B65EC),
        //   elevation: 0,
        //   centerTitle: true,
        //   title: Padding(
        //     padding: const EdgeInsets.only(top: 0.0),
        //     child: Text(
        //       "My Jobs",
        //       style: TextStyle(
        //         color: Color(0xffffffff),
        //         fontFamily: "Outfit",
        //         fontSize: 18,
        //         fontWeight: FontWeight.w500,
        //         // letterSpacing: -0.3,
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        //   actions: [
        //     GestureDetector(
        //       onTap: () {
        //         Get.to(() => EmpSearchJobs());
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.only(right: 20.0, top: 0.0),
        //         child: SvgPicture.asset(
        //           'assets/images/search.svg',
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        body: isLoading
            ? Center(
                child: Lottie.asset(
                  "assets/images/loading.json",
                  height: 50,
                ),
              )
            : acceptedJobsList.data?.length == null
                ? Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: const Text(
                          "No jobs Accepted By\nYou",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.2,
                      ),
                      SvgPicture.asset(
                        'assets/images/cartoon.svg',
                      ),
                    ],
                  )
                : Column(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          await GetJobsEmployees();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: acceptedJobsList.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                jobsRequestsId = acceptedJobsList
                                    .data![index].jobsRequestsId
                                    .toString();
                                int reversedindex =
                                    acceptedJobsList.data!.length - 1 - index;
                                jobIndex =
                                    "${acceptedJobsList.data?[index].jobsId}";
                                // jobIndex = "${getJobsEmployeesModel.data?[index].usersCustomersData!.fullName}";
                                print('jobIndex $jobIndex');
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        // color: Colors.green,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0,
                                              blurRadius: 20,
                                              offset: Offset(0, 2),
                                              color: Color.fromRGBO(
                                                  167, 169, 183, 0.1)),
                                        ]),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() =>
                                                  EmployeeAcceptedJobDetails(
                                                    myJobId:
                                                        "${acceptedJobsList.data?[reversedindex].jobsId}",
                                                    jobStatus: acceptedJobsList
                                                        .data?[reversedindex]
                                                        .status,
                                                    image:
                                                        "$baseUrlImage${acceptedJobsList.data?[reversedindex].jobs.image}",
                                                    jobName: acceptedJobsList
                                                        .data?[reversedindex]
                                                        .jobs
                                                        .name,
                                                    totalPrice: acceptedJobsList
                                                        .data?[reversedindex]
                                                        .jobs
                                                        .price,
                                                    address: acceptedJobsList
                                                        .data?[reversedindex]
                                                        .jobs
                                                        .location,
                                                    completeJobTime:
                                                        acceptedJobsList
                                                            .data?[
                                                                reversedindex]
                                                            .dateAdded
                                                            .toString(),
                                                    description: acceptedJobsList
                                                                .data?[
                                                                    reversedindex]
                                                                .jobs
                                                                .specialInstructions ==
                                                            null
                                                        ? ""
                                                        : acceptedJobsList
                                                            .data?[
                                                                reversedindex]
                                                            .jobs
                                                            .specialInstructions,
                                                    name:
                                                        "${acceptedJobsList.data?[reversedindex].jobs.usersCustomers.firstName} ${acceptedJobsList.data?[reversedindex].jobs.usersCustomers.lastName}",
                                                    profilePic:
                                                        "$baseUrlImage${acceptedJobsList.data?[reversedindex].jobs.usersCustomers.profilePic}",
                                                    customerID:
                                                        "${acceptedJobsList.data?[reversedindex].jobs.usersCustomers.usersCustomersId}",
                                                    time:
                                                        "${acceptedJobsList.data?[reversedindex].jobs.startTime}",
                                                    jobsRequestsId:
                                                        acceptedJobsList
                                                            .data![index]
                                                            .jobsRequestsId
                                                            .toString(),
                                                  ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: FadeInImage(
                                                  placeholder: AssetImage(
                                                    "assets/images/fade_in_image.jpeg",
                                                  ),
                                                  fit: BoxFit.fill,
                                                  width: 140,
                                                  height: 96,
                                                  image: NetworkImage(
                                                      "$baseUrlImage${acceptedJobsList.data?[reversedindex].jobs.image}"),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 0.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Text(
                                                //   "${getJobsEmployeesModel.data?[index].name.toString()}",
                                                //   // 'Job name comes here',
                                                //   style: TextStyle(
                                                //     color: Color(0xff000000),
                                                //     fontFamily: "Outfit",
                                                //     fontSize: 12,
                                                //     fontWeight: FontWeight.w500,
                                                //     // letterSpacing: -0.3,
                                                //   ),
                                                //   textAlign: TextAlign.left,
                                                // ),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45),
                                                  child: AutoSizeText(
                                                    "${acceptedJobsList.data?[reversedindex].jobs.name.toString()}",
                                                    style: TextStyle(
                                                      color: Color(0xff000000),
                                                      fontFamily: "Outfit",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      // letterSpacing: -0.3,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 0.0),
                                                  child: Text(
                                                    "${acceptedJobsList.data?[reversedindex].jobs.dateAdded}",
                                                    // 'Mar 03, 2023',
                                                    style: TextStyle(
                                                      color: Color(0xff9D9FAD),
                                                      fontFamily: "Outfit",
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      // letterSpacing: -0.3,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/images/locationfill.svg',
                                                    ),
                                                    Container(
                                                      width: width * 0.4,
                                                      child: AutoSizeText(
                                                        "${acceptedJobsList.data?[reversedindex].jobs.location} ",
                                                        // "${getJobsEmployeesModel.data?[reversedindex].longitude} ${getJobsEmployeesModel.data?[reversedindex].longitude}",
                                                        // "No 15 uti street off ovie palace road effurun ..",
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xff9D9FAD),
                                                          fontFamily: "Outfit",
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 8,
                                                        ),
                                                        minFontSize: 8,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "\$${acceptedJobsList.data?[reversedindex].jobs.price}",
                                                  // "\$22",
                                                  style: TextStyle(
                                                    color: Color(0xff2B65EC),
                                                    fontFamily: "Outfit",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Row(children: [
                                                  GestureDetector(
                                                      onTap: () async {
                                                        await startJob();
                                                        if (startJobJobModels
                                                                .status ==
                                                            'success') {
                                                          setState(() {
                                                            isClicked = true;
                                                          });
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 1),
                                                              () async {
                                                            toastSuccessMessage(
                                                                "${startJobJobModels.status}",
                                                                Colors.green);
                                                            await GetJobsEmployees();
                                                            Get.to(() =>
                                                                Empbottom_bar(
                                                                    currentIndex:
                                                                        0));
                                                            print(
                                                                "false: $isLoading");
                                                          });
                                                        } else {
                                                          toastFailedMessage(
                                                              "${startJobJobModels.message}",
                                                              Colors.red);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Empbottom_bar(
                                                                      currentIndex:
                                                                          0),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: smallButton2(
                                                          "Start",
                                                          Color(0xff2B65EC),
                                                          context)),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final description =
                                                          await fetchSystemSettingsDescription28();

                                                      if (description != null) {
                                                        final int
                                                            descriptionInMinutes =
                                                            int.tryParse(
                                                                    description) ??
                                                                0;

                                                        final jobStartTime = TimeOfDay
                                                            .fromDateTime(DateFormat(
                                                                    'HH:mm:ss')
                                                                .parse(acceptedJobsList
                                                                    .data![
                                                                        index]
                                                                    .jobs
                                                                    .startTime));
                                                        final currentTime =
                                                            TimeOfDay
                                                                .fromDateTime(
                                                                    DateTime
                                                                        .now());

                                                        final jobStartTimeDateTime =
                                                            DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                          jobStartTime.hour,
                                                          jobStartTime.minute,
                                                        );

                                                        final difference =
                                                            jobStartTimeDateTime
                                                                .difference(
                                                                    DateTime
                                                                        .now())
                                                                .inMinutes;
                                                        // final int
                                                        //     descriptionInMinutes =
                                                        //     int.tryParse(
                                                        //             description) ??
                                                        //         0;

                                                        // final jobStartTime =
                                                        //     DateFormat(
                                                        //             'HH:mm:ss')
                                                        //         .parse(
                                                        // acceptedJobsList
                                                        //     .data![index]
                                                        //     .jobs
                                                        //     .startTime,
                                                        // );

                                                        // final currentTime =
                                                        //     DateTime.now();
                                                        // final difference =
                                                        //     jobStartTime
                                                        //         .difference(
                                                        //             currentTime)
                                                        //         .inMinutes;

                                                        if (difference <=
                                                            descriptionInMinutes) {
                                                          showCupertinoDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CupertinoAlertDialog(
                                                                title: Text(
                                                                    'Cannot Cancel Job'),
                                                                content: Text(
                                                                    'The job start time is too close to allow cancellation.'),
                                                                actions: <Widget>[
                                                                  CupertinoDialogAction(
                                                                    onPressed:
                                                                        () {
                                                                      print(
                                                                          "difference $difference");

                                                                      print(
                                                                          "descriptionInMinutes $descriptionInMinutes");
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          // Proceed with cancellation logic
                                                          setState(() {
                                                            isClicked =
                                                                true; // Activate loader
                                                          });

                                                          await CancelJob();

                                                          setState(() {
                                                            isClicked =
                                                                false; // Deactivate loader
                                                          });

                                                          if (cancelJobModels
                                                                  .status ==
                                                              'success') {
                                                            toastSuccessMessage(
                                                                "Now, Your Job has been Cancelled",
                                                                Colors.green);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Empbottom_bar(
                                                                        currentIndex:
                                                                            0),
                                                              ),
                                                            );
                                                          } else {
                                                            toastFailedMessage(
                                                                cancelJobModels
                                                                    .message,
                                                                Colors.red);
                                                          }
                                                        }
                                                      } else {
                                                        toastFailedMessage(
                                                            "Time Problem",
                                                            Colors.red);
                                                        // Handle the case where system settings description is null
                                                        // Show an error message or handle it accordingly
                                                      }
                                                    },
                                                    child: isClicked
                                                        ? CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                          )
                                                        : smallButton2(
                                                            "Cancel",
                                                            Colors.red,
                                                            context),
                                                  ),
                                                ]),
                                                //   Row(
                                                //     children: [
                                                //       (acceptedJobsList
                                                //                   .data?[index]
                                                //                   .status ==
                                                //               "success")
                                                //           ? Padding(
                                                //               padding:
                                                //                   const EdgeInsets
                                                //                       .only(
                                                //                       left:
                                                //                           28.0),
                                                //               child:
                                                //                   GestureDetector(
                                                //                       onTap:
                                                //                           () async {
                                                //                         await arrivedJob();
                                                //                         if (arriveJob['status'] ==
                                                //                             'success') {
                                                //                           toastSuccessMessage(
                                                //                               "Now, Your Job has been  Started",
                                                //                               Colors.green);
                                                //                           Get.to(() =>
                                                //                               Empbottom_bar(currentIndex: 0));
                                                //                         } else {
                                                //                           toastFailedMessage(
                                                //                               arriveJob['message'],
                                                //                               Colors.red);
                                                //                           Get.to(() =>
                                                //                               Empbottom_bar(currentIndex: 0));
                                                //                         }
                                                //                       },
                                                //                       child: smallButton2(
                                                //                           "Arrived job location",
                                                //                           Color(
                                                //                               0xff2B65EC),
                                                //                           context)),
                                                //             )
                                                //           : GestureDetector(
                                                //               onTap: () async {
                                                //                 // await JobsActionEmployeesAccept();

                                                //                 if (acceptedJobsList
                                                //                         .status ==
                                                //                     "success") {
                                                //                   setState(() {
                                                //                     isClicked =
                                                //                         true;
                                                //                   });
                                                //                   Future.delayed(
                                                //                       const Duration(
                                                //                           seconds:
                                                //                               1),
                                                //                       () {
                                                //                     toastSuccessMessage(
                                                //                         "${acceptedJobsList.status}",
                                                //                         Colors
                                                //                             .green);
                                                //                     // Get.to(
                                                //                     //   EmpJobComplete(
                                                //                     //     myJobId:
                                                //                     //         "${widget.getJobsEmployeesModel?.jobsId}",
                                                //                     //     image:
                                                //                     //         "$baseUrlImage${widget.getJobsEmployeesModel?.image}",
                                                //                     //     jobName: widget
                                                //                     //         .getJobsEmployeesModel?.name,
                                                //                     //     totalPrice: widget
                                                //                     //         .getJobsEmployeesModel?.price,
                                                //                     //     address: widget
                                                //                     //         .getJobsEmployeesModel
                                                //                     //         ?.location,
                                                //                     //     completeJobTime: widget
                                                //                     //         .getJobsEmployeesModel
                                                //                     //         ?.dateAdded
                                                //                     //         .toString(),
                                                //                     //     description: widget
                                                //                     //                 .getJobsEmployeesModel
                                                //                     //                 ?.description ==
                                                //                     //             null
                                                //                     //         ? ""
                                                //                     //         : widget.getJobsEmployeesModel
                                                //                     //             ?.description,
                                                //                     //     name:
                                                //                     //         "${widget.getJobsEmployeesModel?.usersCustomersData?.firstName} ${widget.getJobsEmployeesModel?.usersCustomersData?.lastName}",
                                                //                     //     profilePic:
                                                //                     //         "$baseUrlImage${widget.getJobsEmployeesModel?.usersCustomersData?.profilePic}",
                                                //                     //     customerId: widget
                                                //                     //         .getJobsEmployeesModel
                                                //                     //         ?.usersCustomersId
                                                //                     //         .toString(),
                                                //                     //   ),
                                                //                     // );
                                                //                     print(
                                                //                         "false: $isLoading");
                                                //                   });
                                                //                 }
                                                //                 if (acceptedJobsList.status == "This job is already assigned to you." ||
                                                //                     acceptedJobsList
                                                //                             .status ==
                                                //                         "This job is already assigned to someone else. Thank you for your interest." ||
                                                //                     acceptedJobsList
                                                //                             .status ==
                                                //                         "You have already taken action on this Job.") {
                                                //                   toastFailedMessage(
                                                //                       acceptedJobsList
                                                //                           .status,
                                                //                       Colors
                                                //                           .red);
                                                //                   Get.to(() =>
                                                //                       Empbottom_bar(
                                                //                           currentIndex:
                                                //                               0));
                                                //                 }
                                                //               },
                                                //               child: smallButton2(
                                                //                   "Accept",
                                                //                   Color(
                                                //                       0xff2B65EC),
                                                //                   context),
                                                //             ),
                                                //       SizedBox(
                                                //         width: width * 0.02,
                                                //       ),
                                                //       //   Row(
                                                //       //     children: [
                                                //       //       (getJobsEmployeesModel
                                                //       //                   .data?[
                                                //       //                       index]
                                                //       //                   .status ==
                                                //       //               "Accepted")
                                                //       //           ? SizedBox()
                                                //       //           : GestureDetector(
                                                //       //               onTap:
                                                //       //                   () async {
                                                //       //                 // await JobsActionEmployeesReject();

                                                //       //                 if (rejectJobModels
                                                //       //                         .message ==
                                                //       //                     "Job Incurious successfully.") {
                                                //       //                   Future.delayed(
                                                //       //                       const Duration(
                                                //       //                           seconds:
                                                //       //                               1),
                                                //       //                       () {
                                                //       //                     toastSuccessMessage(
                                                //       //                         "${rejectJobModels.message}",
                                                //       //                         Colors
                                                //       //                             .green);
                                                //       //                     Get.to(
                                                //       //                       () =>
                                                //       //                           Empbottom_bar(
                                                //       //                         currentIndex:
                                                //       //                             0,
                                                //       //                       ),
                                                //       //                     );
                                                //       //                     print(
                                                //       //                         "false: $isLoading");
                                                //       //                   });
                                                //       //                 }
                                                //       //                 if (rejectJobModels
                                                //       //                         .status !=
                                                //       //                     "success") {
                                                //       //                   toastFailedMessage(
                                                //       //                       rejectJobModels
                                                //       //                           .message,
                                                //       //                       Colors
                                                //       //                           .red);
                                                //       //                   Get.to(
                                                //       //                     () =>
                                                //       //                         Empbottom_bar(
                                                //       //                       currentIndex:
                                                //       //                           0,
                                                //       //                     ),
                                                //       //                   );
                                                //       //                 }
                                                //       //               },
                                                //       //               child: smallButton2(
                                                //       //                   "Incurious",
                                                //       //                   Color(
                                                //       //                       0xffC70000),
                                                //       //                   context),
                                                //       //             ),
                                                //       //     ],
                                                //       //   )
                                                //     ],
                                                //   ),
                                                // ],
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  )

        // Emp_Find_Job(),

        // Column(
        //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     SizedBox(
        //       height: height * 0.02,
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(left: 10.0),
        //       child: const Text(
        //         "No jobs available in\nyour area.",
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontFamily: "Outfit",
        //           fontWeight: FontWeight.w500,
        //           fontSize: 32,
        //         ),
        //         textAlign: TextAlign.left,
        //       ),
        //     ),
        //     SizedBox(
        //       height: height * 0.2,
        //     ),
        //     SvgPicture.asset('assets/images/cartoon.svg',),
        //   ],
        // ),
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
                  Navigator.of(context).pop();
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
}
