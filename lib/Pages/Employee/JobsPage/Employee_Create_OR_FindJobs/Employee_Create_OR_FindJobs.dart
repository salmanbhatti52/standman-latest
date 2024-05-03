import 'dart:convert';
import 'package:StandMan/Models/rejectJobsModels.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/get_jobs_employees_Model.dart';
import '../../../../Models/acceptJobsModels.dart';
import '../../../../Models/getprofile.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/MyButton.dart';
import '../../../../widgets/ToastMessage.dart';
import '../../../Customer/HomePage/HomePage.dart';
import 'package:http/http.dart' as http;
import '../../../EmpBottombar.dart';
import '../../HomePage/EmpHomePage.dart';
import '../../HomePage/EmpJobsDetails.dart';

class Emp_ceate_Or_findJobs extends StatefulWidget {
  const Emp_ceate_Or_findJobs({Key? key}) : super(key: key);

  @override
  State<Emp_ceate_Or_findJobs> createState() => _Emp_ceate_Or_findJobsState();
}

class _Emp_ceate_Or_findJobsState extends State<Emp_ceate_Or_findJobs> {
  GetJobsEmployeesModel getJobsEmployeesModel = GetJobsEmployeesModel();
  bool isLoading = false;
  bool isClicked = false;
  GetProfile getProfile = GetProfile();

