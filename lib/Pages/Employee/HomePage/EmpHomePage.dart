// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:StandMan/Models/acceptJobsModels.dart';
import 'package:StandMan/Models/getprofile.dart';
import 'package:StandMan/Models/rejectJobsModels.dart';
import 'package:StandMan/Pages/EmpBottombar.dart';
import 'package:StandMan/Pages/Emp_notification.dart';
import 'package:StandMan/Pages/Employee/HomePage/EmpJobsDetails.dart';
import 'package:StandMan/widgets/MyButton.dart';
import 'package:StandMan/widgets/ToastMessage.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Models/Employee_OngoingJobs_Model.dart';
import '../../../Models/get_jobs_employees_Model.dart';
import '../../../Models/users_profilet_model.dart';
import '../../../Utils/api_urls.dart';
import '../../Customer/HomePage/HeadRow.dart';
import '../../Customer/HomePage/HomePage.dart';
import '../../EmpDrawer.dart';
import 'EmpJobs.dart';
import 'package:http/http.dart' as http;
import 'EmpQueueJobs.dart';

String? empUserEmail;
String? empPassword;
String? empFullName;
String? empPhoneNumber;
String? empProfilePic1;
String? empUsersCustomersId;
SharedPreferences? empPrefs;

class EmpHomePage extends StatefulWidget {
  const EmpHomePage({Key? key}) : super(key: key);

  @override
  State<EmpHomePage> createState() => _EmpHomePageState();
}

