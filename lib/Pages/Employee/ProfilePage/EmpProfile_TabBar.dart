import 'dart:convert';

import 'package:StandMan/Pages/EmpDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../Models/users_profilet_model.dart';
import '../../../Utils/api_urls.dart';
import '../../Drawer.dart';
import '../HomePage/EmpHomePage.dart';
import 'EditProfile.dart';
import 'ProfilePage.dart';
import 'Rating.dart';

class ProfileTabBar extends StatefulWidget {
  const ProfileTabBar({Key? key}) : super(key: key);

  @override
  State<ProfileTabBar> createState() => _ProfileTabBarState();
}

class _ProfileTabBarState extends State<ProfileTabBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getUserProfileWidget();
  // }

  sharedPrefs() async {
    // loading = true;
    setState(() {});
    print('in LoginPage shared prefs');
    empPrefs = await SharedPreferences.getInstance();
    // userId = (prefs!.getString('userid'));
    empUserEmail = (empPrefs!.getString('empUser_email'));
    empPhoneNumber = (empPrefs!.getString('empPhoneNumber'));
    empFullName = (empPrefs!.getString('empFullName'));
    // profilePic1 = (prefs!.getString('profilePic'));
    empPassword = (empPrefs!.getString('empPassword'));
    empUsersCustomersId = empPrefs!.getString('empUsersCustomersId');
    print("userId in empPrefs is = $empUsersCustomersId");
    print("oldpass = $empPassword");
    getUserProfileWidget();
    // userFirstName = (prefs!.getString('user_first_name'));
    // userLastName = (prefs!.getString('user_last_name'));
    // print("userId in LoginPrefs is = $userId");
    print("userEmail in Profile is = $empUserEmail");
    print("userprofilePic in Profile is = $empProfilePic1");
    // print("userFirstName in LoginPrefs is = $userFirstName $userLastName");
  }

  bool isLoading = false;
  dynamic usersProfileData;

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
      setState(() {
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          usersProfileData = jsonResponse['data'];
          print("usersProfileData: $usersProfileData");
          print(
              "IDDDD ${baseUrlImage + usersProfileData['profile_pic'].toString()}");
          isLoading = false;
        } else {
          print("Response Body: ${response.body}");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getUserProfileWidget();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer: EmpDrawer(),
        appBar: AppBar(
          toolbarHeight: height * 0.10,
          backgroundColor: Color(0xffffffff),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          // leading: Padding(
          //   padding: EdgeInsets.only(left: 15),
          //   child: IconButton(
          //     icon: Icon(Icons.menu, color: Colors.black,),
          //     onPressed: () {
          //       // Do something
          //       // Get.to(MyDrawer());
          //     },
          //   ),
          // ),
          title: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Text(
              "Profile",
              style: TextStyle(
                color: Color(0xff000000),
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
                Get.to(() => EmpEditProfile(
                      email: "${usersProfileData['email']}",
                      countryCode: "${usersProfileData['country_code']}",
                      phone: "${usersProfileData['phone']}",
                      firstname: "${usersProfileData['first_name']}",
                      lastname: " ${usersProfileData['last_name']}",
                      profilePic:
                          "${baseUrlImage + usersProfileData['profile_pic'].toString()}",
                      jobRadius: "${usersProfileData['job_radius'].toString()}",
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 0.0),
                child: SvgPicture.asset("assets/images/edit-2.svg"),
              ),
            ),
          ],
        ),
        // drawer: MyDrawer(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Column(
              children: [
                Container(
                  width: width * 0.85, // 327,
                  // height: height * 0.075,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color.fromRGBO(248, 249, 251, 1),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    labelColor: Colors.black,
                    unselectedLabelColor: Color(0xffA7A9B7),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    indicatorColor: Colors.pink,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    tabs: [
                      Tab(
                        text: "Info",
                      ),
                      Tab(
                        text: "Ratings ",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
            Expanded(
              child: Container(
                // height: height * 0.1,
                // width: 300,
                child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      EmpProfilePage(),
                      RatingProfile(),
                    ]),
              ),
            ),
            // SizedBox(height: height * 0.04),
          ],
        ));
  }
}
