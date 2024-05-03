import 'package:flutter/cupertino.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/Employee_OngoingJobs_Model.dart';
import '../../../../Utils/api_urls.dart';
import '../../../Customer/HomePage/HomePage.dart';
import 'onGoingJobDetailsEmployee.dart';
import 'package:http/http.dart' as http;

class Emp_ONGoing extends StatefulWidget {
  const Emp_ONGoing({Key? key}) : super(key: key);

  @override
  State<Emp_ONGoing> createState() => _Emp_ONGoingState();
}

class _Emp_ONGoingState extends State<Emp_ONGoing> {
  EmployeeOngoingJobsModel employeeOngoingJobsModel =
      EmployeeOngoingJobsModel();

  bool loading = false;

  Future<void> getOngoingJobsEmployees() async {
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

    String apiUrl = getOngoingJobsEmployeeModelApiUrl;
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
    print("getOngoingJob Body: ${response.body}");
    print("status Code getOngoingJobsEmployeesModel: ${response.statusCode}");
    print("in 200 getOngoingJobsEmployees");
    if (response.statusCode == 200) {
      employeeOngoingJobsModel =
          employeeOngoingJobsModelFromJson(responseString);
      // setState(() {});
      print('getJobsEmployeesModel status: ${employeeOngoingJobsModel.status}');
      print(
          'getJobsEmployeesModel Length: ${employeeOngoingJobsModel.data?.length}');
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOngoingJobsEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: Lottie.asset(
                "assets/images/loading.json",
                height: 50,
              ),
            )
          : employeeOngoingJobsModel.data?.length == null
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "No Jobs",
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
              :
              // Center(child: Text('No Recent Jobs'));
              RefreshIndicator(
                  onRefresh: () async {
                    await getOngoingJobsEmployees();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // color: Color(0xffffffff),
                      // height: MediaQuery.of(context).size.height * 0.16,
                      width: 358,
                      // height: 150,
                      child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: employeeOngoingJobsModel.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => OnGoingJobDetailsEmployee(
                                      one_signal_id:
                                          "${employeeOngoingJobsModel.data?[index].usersCustomers?.oneSignalId}",
                                      myJobId:
                                          "${employeeOngoingJobsModel.data?[index].jobsId}",
                                      image:
                                          "$baseUrlImage${employeeOngoingJobsModel.data?[index].jobs!.image}",
                                      jobName: employeeOngoingJobsModel
                                          .data?[index].jobs!.name,
                                      totalPrice: employeeOngoingJobsModel
                                          .data?[index].jobs!.price,
                                      address: employeeOngoingJobsModel
                                          .data?[index].jobs!.location,
                                      completeJobTime: employeeOngoingJobsModel
                                          .data?[index].dateAdded
                                          .toString(),
                                      description: employeeOngoingJobsModel
                                                  .data?[index]
                                                  .jobs!
                                                  .specialInstructions ==
                                              null
                                          ? ""
                                          : employeeOngoingJobsModel
                                              .data?[index]
                                              .jobs!
                                              .specialInstructions,
                                      name:
                                          "${employeeOngoingJobsModel.data?[index].jobs!.usersCustomers?.firstName} ${employeeOngoingJobsModel.data?[index].jobs!.usersCustomers?.lastName}",
                                      profilePic:
                                          "$baseUrlImage${employeeOngoingJobsModel.data?[index].jobs!.usersCustomers?.profilePic}",
                                      customerId:
                                          "${employeeOngoingJobsModel.data?[index].usersCustomers?.usersCustomersId}",
                                      status:
                                          "${employeeOngoingJobsModel.data?[index].usersCustomers?.status}",
                                      employeeID:
                                          "${employeeOngoingJobsModel.data?[index].jobs!.usersCustomersId}",
                                      rating:
                                          "${employeeOngoingJobsModel.data?[index].usersCustomers?.jobsRatings}",
                                          jobRequestId: "${employeeOngoingJobsModel.data?[index].jobsRequestsId}",
                                    ));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                // padding: EdgeInsets.all( 10),
                                // width: MediaQuery.of(context).size.width * 0.51,
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
                                  padding: const EdgeInsets.all(9.0),
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
                                              "$baseUrlImage${employeeOngoingJobsModel.data?[index].jobs!.image}"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.45),
                                              child: AutoSizeText(
                                                "${employeeOngoingJobsModel.data?[index].jobs!.name.toString()}",
                                                style: TextStyle(
                                                  color: Color(0xff000000),
                                                  fontFamily: "Outfit",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  // letterSpacing: -0.3,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.0),
                                              child: Text(
                                                "${employeeOngoingJobsModel.data?[index].dateAdded}",
                                                // 'Mar 03, 2023',
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
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/locationfill.svg',
                                                ),
                                                Container(
                                                  width: Get.width * 0.38,
                                                  child: AutoSizeText(
                                                    "${employeeOngoingJobsModel.data?[index].jobs!.location} ",
                                                    // "${getJobsEmployeesModel.data?[index].longitude} ${getJobsEmployeesModel.data?[index].longitude}",
                                                    // "No 15 uti street off ovie palace road effurun ..",
                                                    style: const TextStyle(
                                                      color: Color(0xff9D9FAD),
                                                      fontFamily: "Outfit",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 8,
                                                    ),
                                                    maxLines: 2,
                                                    presetFontSizes: [8],
                                                    minFontSize: 8,
                                                    maxFontSize: 8,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "\$${employeeOngoingJobsModel.data?[index].jobs!.price}",
                                              // "\$22",
                                              style: TextStyle(
                                                color: Color(0xff2B65EC),
                                                fontFamily: "Outfit",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            Container(
                                              width: 67,
                                              height: 19,
                                              decoration: BoxDecoration(
                                                color: Color(0xffFFDACC),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${employeeOngoingJobsModel.data?[index].status}",
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
                ),
      // EmpOnGoingJobList(),
    );
  }
}