class _EmpHomePageState extends State<EmpHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfileWidget();
    sharePref();
    getOngoingJobsEmployees();
    GetJobsEmployees();
    getprofile();
    if (!_initialized) {
      getAdminList();
      _initialized = true;
    }
  }

  List getAdmin = [];
  bool _initialized = false;

  // getAdminList() async {
  //   http.Response response = await http.get(
  //     Uri.parse(getAdminApiUrl),
  //     headers: {"Accept": "application/json"},
  //   );
  //   if (mounted) {
  //     setState(() async {
  //       if (response.statusCode == 200) {
  //         var jsonResponse = json.decode(response.body);
  //         var adminData = jsonResponse['data'][0];
  //
  //         var userImage = adminData['user_image'];
  //         var adminID = adminData['users_system_id'];
  //         var firstName = adminData['first_name'];
  //         SharedPreferences sharedPref = await SharedPreferences.getInstance();
  //         await sharedPref.setString('adminID', "$adminID");
  //         await sharedPref.setString('adminName', "$firstName");
  //         await sharedPref.setString('adminImage', "${baseUrlImage+userImage}");
  //         prefs = await SharedPreferences.getInstance();
  //         adminID = prefs!.getString('adminID');
  //         adminName = prefs!.getString('adminName');
  //         adminImage = prefs!.getString('adminImage');
  //         print("User Image: $adminImage");
  //         print("Admin ID: $adminID");
  //         print("First Name: $adminName");
  //
  //       } else {
  //         print("Response Body: ${response.body}");
  //       }
  //     });
  //   }
  // }

  getAdminList() async {
    http.Response response = await http.get(
      Uri.parse(getAdminApiUrl),
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var adminData = jsonResponse['data'][0];

      var userImage = adminData['user_image'];
      var adminID = adminData['users_system_id'];
      var firstName = adminData['first_name'];

      SharedPreferences sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString('adminID', "$adminID");
      await sharedPref.setString('adminName', "$firstName");
      await sharedPref.setString('adminImage', "${baseUrlImage + userImage}");

      setState(() {
        adminID = sharedPref.getString('adminID');
        adminName = sharedPref.getString('adminName');
        adminImage = sharedPref.getString('adminImage');
        print("User Image: $adminImage");
        print("Admin ID: $adminID");
        print("First Name: $adminName");
      });
    } else {
      print("Response Body: ${response.body}");
    }
  }

  bool isLoading = false;
  dynamic usersProfileData;

  // getUserProfileWidget() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   empPrefs = await SharedPreferences.getInstance();
  //   empUsersCustomersId = empPrefs!.getString('empUsersCustomersId');
  //   print("userId in empPrefs is = $empUsersCustomersId");
  //
  //   String apiUrl = usersProfileApiUrl;
  //   print("getUserProfileApi: $apiUrl");
  //
  //   http.Response response = await http.post(
  //     Uri.parse(apiUrl),
  //     body: {
  //       "users_customers_id": empUsersCustomersId.toString(),
  //     },
  //     headers: {
  //       'Accept': 'application/json',
  //     },
  //   );
  //
  //   if (mounted) {
  //     setState(() {
  //       if (response.statusCode == 200) {
  //         var jsonResponse = json.decode(response.body);
  //         usersProfileData = jsonResponse['data'];
  //         print("usersProfileData: $usersProfileData");
  //         print("IDDDD ${baseUrlImage+usersProfileData['profile_pic'].toString()}");
  //         isLoading = false;
  //       } else {
  //         print("Response Body: ${response.body}");
  //       }
  //     });
  //   }
  // }

  getUserProfileWidget() async {
    setState(() {
      isLoading = true;
    });

    empPrefs = await SharedPreferences.getInstance();
    empUsersCustomersId = empPrefs!.getString('empUsersCustomersId');
    print("userId in empPrefs is = $empUsersCustomersId");

    String apiUrl = usersProfileApiUrl;
    print("getUserProfileApi: $apiUrl");

    http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": empUsersCustomersId.toString(),
      },
      headers: {
        'Accept': 'application/json',
      },
    );

    if (mounted) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        usersProfileData = jsonResponse['data'];
        print("usersProfileData: $usersProfileData");
        print(
            "one_signal_iddd ${usersProfileData['one_signal_id'].toString()}");

        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setString(
            'oneSignalId', "${usersProfileData['one_signal_id'].toString()}");
        print(
            "IDDDD ${baseUrlImage + usersProfileData['profile_pic'].toString()}");

        setState(() {
          isLoading = false;
        });
      } else {
        print("Response Body: ${response.body}");
      }
    }
  }

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
      print("Distanceeeeeeeeeeeeeeeee: $distance");

      getProfile = getProfileFromJson(responseString);

      jobRadius = getProfile.data?.jobRadius;
      print("jobRadius: $jobRadius");

      print('getProfileModels status: ${getProfile.status}');
    }
  }

  GetJobsEmployeesModel getJobsEmployeesModel = GetJobsEmployeesModel();

  bool isClicked = false;

  GetJobsEmployees() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');

    print("usersCustomersId = $usersCustomersId");

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

  String? distance;
  String? jobRadius;
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
      body: {"jobs_id": jobidindex, "users_customers_id": usersCustomersId},
    );
    final responseString = response.body;
    print("acceptJobModelsApiUrl: ${response.body}");
    print("status Code acceptJobModels: ${response.statusCode}");
    print("in 200 acceptJobModels");
    if (response.statusCode == 200) {
      acceptJobModels = acceptJobModelsFromJson(responseString);
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
      print('rejectJobModels status: ${rejectJobModels.status}');
      print('rejectJobModels message: ${rejectJobModels.message}');
      setState(() {
        isLoading = false;
      });
    }
  }

  EmployeeOngoingJobsModel employeeOngoingJobsModel =
      EmployeeOngoingJobsModel();
  bool pg = false;
  getOngoingJobsEmployees() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    // longitude = prefs!.getString('longitude1');
    // lattitude = prefs!.getString('lattitude1');
    print("usersCustomersId = $usersCustomersId");
    // print("longitude1111: ${longitude}");
    // print("lattitude1111: ${lattitude}");
    setState(() {
      pg = true;
    });
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
    print("getOngoingJobsEmployeesModelApiUrl: ${response.body}");
    print("status Code getOngoingJobsEmployeesModel: ${response.statusCode}");
    print("in 200 getOngoingJobsEmployees");
    if (response.statusCode == 200) {
      employeeOngoingJobsModel =
          employeeOngoingJobsModelFromJson(responseString);
      if (mounted) {
        setState(() {
          pg = false;
        });
      }
      print('getJobsEmployeesModel status: ${employeeOngoingJobsModel.status}');
      print(
          'getJobsEmployeesModel Length: ${employeeOngoingJobsModel.data?.length}');
    }
  }

  double? tryParseDouble(String? value) {
    try {
      return double.parse(value ?? '');
    } catch (_) {
      return null;
    }
  }

  void filterJobsByDistance(EmployeeOngoingJobsModel model) {
    double? jobRadius = tryParseDouble(getProfile.data?.jobRadius);
    if (jobRadius != null) {
      List<dynamic>? jobs = model.data;
      if (jobs != null) {
        List<dynamic> filteredJobs = jobs.where((job) {
          double distance = double.tryParse(job['distance'] ?? '0.0') ?? 0.0;
          return distance <= jobRadius;
        }).toList();

        // Print filtered job details
        print('Filtered Jobs:');
        for (var filteredJob in filteredJobs) {
          print('Job ID: ${filteredJob['jobs_id']}');
          print('Distance: ${filteredJob['distance']}');
          // Print other relevant job details as needed
        }
      }
    }
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _showSnackBar(
          'Location services are disabled. Please enable the services');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }

    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<bool> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return false;

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(position);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks.isNotEmpty ? placemarks[0] : Placemark();

    setState(() {
      _currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      print("long : ${position.longitude}");
      print("lat : ${position.latitude}");
    });
  }

  Future<void> updateLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final usersCustomersId = prefs.getString('empUsersCustomersId');
    if (usersCustomersId != null) {
      var headersList = {
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('https://admin.standman.ca/api/update_location');

      var body = {
        "users_customers_id": usersCustomersId,
        // "latitude": "40.7615421",
        // "longitude": "-73.982599"
        "latitude": "${_currentPosition?.latitude}",
        "longitude": "${_currentPosition?.longitude}"
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode == 200) {
        print("resBody: ${resBody}");
      } else {
        print(res.reasonPhrase);
      }
    }
  }

  Future<void> sharePref() async {
    bool locationPermissionGranted = await _getCurrentPosition();

    while (!locationPermissionGranted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('Please Turn on your Location'),
            actions: <Widget>[
              TextButton(
                child: Text('Check Permission'),
                onPressed: () async {
                  locationPermissionGranted = await _getCurrentPosition();
                  if (locationPermissionGranted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );

      await Future.delayed(Duration(seconds: 1));

      locationPermissionGranted = await _getCurrentPosition();
    }
    await updateLocation();

    final prefs = await SharedPreferences.getInstance();
    final usersCustomersId = prefs.getString('empUsersCustomersId');
    print("usersCustomersId = $usersCustomersId");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: EmpDrawer(),
      appBar: AppBar(
        toolbarHeight: height * 0.10,
        backgroundColor: Color(0xff2B65EC),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            "Home",
            style: TextStyle(
              color: Color(0xffffffff),
              fontFamily: "Outfit",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              // letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => EmpNotificationPage());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 0.0),
              child: SvgPicture.asset(
                'assets/images/notification.svg',
              ),
            ),
          ),
        ],
      ),
      // drawer: MyDrawer(),
      backgroundColor: Color(0xff2B65EC),
      body:
          // progress
          //     ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          //     : usersProfileModel.status != "success"
          //     ? Center(
          //     child: Text('no data found...',
          //         style: TextStyle(fontWeight: FontWeight.bold)))
          //     :
          SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18, bottom: 0),
                    child:
                        // Image.asset("assets/images/person.png"),
                        Container(
                      child: isLoading
                          ? CircleAvatar(
                              radius: 35,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade500,
                                highlightColor: Colors.grey.shade200,
                                child: Text(
                                  '',
                                ),
                              ),
                            )
                          : usersProfileData == null
                              ? Center(
                                  child: Text('',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))
                              : CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: baseUrlImage +
                                              usersProfileData['profile_pic']
                                                  .toString() ==
                                          null
                                      ? Image.asset("assets/images/person2.png")
                                          .image
                                      : NetworkImage(baseUrlImage +
                                          usersProfileData['profile_pic']
                                              .toString())),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello..!",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        child: usersProfileData == null
                            ? Text("")
                            : Text(
                                "${usersProfileData['first_name']} ${usersProfileData['last_name']}",
                                // "${usersProfileModel.data!.firstName "$+" usersProfileModel.data.lastName}",
                                // "Marvis Ighedosa",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: () async {
                await GetJobsEmployees();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  width: width,
                  height: height,
                  // height: height * 0.7,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading("Jobs ", "", context),
                        // EmpJobs(),

                        Container(
                          height: 355,
                          child: getJobsEmployeesModel.data != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: getJobsEmployeesModel.data?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    double? jobRadius = tryParseDouble(
                                        getProfile.data?.jobRadius);
                                    double? distance = tryParseDouble(
                                        getJobsEmployeesModel
                                            .data?[index].distance);
                                    int reversedindex =
                                        getJobsEmployeesModel.data!.length -
                                            1 -
                                            index;
                                    jobIndex =
                                        "${getJobsEmployeesModel.data?[index].jobsId}";
                                    // jobIndex = "${getJobsEmployeesModel.data?[index].usersCustomersData!.fullName}";
                                    List<double> distances = [];
                                    distances.clear();

                                    if (getJobsEmployeesModel.data != null) {
                                      distances = getJobsEmployeesModel.data!
                                          .map((job) =>
                                              double.tryParse(
                                                  job.distance ?? '0.0') ??
                                              0.0)
                                          .toList();
                                    }

                                    print(distances);
                                    // distance =
                                    //     "${getJobsEmployeesModel.data?[index].distance}";

                                    print('jobIndex $jobIndex');
                                    // if (jobRadius != null &&
                                    //     distances.any((distance) =>
                                    //         distance <= jobRadius)) {
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                                .data?[index]
                                                                .name,
                                                        totalPrice:
                                                            getJobsEmployeesModel
                                                                .data?[index]
                                                                .price,
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
                                                                    .data?[
                                                                        index]
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
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
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45),
                                                      child: AutoSizeText(
                                                        "${getJobsEmployeesModel.data?[index].name.toString()}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                          fontFamily: "Outfit",
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          // letterSpacing: -0.3,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0.0),
                                                      child: Text(
                                                        "${getJobsEmployeesModel.data?[index].dateAdded}",
                                                        // 'Mar 03, 2023',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff9D9FAD),
                                                          fontFamily: "Outfit",
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          // letterSpacing: -0.3,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
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
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xff9D9FAD),
                                                              fontFamily:
                                                                  "Outfit",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
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
                                                        color:
                                                            Color(0xff2B65EC),
                                                        fontFamily: "Outfit",
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                                isClicked =
                                                                    true;
                                                              });
                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () async {
                                                                toastSuccessMessage(
                                                                    "${acceptJobModels.status}",
                                                                    Colors
                                                                        .green);
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
                                                                String
                                                                    jobidindex =
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
                                                                      Colors
                                                                          .red);
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
                                                                      Colors
                                                                          .red);
                                                                  Get.to(() =>
                                                                      Empbottom_bar(
                                                                        currentIndex:
                                                                            0,
                                                                      ));
                                                                }
                                                              },
                                                              child: smallButton2(
                                                                  "Incurious",
                                                                  Color(
                                                                      0xffC70000),
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
                                  })
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
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
                                      height: height * 0.08,
                                    ),
                                    SvgPicture.asset(
                                      'assets/images/cartoon.svg',
                                    ),
                                  ],
                                ),
                        ),
                        // Heading("Job in Queue ", "", context),
                        // // QueueJobs(),
                        // Container(
                        //   height: 200,
                        //   child: employeeOngoingJobsModel.data != null
                        //       ? ListView.builder(
                        //           scrollDirection: Axis.horizontal,
                        //           physics: ScrollPhysics(),
                        //           itemCount:
                        //               employeeOngoingJobsModel.data?.length,
                        //           itemBuilder: (BuildContext context, i) {
                        //             return QueueJobs(
                        //               employeeOngoingJobsModel:
                        //                   employeeOngoingJobsModel.data?[i],
                        //             );
                        //           })
                        //       : Center(child: Text('No Queue Jobs')),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
