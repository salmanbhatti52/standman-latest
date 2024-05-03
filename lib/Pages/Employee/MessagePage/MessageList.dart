import 'package:StandMan/Pages/Employee/HomePage/EmpHomePage.dart';
import 'package:StandMan/Pages/Employee/MessagePage/employeeInBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/get_allCaht_Model.dart';
import '../../../Models/getprofile.dart';
import '../../../Utils/api_urls.dart';
import '../../Customer/HomePage/HomePage.dart';
import 'MessageDetails.dart';
import 'package:http/http.dart' as http;

class EmpMessagesLists extends StatefulWidget {
  @override
  _EmpMessagesListsState createState() => _EmpMessagesListsState();
}

class _EmpMessagesListsState extends State<EmpMessagesLists> {
  GetAllCahtModel getAllChatModel = GetAllCahtModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllChat();
    sharePref();
    getprofile();
  }

  sharePref() async {
    prefs = await SharedPreferences.getInstance();
    oneSignalID = prefs!.getString('oneSignalId');
    print("oneSignalId = $oneSignalID");
  }

  bool progress = false;
  bool isInAsyncCall = false;
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

  getAllChat() async {
    setState(() {
      progress = true;
    });
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("userId in Prefs is = $usersCustomersId");

    // try {
    String apiUrl = getAllChatApiUrl;
    print("getAllChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": usersCustomersId,
      },
      headers: {'Accept': 'application/json'},
    );
    print('${response.statusCode}');
    print(response);
    if (response.statusCode == 200) {
      final responseString = response.body;
      print("getAllChatResponse: ${responseString.toString()}");
      getAllChatModel = getAllCahtModelFromJson(responseString);

      if (mounted) {
        setState(() {
          progress = false;
        });
      }
    }
    // } catch (e) {
    //   print('Error in getAllChatApi: ${e.toString()}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isInAsyncCall,
      opacity: 0.02,
      blur: 0.5,
      color: Colors.transparent,
      progressIndicator: CircularProgressIndicator(
        color: Colors.blue,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.16,
              width: width,
              height: height * 0.80, //88,
              child: progress
                  ? Center(
                      child: Lottie.asset(
                        "assets/images/loading.json",
                        height: 50,
                      ),
                    )
                  : getAllChatModel.status != "success"
                      ? Center(
                          child: Text('no Chat available...',
                              style: TextStyle(fontWeight: FontWeight.bold)))
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: getAllChatModel.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            DateTime inputTime =
                                getAllChatModel.data![index].dateAdded!;
                            // DateFormat inputFormat = DateFormat("H:mm:ss");
                            DateFormat outputFormat = DateFormat("h:mm a");
                            // DateTime dateTime = inputFormat.parse(inputTime);
                            String formattedTime =
                                outputFormat.format(inputTime);
                            DateTime inputDate =
                                getAllChatModel.data![index].dateAdded!;
                            // DateFormat inputFormat = DateFormat("H:mm:ss");
                            DateFormat outputDateFormat =
                                DateFormat("EEE, MMM d");
                            // DateTime dateTime = inputFormat.parse(inputTime);
                            String formattedDate =
                                outputDateFormat.format(inputDate);
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20, left: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                              onTap: () {
                                                Get.to(() => EmployeeInbox(
                                                      rId:
                                                          "${getAllChatModel.data?[index].userData!.usersCustomersId}",
                                                      profilepic:
                                                          "$baseUrlImage${getAllChatModel.data![index].userData!.profilePic}",
                                                      fullname:
                                                          "${getAllChatModel.data![index].userData!.firstName} ${getAllChatModel.data![index].userData!.lastName}",
                                                      userId:
                                                          "${usersCustomersId}",
                                                    ));
                                                //  Get.to(() => EmpMessagesDetails(
                                                //   other_users_customers_id:
                                                //       "${getAllChatModel.data?[index].senderData!.usersCustomersId}",
                                                //   img:
                                                //       "$baseUrlImage${getAllChatModel.data![index].senderData!.profilePic}",
                                                //   name:
                                                //       "${getAllChatModel.data![index].senderData!.firstName} ${getAllChatModel.data![index].senderData!.lastName}",
                                                // ));
                                              },
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                // messagesList[index].title,
                                                "${getAllChatModel.data![index].userData!.firstName} ${getAllChatModel.data![index].userData!.lastName}",
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: "Outfit",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                                // textAlign: TextAlign.center,
                                              ),
                                              subtitle: Text(
                                                "$formattedDate",
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                  fontFamily: "Outfit",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                                // textAlign: TextAlign.left,
                                              ),
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                                child: FadeInImage(
                                                  placeholder: AssetImage(
                                                      "assets/images/fade_in_image.jpeg"),
                                                  fit: BoxFit.fill,
                                                  height: 35,
                                                  width: 35,
                                                  image: NetworkImage(
                                                      "$baseUrlImage${getAllChatModel.data![index].userData!.profilePic}"),
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Text(
                                                  // "${getAllChatModel.data![index].time.toString()} ${getAllChatModel.data![index].date.toString()}",
                                                  // "${getAllChatModel.data![index].date} ${getAllChatModel.data![index].runtimeType}",
                                                  formattedTime,
                                                  style: TextStyle(
                                                    color: Color(0xffA7A9B7),
                                                    fontFamily: "Outfit",
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  // textAlign: TextAlign.right,
                                                ),
                                              ),
                                            )
                                         
                                    ],
                                  ),
                                ),
                                Divider(
                                  indent: 15,
                                  endIndent: 15,
                                ),
                              ],
                            );
                          }),
            ),
          ),
        ],
      ),
    );
  }
}
