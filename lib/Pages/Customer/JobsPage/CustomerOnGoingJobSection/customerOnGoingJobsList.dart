import 'dart:convert';

import 'package:StandMan/Models/customerOnGoingJobsModels.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/widgets/MyButton.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Models/get_OnGoing_jobs_Model.dart';
import '../../../../Models/acceptJobsModels.dart';
import '../../../../Models/users_profilet_model.dart';
import '../../../../Utils/api_urls.dart';
import '../../HomePage/FindPlace.dart';
import '../CustomerRatingSection/CustomerAddRatingSection.dart';
import '../CustomerCompleteJobSection/customerCompleteJobDetailsSection.dart';
import 'package:http/http.dart' as http;

class CustomerOnGoingJobList extends StatefulWidget {
  @override
  _CustomerOnGoingJobListState createState() => _CustomerOnGoingJobListState();
}

class _CustomerOnGoingJobListState extends State<CustomerOnGoingJobList> {
  bool isLoading = false;

  CustomerOnGoingJobsModels customerOnGoingJobsModels =
      CustomerOnGoingJobsModels();

  CustomerOnGoingJob() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");

    // try {
    setState(() {
      progress = true;
    });
    String apiUrl = "https://admin.standman.ca/api/get_jobs_ongoing_customer";
    print("userChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": usersCustomersId,
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
      print("customerOnGoingJobsModels: ${responseString.toString()}");
      customerOnGoingJobsModels =
          customerOnGoingJobsModelsFromJson(responseString);

      if (mounted) {
        setState(() {
          progress = false;
        });
      }
    }
  }

  String? description;
  double? result;
  String? timeperiod;

  Future<String?> fetchSystemSettingsDescription28() async {
    final String apiUrl = 'https://admin.standman.ca/api/get_system_settings';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Find the setting with system_settings_id equal to 26
        final setting26 = data['data'].firstWhere(
            (setting) => setting['system_settings_id'] == 26,
            orElse: () => null);

        final setting30 = data['data'].firstWhere(
            (setting30) => setting30['system_settings_id'] == 30,
            orElse: () => null);

        if (setting26 != null && setting30 != null) {
          // Extract and return the description if setting 28 exists
          description = setting26['description'];
          timeperiod = setting30['description'];
          int intValue = int.parse(description!);
          int timefine = int.parse(timeperiod!);
          print("timefine ${timefine}");

          result = intValue / 60;
          print("result ${result}");
          return description;
        } else {
          throw Exception('System setting with ID 26 not found');
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

  double? fineAmount;
  int? differenceInMinutes;

  bool progress = false;
  @override
  void initState() {
    // TODO: implement initState
    print("users_customers_id: ${usersCustomersId}");
    super.initState();
    CustomerOnGoingJob();
    fetchSystemSettingsDescription28();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? Center(
              child: Lottie.asset(
                "assets/images/loading.json",
                height: 50,
              ),
            )
          : customerOnGoingJobsModels.data == null
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Jobs Are Not Accepted\nBy Employee,",
                      style: TextStyle(
                        color: Color(0xff2B65EC),
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    SvgPicture.asset(
                      'assets/images/cartoon.svg',
                    ),
                  ],
                ))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await CustomerOnGoingJob();
                    },
                    child: Container(
                      // color: Color(0xff9D9FAD),
                      // height: MediaQuery.of(context).size.height * 0.16,
                      width: 350,
                      // height: 150,
                      child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: customerOnGoingJobsModels.data!.length,
                          itemBuilder: (BuildContext context, int i) {
                            String startTime =
                                customerOnGoingJobsModels.data![i].startTime!;
                            String endTime =
                                customerOnGoingJobsModels.data![i].endTime!;

                            // Add a dummy date to the time string and parse as DateTime
                            DateTime bookedStartTime =
                                DateTime.parse('2023-01-01 $startTime');

                            DateTime currentTime = DateTime.now();

                            DateTime now = DateTime.now();
                            DateTime bookedEndTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                int.parse(endTime.split(':')[0]),
                                int.parse(endTime.split(':')[1]),
                                int.parse(endTime.split(':')[2]));

                            Duration elapsedDuration =
                                now.difference(bookedEndTime);
                            differenceInMinutes = elapsedDuration.inMinutes;
                            print("differenceInMinutes ${differenceInMinutes}");
                            // Check if job is overdue
                            if (description != null && timeperiod != null) {
                              if (differenceInMinutes! >
                                      int.parse(timeperiod!) &&
                                  description != null) {
                                // Implement fine calculation based on the document you provided
                                // Replace this calculation with your fine calculation logic
                                fineAmount = int.parse(description!) *
                                    result!; // Example calculation

                                // Print the calculated fine
                                print(
                                    'Fine for job ${i + 1}: \$${fineAmount!.toStringAsFixed(2)}');
                              }
                            } else {
                              fineAmount = 0;
                            }

                            return GestureDetector(
                              onTap: () {
                                print("Heloo");

                                print(
                                    "customerOnGoingJobsModels.data![i].usersCustomers!.oneSignalId: ${customerOnGoingJobsModels.data![i].usersCustomers!.oneSignalId}");
                                print(
                                    "customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.profilePic: ${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.profilePic}");
                                print(
                                    "customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.firstName: ${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.firstName}");
                                print(
                                    "customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.usersCustomersId: ${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.usersCustomersId}");
                                print(
                                    "customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.oneSignalId: ${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.oneSignalId}");
                                print(
                                    "differenceInMinutes ${differenceInMinutes}");
                                if (fineAmount != null) print(fineAmount);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Customer_JobsDetails_Completed_with_QR(
                                         
                                      fine:
                                          "${i} ${(fineAmount != null) ? fineAmount!.toStringAsFixed(2) : '0'}",
                                      oneSignalId:
                                          "${customerOnGoingJobsModels.data![i].usersCustomers!.oneSignalId}",
                                      customerId:
                                          "${customerOnGoingJobsModels.data![i].usersCustomersId}",
                                      employeeId:
                                          "${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.usersCustomersId}",
                                      employee_profilePic:
                                          "$baseUrlImage${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.profilePic}",
                                      employee_name:
                                          "${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.firstName} ${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.firstName}",
                                      image:
                                          "$baseUrlImage${customerOnGoingJobsModels.data![i].image}",
                                      jobName: customerOnGoingJobsModels
                                          .data![i].name,
                                      totalPrice: customerOnGoingJobsModels
                                          .data![i].totalPrice,
                                      address: customerOnGoingJobsModels
                                          .data![i].location,
                                      completeJobTime: customerOnGoingJobsModels
                                          .data![i].dateAdded
                                          .toString(),
                                      jobId: customerOnGoingJobsModels
                                          .data![i].jobsId
                                          .toString(),
                                      description: customerOnGoingJobsModels
                                                  .data![i]
                                                  .specialInstructions ==
                                              null
                                          ? ""
                                          : customerOnGoingJobsModels
                                              .data![i].specialInstructions,
                                      name:
                                          "${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.firstName} ${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.lastName}",
                                      profilePic:
                                          "$baseUrlImage${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.profilePic}",
                                      status: customerOnGoingJobsModels
                                          .data![i].status,
                                      rating: customerOnGoingJobsModels
                                          .data![i]
                                          .jobsRequests
                                          ?.usersCustomers!
                                          .jobsRatings,
                                      jobRequestId: customerOnGoingJobsModels
                                          .data![i].jobsRequests!.jobsRequestsId
                                          .toString(),
                                      differenceInMinutes: differenceInMinutes,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 0,
                                          blurRadius: 20,
                                          offset: Offset(0, 2),
                                          color: Color.fromRGBO(
                                              167, 169, 183, 0.1)),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: FadeInImage(
                                          placeholder: AssetImage(
                                            "assets/images/fade_in_image.jpeg",
                                          ),
                                          fit: BoxFit.fill,
                                          width: 115,
                                          height: 96,
                                          image: NetworkImage(
                                              "$baseUrlImage${customerOnGoingJobsModels.data![i].image}"),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.02,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: Get.width * 0.32,
                                            child: AutoSizeText(
                                              "${customerOnGoingJobsModels.data![i].name}",
                                              style: TextStyle(
                                                color: Color(0xff000000),
                                                fontFamily: "Outfit",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                // letterSpacing: -0.3,
                                              ),
                                              textAlign: TextAlign.left,
                                              maxLines: 1,
                                              presetFontSizes: [11],
                                              maxFontSize: 11,
                                              minFontSize: 11,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              "${customerOnGoingJobsModels.data![i].dateAdded}",
                                              style: TextStyle(
                                                color: Color(0xff9D9FAD),
                                                fontFamily: "Outfit",
                                                fontSize: 8,
                                                fontWeight: FontWeight.w500,
                                                // letterSpacing: -0.3,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Text(
                                            'Taken By',
                                            style: TextStyle(
                                              color: Color(0xff2B65EC),
                                              fontFamily: "Outfit",
                                              fontSize: 8,
                                              fontWeight: FontWeight.w400,
                                              // letterSpacing: -0.3,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage:
                                                      customerOnGoingJobsModels
                                                                  .data![i]
                                                                  .jobsRequests!
                                                                  .usersCustomers!
                                                                  .profilePic ==
                                                              null
                                                          ? Image.asset(
                                                                  "assets/images/person2.png")
                                                              .image
                                                          : NetworkImage(
                                                              "${baseUrlImage}${customerOnGoingJobsModels.data![i].jobsRequests!.usersCustomers!.profilePic}")
                                                  // NetworkImage(baseUrlImage+ getUserProfileModelObject.data!.profilePic!)

                                                  ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 65,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      // 'Wade Warren',
                                                      "${customerOnGoingJobsModels.data![i].jobsRequests?.usersCustomers?.firstName} ${customerOnGoingJobsModels.data![i].jobsRequests?.usersCustomers?.lastName}",
                                                      // "${usersProfileModel.data?.firstName} ${usersProfileModel.data?.lastName}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff000000),
                                                        fontFamily: "Outfit",
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        // letterSpacing: -0.3,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    customerOnGoingJobsModels
                                                                .data![i]
                                                                .jobsRequests
                                                                ?.usersCustomers
                                                                ?.jobsRatings !=
                                                            null
                                                        ? Row(
                                                            children: [
                                                              Image.asset(
                                                                  "assets/images/star.png"),
                                                              Text(
                                                                '${customerOnGoingJobsModels.data![i].jobsRequests?.usersCustomers?.jobsRatings ?? ""}',
                                                                // getJobsModel.data?[index].rating,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontFamily:
                                                                        "Outfit",
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400

                                                                    // letterSpacing: -0.3,
                                                                    ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ],
                                                          )
                                                        : Text(
                                                            "No Ratings Yet",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff000000),
                                                              fontFamily:
                                                                  "Outfit",
                                                              fontSize: 6,

                                                              // letterSpacing: -0.3,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 40),
                                        width: Get.width * 0.18,
                                        height: 19,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFDACC),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: Text(
                                            // customerongoingjobstList[index].subTitle,
                                            "${customerOnGoingJobsModels.data![i].status}",
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
    );
  }
}

class _customerongoingjobstList {
  final String image;
  final String title;
  final String subTitle;
  final String image2;
  final String text;
  final String button;

  _customerongoingjobstList(this.image, this.title, this.subTitle, this.image2,
      this.text, this.button);
}

//
//
//

// Column(
// children: [
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
// child: Container(
// height: MediaQuery.of(context).size.height * 0.17,
// // height: 120,
// width: double.infinity,
// child: ListView.builder(
// shrinkWrap: true,
// scrollDirection: Axis.vertical,
// itemCount: 3,
// itemBuilder: (BuildContext context, int index) {
// return Container(
// // height: MediaQuery.of(context).size.height * 0.4,
// // height: 112,
// // width: 203,
// width: MediaQuery.of(context).size.width * 0.56,
// decoration: BoxDecoration(
// // color: Colors.green,
// boxShadow: [
// BoxShadow(
// spreadRadius: 0,
// blurRadius: 20,
// offset: Offset(0 , 2),
// color: Color.fromRGBO(167, 169, 183, 0.1)
// ),
// ]
// ),
// child: Card(
// elevation: 0,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10)),
// child: Padding(
// padding: const EdgeInsets.all(10.0),
// child: Row(
// children: [
// ClipRRect(
// borderRadius: BorderRadius.circular(10.0),
// child: Image.asset("assets/images/jobarea.png", width: 96, height: 96,)),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// 'Eleanor Pena',
// style: TextStyle(
// color: Color(0xff000000),
// fontFamily: "Outfit",
// fontSize: 12,
// fontWeight: FontWeight.w500,
// // letterSpacing: -0.3,
// ),
// textAlign: TextAlign.left,
// ),
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 5.0),
// child: Text(
// 'Mar 03, 2023',
// style: TextStyle(
// color: Color(0xff9D9FAD),
// fontFamily: "Outfit",
// fontSize: 8,
// fontWeight: FontWeight.w500,
// // letterSpacing: -0.3,
// ),
// textAlign: TextAlign.left,
// ),
// ),
// Text(
// 'Taken By',
// style: TextStyle(
// color: Color(0xff2B65EC),
// fontFamily: "Outfit",
// fontSize: 8,
// fontWeight: FontWeight.w400,
// // letterSpacing: -0.3,
// ),
// textAlign: TextAlign.left,
// ),
// SizedBox(height: 8,),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Image.asset("assets/images/g1.png"),
// SizedBox(width: 5,),
// Column(
// mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// 'Wade Warren',
// style: TextStyle(
// color: Color(0xff000000),
// fontFamily: "Outfit",
// fontSize: 8,
// fontWeight: FontWeight.w500,
// // letterSpacing: -0.3,
// ),
// textAlign: TextAlign.left,
// ),
// Row(
// children: [
// Image.asset(
// "assets/images/star.png"),
// Text(
// '4.5',
// style: TextStyle(
// color: Color(0xff000000),
// fontFamily: "Outfit",
// fontSize: 8,
// fontWeight: FontWeight.w400,
// // letterSpacing: -0.3,
// ),
// textAlign: TextAlign.left,
// ),
// ],
// )
// ],
// )
// ],
// )
// ],
// ),
// ),
// ],
// ),
// ),
// ),
// );
// }),
// ),
// ),
// ],
// );