  getprofile() async {
    // try {

    empPrefs = await SharedPreferences.getInstance();
    empUsersCustomersId = empPrefs!.getString('empUsersCustomersId');
    print("userId in empPrefs is = $empUsersCustomersId");

    String apiUrl = usersProfileApiUrl;
    print("getUserProfileApi: $apiUrl");

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
    }, body: {
      "users_customers_id": empUsersCustomersId.toString(),
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

  GetJobsEmployees() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("usersCustomersId = $usersCustomersId");

    // longitude = prefs!.getString('longitude1');
    // lattitude = prefs!.getString('lattitude1');
    // print("longitude1111: ${longitude}");
    // print("lattitude1111: ${lattitude}");

    String apiUrl = "https://admin.standman.ca/api/get_jobs_employee";
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
        // "employee_longitude": longitude,
        // "employee_latitude": lattitude,
      },
    );
    final responseString = response.body;
    print("getJobsEmployeesModelApiUrl: ${response.body}");
    print("status Code getJobsEmployeesModel: ${response.statusCode}");
    print("in 200 getJobsEmployees");
    if (response.statusCode == 200) {
      getJobsEmployeesModel = getJobsEmployeesModelFromJson(responseString);
      // setState(() {});
      print('getJobsEmployeesModel status: ${getJobsEmployeesModel.status}');
      print(
          'getJobsEmployeesModel Length: ${getJobsEmployeesModel.data?.length}');
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
  AcceptJobModels acceptJobModels = AcceptJobModels();

  String? jobIndex;

  JobsAccept(String? jobidindex) async {
    setState(() {
      isLoading = true;
    });
    print(" jobIndex in Accept Job ${jobidindex}");
    String apiUrl = "https://admin.standman.ca/api/accept_job";
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": jobidindex,
      },
    );
    final responseString = response.body;
    print("acceptJobModelsApiUrl: ${response.body}");
    print("status Code acceptJobModels: ${response.statusCode}");
    print("in 200 acceptJobModels");
    if (response.statusCode == 200) {
      acceptJobModels = acceptJobModelsFromJson(responseString);
      await GetJobsEmployees();
      // setState(() {});
      print('acceptJobModels status: ${acceptJobModels.status}');
      // print('acceptJobModels message: ${acceptJobModels.message}');
      setState(() {
        isLoading = false;
      });
    }
  }

  RejectJobModels rejectJobModels = RejectJobModels();

  JobsReject(String? jobidindex) async {
    setState(() {
      isLoading = true;
    });

    String apiUrl = "https://admin.standman.ca/api/mark_job_uninterested";
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": jobidindex,
      },
    );
    final responseString = response.body;
    print("rejectJobModelsApiUrl: ${response.body}");
    print("status Code rejectJobModels: ${response.statusCode}");
    print("in 200 rejectJobModels");
    if (response.statusCode == 200) {
      rejectJobModels = rejectJobModelsFromJson(responseString);
      // setState(() {});
      await GetJobsEmployees();
      print('rejectJobModels status: ${rejectJobModels.status}');
      print('rejectJobModels message: ${rejectJobModels.message}');
      setState(() {
        isLoading = false;
      });
    }
  }

  double? tryParseDouble(String? value) {
    try {
      return double.parse(value ?? '');
    } catch (_) {
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
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: Lottie.asset(
                  "assets/images/loading.json",
                  height: 50,
                ),
              )
            : getJobsEmployeesModel.data?.length == null
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
                          "No jobs available in\nyour area.",
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
                              itemCount: getJobsEmployeesModel.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                double? jobRadius =
                                    tryParseDouble(getProfile.data?.jobRadius);
                                int reversedindex =
                                    getJobsEmployeesModel.data!.length -
                                        1 -
                                        index;
                                jobIndex =
                                    "${getJobsEmployeesModel.data?[index].jobsId}";

                                List<double> distances =
                                    getJobsEmployeesModel.data != null
                                        ? getJobsEmployeesModel.data!
                                            .map((job) =>
                                                double.tryParse(
                                                    job.distance ?? '0.0') ??
                                                0.0)
                                            .toList()
                                        : [];
                                print(distances);
                                // jobIndex = "${getJobsEmployeesModel.data?[index].usersCustomersData!.fullName}";
                                print('jobIndex $jobIndex');
                                // if (jobRadius != null &&
                                //     distances.any(
                                //         (distance) => distance <= jobRadius)) {
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
                                              Get.to(() => EmpJobDetaisl(
                                                    myJobId:
                                                        "${getJobsEmployeesModel.data?[index].jobsId}",
                                                    jobStatus:
                                                        getJobsEmployeesModel
                                                            .data?[index]
                                                            .status,
                                                    image:
                                                        "$baseUrlImage${getJobsEmployeesModel.data?[index].image}",
                                                    jobName:
                                                        getJobsEmployeesModel
                                                            .data?[index].name,
                                                    totalPrice:
                                                        getJobsEmployeesModel
                                                            .data?[index].price,
                                                    address:
                                                        getJobsEmployeesModel
                                                            .data?[index]
                                                            .location,
                                                    completeJobTime:
                                                        getJobsEmployeesModel
                                                            .data?[index]
                                                            .dateAdded
                                                            .toString(),
                                                    description: getJobsEmployeesModel
                                                                .data?[index]
                                                                .specialInstructions ==
                                                            null
                                                        ? ""
                                                        : getJobsEmployeesModel
                                                            .data?[index]
                                                            .specialInstructions,
                                                    name:
                                                        "${getJobsEmployeesModel.data?[index].usersCustomers?.firstName} ${getJobsEmployeesModel.data?[index].usersCustomers?.lastName}",
                                                    profilePic:
                                                        "$baseUrlImage${getJobsEmployeesModel.data?[index].usersCustomers?.profilePic}",
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
                                                      "$baseUrlImage${getJobsEmployeesModel.data?[index].image}"),
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
                                                //   "${getJobsEmployeesModel.data?[reversedindex].name.toString()}",
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
                                                    "${getJobsEmployeesModel.data?[index].name.toString()}",
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
                                                    "${getJobsEmployeesModel.data?[index].dateAdded}",
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
                                                        "${getJobsEmployeesModel.data?[index].location} ",
                                                        // "${getJobsEmployeesModel.data?[index].longitude} ${getJobsEmployeesModel.data?[index].longitude}",
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
                                                  "\$${getJobsEmployeesModel.data?[index].price}",
                                                  // "\$22",
                                                  style: TextStyle(
                                                    color: Color(0xff2B65EC),
                                                    fontFamily: "Outfit",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),

                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        String jobidindex =
                                                            "${getJobsEmployeesModel.data?[index].jobsId}";
                                                        await JobsAccept(
                                                            jobidindex);

                                                        if (acceptJobModels
                                                                .status ==
                                                            "success") {
                                                          setState(() {
                                                            isClicked = true;
                                                          });
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 1),
                                                              () async {
                                                            toastSuccessMessage(
                                                                "${acceptJobModels.status}",
                                                                Colors.green);

                                                            Get.to(() =>
                                                                Empbottom_bar(
                                                                    currentIndex:
                                                                        0));
                                                            print(
                                                                "false: $isLoading");
                                                          });
                                                        } else {
                                                          toastFailedMessage(
                                                              acceptJobModels
                                                                  .status,
                                                              Colors.red);
                                                        }
                                                      },
                                                      child: smallButton2(
                                                          "Accept",
                                                          Color(0xff2B65EC),
                                                          context),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.02,
                                                    ),
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            String jobidindex =
                                                                "${getJobsEmployeesModel.data?[index].jobsId}";
                                                            await JobsReject(
                                                                jobidindex);

                                                            if (rejectJobModels
                                                                    .message ==
                                                                "Job Incurious successfully.") {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () {
                                                                toastSuccessMessage(
                                                                    "${rejectJobModels.message}",
                                                                    Colors
                                                                        .green);
                                                                Get.to(
                                                                  () =>
                                                                      Empbottom_bar(
                                                                    currentIndex:
                                                                        0,
                                                                  ),
                                                                );
                                                                print(
                                                                    "false: $isLoading");
                                                              });
                                                            } else if (rejectJobModels
                                                                    .status !=
                                                                "success") {
                                                              toastFailedMessage(
                                                                  rejectJobModels
                                                                      .message,
                                                                  Colors.red);
                                                              Get.to(
                                                                () =>
                                                                    Empbottom_bar(
                                                                  currentIndex:
                                                                      0,
                                                                ),
                                                              );
                                                            } else {
                                                              toastFailedMessage(
                                                                  "Job is already assigned to you.",
                                                                  Colors.red);
                                                              Get.to(() =>
                                                                  Empbottom_bar(
                                                                    currentIndex:
                                                                        0,
                                                                  ));
                                                            }
                                                          },
                                                          child: smallButton2(
                                                              "Incurious",
                                                              Color(0xffC70000),
                                                              context),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                // } else {
                                //   return Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       SizedBox(
                                //         height: height * 0.02,
                                //       ),
                                //       Padding(
                                //         padding:
                                //             const EdgeInsets.only(left: 10.0),
                                //         child: const Text(
                                //           "No jobs available in\nyour area.",
                                //           style: TextStyle(
                                //             color: Colors.black,
                                //             fontFamily: "Outfit",
                                //             fontWeight: FontWeight.w500,
                                //             fontSize: 32,
                                //           ),
                                //           textAlign: TextAlign.left,
                                //         ),
                                //       ),
                                //       SizedBox(
                                //         height: height * 0.08,
                                //       ),
                                //       SvgPicture.asset(
                                //         'assets/images/cartoon.svg',
                                //       ),
                                //     ],
                                //   );
                                // }
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
}
