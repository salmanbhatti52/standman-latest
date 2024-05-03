import 'dart:convert';

import 'package:StandMan/Pages/Employee/JobsPage/Emp_Search_Jobs.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Models/Get_Previous_Jobs_Employee_Model.dart';
import '../../../../Utils/api_urls.dart';
import '../../../Customer/HomePage/HomePage.dart';
import '../Emp_Complete_Job/EMp_Job_Complete.dart';
import 'package:http/http.dart' as http;

class EmpPreviousJobList extends StatefulWidget {
  @override
  _EmpPreviousJobListState createState() => _EmpPreviousJobListState();
}

class _EmpPreviousJobListState extends State<EmpPreviousJobList> {
  GetPreviousJobsEmployeeModel getPreviousJobsEmployeeModel =
      GetPreviousJobsEmployeeModel();

  bool loading = false;

  GetPreviousJobsEmployees() async {
    setState(() {
      loading = true;
    });
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    // longitude = prefs!.getString('longitude1');
    // lattitude = prefs!.getString('lattitude1');
    print("usersCustomersId = $usersCustomersId");
    // print("longitude1111: ${longitude}");
    // print("lattitude1111: ${lattitude}");

    String apiUrl = getPreviousJobsEmployeeModelApiUrl;
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
      },
    );
    final responseString = response.body;
    print("getPreviousJobsEmployeeModelApiUrl: ${response.body}");
    print("status Code getPreviousJobsEmployeeModel: ${response.statusCode}");
    print("in 200 getPreviousJobsEmployee");
    if (response.statusCode == 200) {
      getPreviousJobsEmployeeModel =
          getPreviousJobsEmployeeModelFromJson(responseString);
      // setState(() {});
      print(
          'getPreviousJobsEmployeeModel status: ${getPreviousJobsEmployeeModel.status}');
      setState(() {
        loading = false;
      });

      print(
          'getPreviousJobsEmployeeModel Length: ${getPreviousJobsEmployeeModel.data?.length}');
      // print('getJobsModelImage: $baseUrlImage${getJobsModel.data![0].image}');
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   GetPreviousJobsEmployees();
  // }

  bool IsLoading = false;
  // List previousData = [];

  // getEmployeePreviousJobs() async {
  //   setState(() {
  //     IsLoading = true;
  //   });
  //   prefs = await SharedPreferences.getInstance();
  //   usersCustomersId = prefs!.getString('empUsersCustomersId');
  //   longitude = prefs!.getString('longitude1');
  //   lattitude = prefs!.getString('lattitude1');
  //   print("usersCustomersId = $usersCustomersId");
  //   print("longitude1111: ${longitude}");
  //   print("lattitude1111: ${lattitude}");
  //   // await Future.delayed(Duration(seconds: 2));
  //   http.Response response = await http.post(
  //     Uri.parse(getPreviousJobsEmployeeModelApiUrl),
  //     headers: {"Accept": "application/json"},
  //     body: {
  //       "users_customers_id": usersCustomersId,
  //     },
  //   );
  //   if (mounted) {
  //     setState(() {
  //       if (response.statusCode == 200) {
  //         var jsonResponse = json.decode(response.body);

  //         if (jsonResponse['data'] != null &&
  //             jsonResponse['data'] is List<dynamic>) {
  //           previousData = jsonResponse['data'];
  //           print("CompletedJobs: $previousData");
  //           IsLoading = false;
  //         } else {
  //           // Handle the case when 'data' is null or not of type List<dynamic>
  //           print("Invalid 'data' value");
  //           IsLoading = false;
  //         }
  //       } else {
  //         print("Response Body :: ${response.body}");
  //         IsLoading = false;
  //       }
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetPreviousJobsEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.10,
        backgroundColor: Color(0xff2B65EC),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            "My Completed Jobs",
            style: TextStyle(
              color: Color(0xffffffff),
              fontFamily: "Outfit",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              // letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => EmpSearchJobs());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 0.0),
              child: SvgPicture.asset(
                'assets/images/search.svg',
              ),
            ),
          ),
        ],
      ),
      body: IsLoading
          ? Center(
              child: Lottie.asset(
                "assets/images/loading.json",
                height: 50,
              ),
            )
          : getPreviousJobsEmployeeModel.status == "error"
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "No Completed Jobs",
                      style: TextStyle(
                        color: Color(0xff2B65EC),
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: Get.height * 0.1,
                    ),
                    SvgPicture.asset(
                      'assets/images/cartoon.svg',
                    ),
                  ],
                ))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await GetPreviousJobsEmployees();
                    },
                    child: Container(
                      // color: Color(0xff9D9FAD),
                      // height: MediaQuery.of(context).size.height * 0.16,
                      width: 358,
                      // height: 150,
                      child: getPreviousJobsEmployeeModel.data != null
                          ? ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  getPreviousJobsEmployeeModel.data!.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => EMp_Job_Completed(
                                            one_signal_id:
                                                "${getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.oneSignalId}",
                                            ratings:
                                                "${getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.jobsRatings != null ? getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.jobsRatings : '--'}",
                                            myJobId:
                                                "${getPreviousJobsEmployeeModel.data![i].jobsId}",
                                            image:
                                                "$baseUrlImage${getPreviousJobsEmployeeModel.data![i].jobs.image}",
                                            jobName:
                                                "${getPreviousJobsEmployeeModel.data![i].jobs.name}",
                                            totalPrice:
                                                "${getPreviousJobsEmployeeModel.data![i].jobs.totalPrice}",
                                            address:
                                                "${getPreviousJobsEmployeeModel.data![i].jobs.location}",
                                            completeJobTime:
                                                "${getPreviousJobsEmployeeModel.data![i].dateAdded}",
                                            description:
                                                "${getPreviousJobsEmployeeModel.data![i].jobs.specialInstructions != null ? getPreviousJobsEmployeeModel.data![i].jobs.specialInstructions : ""}",
                                            name: getPreviousJobsEmployeeModel
                                                        .data![i]
                                                        .jobs
                                                        .usersCustomers
                                                        .firstName !=
                                                    null
                                                ? "${getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.firstName} ${getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.lastName}"
                                                : "${getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.firstName} ${getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.lastName}",
                                            profilePic:
                                                "$baseUrlImage${getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.profilePic != null ? getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.profilePic : getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.profilePic}",
                                            customerId:
                                                "${getPreviousJobsEmployeeModel.data![i].usersCustomers.usersCustomersId}",
                                            // employeeID: "${previousData[i]['employee_data']['users_customers_id']}",
                                            status:
                                                "${getPreviousJobsEmployeeModel.data![i].status}",
                                            employeeID:
                                                "${getPreviousJobsEmployeeModel.data![i].jobs.usersCustomers.usersCustomersId}",
                                          ));
                                    },
                                    child: Container(
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            ClipRRect(
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
                                                    "$baseUrlImage${getPreviousJobsEmployeeModel.data![i].jobs.image}"),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 0.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getPreviousJobsEmployeeModel
                                                        .data![i].jobs.name,
                                                    style: TextStyle(
                                                      color: Color(0xff000000),
                                                      fontFamily: "Outfit",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      // letterSpacing: -0.3,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 0.0),
                                                    child: Text(
                                                      getPreviousJobsEmployeeModel
                                                          .data![i]
                                                          .jobs
                                                          .dateAdded
                                                          .toString(),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff9D9FAD),
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
                                                      // Text(
                                                      //   "${getPreviousJobsEmployeeModel.data?[index].location} ",
                                                      //   style: const TextStyle(
                                                      //     color: Color(0xff9D9FAD),
                                                      //     fontFamily: "Outfit",
                                                      //     fontWeight: FontWeight.w400,
                                                      //     fontSize: 8,
                                                      //   ),
                                                      // ),
                                                      Container(
                                                        width: Get.width * 0.37,
                                                        child: AutoSizeText(
                                                          getPreviousJobsEmployeeModel
                                                              .data![i]
                                                              .jobs
                                                              .location,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff9D9FAD),
                                                            fontFamily:
                                                                "Outfit",
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          maxLines: 2,
                                                          minFontSize: 8,
                                                          maxFontSize: 8,
                                                          textAlign:
                                                              TextAlign.left,
                                                          presetFontSizes: [8],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "\$${getPreviousJobsEmployeeModel.data![i].jobs.price}",
                                                    style: TextStyle(
                                                      color: Color(0xff2B65EC),
                                                      fontFamily: "Outfit",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Container(
                                                    width: 67,
                                                    height: 19,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffE9FFE7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        getPreviousJobsEmployeeModel
                                                            .data![i].status,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff10C900),
                                                          fontFamily: "Outfit",
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          // letterSpacing: -0.3,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Center(child: Text("loading...")),
                    ),
                  ),
                ),
    );
  }
}

List EmppreviousjobstList = [
  _emppreviousjobstList("assets/images/hosp1.png", "Dr. Prem Tiwari",
      'Completed', "djf", "sad", "hjgh"),
  _emppreviousjobstList("assets/images/hosp1.png", "Dr. Prem Tiwari",
      'Completed', "djf", "sda", "dsc"),
  _emppreviousjobstList("assets/images/hosp1.png", "Dr. Prem Tiwari",
      'Completed', "djf", "sac", "cddc"),
  _emppreviousjobstList("assets/images/hosp1.png", "Dr. Prem Tiwari",
      'Completed', "djf", "sad", "dc"),
  _emppreviousjobstList("assets/images/hosp1.png", "Dr. Prem Tiwari",
      'Cancelled', "djf", "sacc", "cdc"),
];

class _emppreviousjobstList {
  final String image;
  final String title;
  final String subTitle;
  final String image2;
  final String text;
  final String button;

  _emppreviousjobstList(this.image, this.title, this.subTitle, this.image2,
      this.text, this.button);
}
