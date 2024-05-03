import 'dart:convert';

import 'package:StandMan/Models/change_my_password_model.dart';
import 'package:StandMan/Models/getprofile.dart';
import 'package:StandMan/Pages/Authentication/Login_tab_class.dart';
import 'package:StandMan/widgets/ToastMessage.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Models/users_profilet_model.dart';
import '../../../Utils/api_urls.dart';
import '../../../widgets/MyButton.dart';
import '../../Drawer.dart';
import '../HomePage/HomePage.dart';
import 'ChangePassword.dart';
import 'DeleteAccount.dart';
import 'EditJobList.dart';
import 'EditProfile.dart';
import 'NotificationSettings.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfileWidget();
    getUserProfile();
  }

  bool isLoading = false;
  dynamic usersProfileData;
  GetProfile getProfile = GetProfile();
  getUserProfile() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");

    String apiUrl = usersProfileApiUrl;
    print("getUserProfileApi: $apiUrl");
    if (!mounted) {
      return; // Check if the widget is still mounted
    }
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
    }, body: {
      "users_customers_id": "$usersCustomersId"
    });
    if (!mounted) {
      return; // Check again if the widget is still mounted after the HTTP request
    }
    final responseString = response.body;
    print("getProfileModels Response: $responseString");
    print("status Code getProfileModels: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("in 200 getProfileModels");
      print("SuucessFull");
      getProfile = getProfileFromJson(responseString);
      if (!mounted) {
        return; // Check once more if the widget is still mounted before updating the state
      }
      setState(() {
        isLoading = false;
      });
      print('getProfileModels status: ${getProfile.status}');
    }
  }

  getUserProfileWidget() async {
    setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");

    String apiUrl = usersProfileApiUrl;
    print("getUserProfileApi: $apiUrl");

    http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": usersCustomersId.toString(),
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
          // print("IDDDD ${baseUrlImage+usersProfileData['profile_pic'].toString()}");
          isLoading = false;
        } else {
          print("Response Body: ${response.body}");
        }
      });
    }
  }

  // UsersProfileModel usersProfileModel = UsersProfileModel();
  // bool progress = false;
  // bool isInAsyncCall = false;
  //
  // getUserProfileWidget() async {
  //   prefs = await SharedPreferences.getInstance();
  //   usersCustomersId = prefs!.getString('usersCustomersId');
  //   print("usersCustomersId = $usersCustomersId");
  //   setState(() {});
  //   // try {
  //     String apiUrl = usersProfileApiUrl;
  //     print("getUserProfileApi: $apiUrl");
  //     final response = await http.post(Uri.parse(apiUrl),
  //         body: {
  //       "users_customers_id": usersCustomersId.toString(),
  //     }, headers: {
  //       'Accept': 'application/json'
  //     });
  //     print('${response.statusCode}');
  //     print(response);
  //     if (response.statusCode == 200) {
  //       final responseString = response.body;
  //       print("getUserProfileResponse: ${responseString.toString()}");
  //       usersProfileModel = usersProfileModelFromJson(responseString);
  //       print("getUserName: ${usersProfileModel.data!.lastName}");
  //       print("getUserEmail: ${usersProfileModel.data!.email}");
  //       print("getUserEmail: ${usersProfileModel.data!.email}");
  //       print("getUserNumber: ${usersProfileModel.data!.phone}");
  //       print("usersCustomersId: ${usersProfileModel.data!.usersCustomersId}");
  //       print("getUserProfileImage: $baseUrlImage${usersProfileModel.data!.profilePic}");
  //       setState(() {});
  //     }
  //   // } catch (e) {
  //   //   print('Error in getUserProfileWidget: ${e.toString()}');
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        toolbarHeight: height * 0.10,
        backgroundColor: Color(0xfffffff),
        elevation: 0,
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.menu, color: Colors.black,),
        //   onPressed: () {
        //     // Do something
        //     // Get.to(MyDrawer());
        //   },
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
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 0.0),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => EditProfile(
                      email: "${usersProfileData['email']}",
                      countryCode: "${usersProfileData['country_code']}",
                      phone: "${usersProfileData['phone']}",
                      firstname: "${getProfile.data!.firstName}",
                      lastname: " ${getProfile.data!.lastName}",
                      profilePic:
                          "${baseUrlImage + getProfile.data!.profilePic!.toString()}",
                      jobRadius: "${getProfile.data!.jobRadius}"),
                );
              },
              child: SvgPicture.asset("assets/images/edit-2.svg"),
            ),
          ),
        ],
        // leading: SvgPicture.asset(
        //     "assets/images/menubl.svg",
        //   width: 20,
        //   height: 20,
        // ),
      ),
      // drawer: MyDrawer(),
      // backgroundColor: Colors.white,
      body:
          // progress
          //     ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          //     : usersProfileModel.status != "success"
          //         ? Center(
          //             child: Text('no data found...',
          //                 style: TextStyle(fontWeight: FontWeight.bold)))
          //         :
          // ModalProgressHUD(
          //   inAsyncCall: isLoading,
          //   opacity: 0.02,
          //   blur: 0.5,
          //   color: Colors.transparent,
          //   progressIndicator: CircularProgressIndicator(
          //     color: Colors.blue,
          //   ),
          //   child:
          SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                width: width * 0.9, // 351,
                height: height * 0.18, // 131,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xff2B65EC),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.05,
                    ),
                    // Image.asset("assets/images/person2.png", width: 99, height: 99,),
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundColor: Colors.transparent,
                    //     backgroundImage: AssetImage("assets/images/person2.png"),
                    // ),

                    Container(
                      child: isLoading
                          ? CircleAvatar(
                              radius: 50,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
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
                                  // radius: (screenWidth > 600) ? 90 : 70,
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: baseUrlImage +
                                              usersProfileData['profile_pic']
                                                  .toString() ==
                                          null
                                      ? Image.asset("assets/images/person2.png")
                                          .image
                                      : NetworkImage(baseUrlImage +
                                          usersProfileData['profile_pic']
                                              .toString())
                                  // NetworkImage(baseUrlImage+ getUserProfileModelObject.data!.profilePic!)

                                  ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: usersProfileData == null
                              ? Text("")
                              : Text(
                                  "${usersProfileData['first_name']} ${usersProfileData['last_name']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                        Container(
                          child: usersProfileData == null
                              ? Text("")
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    // mainAxisAlignment:
                                    // MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/sms-tracking.svg",
                                        color: Colors.white,
                                      ),
                                      usersProfileData == null
                                          ? Text("")
                                          : ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.45),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: AutoSizeText(
                                                  "${usersProfileData['email']}",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                      // Text(
                                      //     "  ${usersProfileModel.data!.email}",
                                      //     style: TextStyle(
                                      //       color: Color(0xffffffff),
                                      //       fontFamily: "Outfit",
                                      //       fontWeight: FontWeight.w300,
                                      //       fontSize: 14,
                                      //     ),
                                      //   ),
                                    ],
                                  ),
                                ),
                        ),
                        Container(
                          child: usersProfileData == null
                              ? Text("")
                              : Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/call.svg",
                                      color: Colors.white,
                                      width: 16,
                                      height: 16,
                                    ),
                                    Text(
                                      "${usersProfileData['phone']}",
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontFamily: "Outfit",
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(  () => EditJobList());
              //   },
              //   child: Container(
              //     width: width, //350,
              //     height: height * 0.060, // 48,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: Colors.white,
              //         boxShadow: [
              //           BoxShadow(
              //             blurRadius: 20,
              //             spreadRadius: 0,
              //             offset: Offset(0, 2),
              //             color: Color.fromRGBO(67, 169, 183, 0.1),
              //           ),
              //         ]),
              //     child: Padding(
              //       padding:
              //       const EdgeInsets.symmetric(horizontal: 15.0),
              //       child: Row(
              //         mainAxisAlignment:
              //         MainAxisAlignment.spaceBetween,
              //         children: [
              //           SvgPicture.asset(
              //             "assets/images/edit_job.svg",
              //             color: Color(0xff2B65EC),
              //           ),
              //           const Text(
              //             "Edit Your Job",
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontFamily: "Outfit",
              //               fontWeight: FontWeight.w300,
              //               fontSize: 16,
              //             ),
              //           ),
              //           SizedBox(
              //             width: width * 0.3,
              //           ),
              //           SvgPicture.asset(
              //             "assets/images/chevron-left.svg",
              //           ),
              //           // Svg
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              GestureDetector(
                onTap: () {
                  // updatePasswordBottomSheet(
                  //   context,
                  // );
                  ChangePassword(context, userEmail, password);
                  print("useremail123 $userEmail");
                  print("oldpass123 $password");
                },
                child: Container(
                  width: width, //350,
                  height: height * 0.060, // 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                          color: Color.fromRGBO(67, 169, 183, 0.1),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/lock.svg",
                          color: Color(0xff2B65EC),
                        ),
                        const Text(
                          "Change password",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.2,
                        ),
                        SvgPicture.asset(
                          "assets/images/chevron-left.svg",
                        ),
                        // Svg
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  NotificationSettings(context);
                },
                child: Container(
                  width: width, //350,
                  height: height * 0.060, // 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                          color: Color.fromRGBO(67, 169, 183, 0.1),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/notification.svg",
                          color: Color(0xff2B65EC),
                        ),
                        const Text(
                          "Notifications setting",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.17,
                        ),
                        SvgPicture.asset(
                          "assets/images/chevron-left.svg",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  DeleteAccount(context);
                },
                child: Container(
                  width: width, //350,
                  height: height * 0.060, // 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                          color: Color.fromRGBO(67, 169, 183, 0.1),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/trash.svg",
                          color: Color(0xff2B65EC),
                        ),
                        const Text(
                          "Delete account",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.24,
                        ),
                        SvgPicture.asset(
                          "assets/images/chevron-left.svg",
                        ),
                        // Svg
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  // removeDataFormSharedPreferences();
                  // setState(() {});
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => LoginTabClass()));
                  showLogoutAlertDialog(context);
                },
                child: Container(
                  width: width, //350,
                  height: height * 0.060, // 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                          color: Color.fromRGBO(67, 169, 183, 0.1),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/logout.svg",
                          color: Color(0xff2B65EC),
                        ),
                        SizedBox(
                          width: width * 0.055,
                        ),
                        const Text(
                          "Sign Out",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }

  ChangeMyPasswordModel changeMyPasswordModel = ChangeMyPasswordModel();

  final oldpasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final key = GlobalKey<FormState>();
  bool progress = false;
  bool isInAsyncCall = false;

  changePasswordFromProfile() async {
    progress = true;
    // setState(() {});
    // try {
    String apiUrl = changePasswordFromProfileApiUrl;
    print("changePasswordFromProfileApiUrl: $apiUrl");
    print("userEmail: ${userEmail.toString()}");
    print("oldpasswordController: ${oldpasswordController.text}");

    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");
    print("passwordController: ${passwordController.text}");
    print("confirmpasswordController: ${confirmpasswordController.text}");
    final response = await http.post(Uri.parse(apiUrl), body: {
      "users_customers_id": usersCustomersId,
      "current_password": oldpasswordController.text,
      "password": passwordController.text,
      "confirm_password": confirmpasswordController.text,
    }, headers: {
      'Accept': 'application/json'
    });
    final responseString = response.body;
    print("responseSignInApi: $responseString");
    print("status Code SignIn: ${response.statusCode}");
    print("in 200 SignIn");
    if (response.statusCode == 200) {
      changeMyPasswordModel = changeMyPasswordModelFromJson(responseString);
      // st(() {});
      print('signUpModel status: ${changeMyPasswordModel.status}');
    }
    // }
    // catch (e) {
    //   print('Error in getUserProfileWidget: ${e.toString()}');
    // }
    progress = false;
    // StateSetter(() {});
  }

  // sharedPrefs() async {
  //   // loading = true;
  //   // setState(() {});
  //   print('in changepassword shared prefs');
  //   prefs = await SharedPreferences.getInstance();
  //   // userId = (prefs!.getString('userid'));
  //   // userEmail = (prefs!.getString('user_email'));
  //   password = (prefs!.getString('password'));
  //   changePasswordFromProfile();
  //   print("userEmail in Profile is = $userEmail");
  //   print("userpassword in Profile is = $password");
  // }

  // @override
  // void initState() {
  //   // super.initState();
  //   sharedPrefs();
  // }

  bool isPasswordObscure = true;
  bool isoldPasswordObscure = true;
  bool isPassworconfirmdObscure = true;

  Future<void> updatePasswordBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      )),
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetterObject) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  width: MediaQuery.of(context).size.width, //390,
                  // height: MediaQuery.of(context).size.height * 0.6, // 515,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Padding(
                        //   padding:  EdgeInsets.symmetric(vertical: height * 0.02),
                        //   child: Bar(
                        //     "Change Password",
                        //     'assets/images/arrow-back.svg',
                        //     Colors.black,
                        //     Colors.black,
                        //         () {
                        //       Get.back();
                        //     },
                        //   ),
                        // ),

                        // Container(
                        //   child: StandManAppBar1(
                        //     title: "Change Password",
                        //     bgcolor: Color(0xffffffff),
                        //     titlecolor: Colors.black,
                        //     iconcolor: Colors.black,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(
                                  'assets/images/left.svg',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: key,
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Current Password",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: "Outfit",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      // letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  TextFormField(
                                    controller: oldpasswordController,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                    obscureText: isoldPasswordObscure,
                                    obscuringCharacter: '*',
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Enter your current password",
                                      // contentPadding: const EdgeInsets.only(top: 12.0),
                                      hintStyle: const TextStyle(
                                        color: Color.fromRGBO(167, 169, 183, 1),
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            isPasswordObscure
                                                ? "assets/images/lock.svg"
                                                : "assets/images/lock.svg",
                                          ),
                                        ),
                                        onTap: () {
                                          stateSetterObject(() {
                                            isoldPasswordObscure =
                                                !isoldPasswordObscure;
                                          });
                                        },
                                      ),
                                      suffixIcon: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            isPasswordObscure
                                                ? "assets/images/eye.svg"
                                                : "assets/images/eye.svg",
                                          ),
                                        ),
                                        onTap: () {
                                          stateSetterObject(() {
                                            isoldPasswordObscure =
                                                !isoldPasswordObscure;
                                          });
                                        },
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //     Padding(
                                  //       padding: const EdgeInsets.only(right: 5.0),
                                  //       child: TextButton(
                                  //         onPressed: () {
                                  //           Get.to(CustomerForgotPassword());
                                  //         },
                                  //         child: const Text(
                                  //           "Forgot password?",
                                  //           style: TextStyle(
                                  //               fontFamily: "Outfit",
                                  //               fontSize: 14,
                                  //               color: Color.fromRGBO(167, 169, 183, 1),
                                  //               fontWeight: FontWeight.w300),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "New Password",
                                    style: TextStyle(
                                      color: Color(0xff191D31),
                                      fontFamily: "Outfit",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      // letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) return 'Empty';
                                      return null;
                                    },
                                    controller: passwordController,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                    obscureText: isPasswordObscure,
                                    obscuringCharacter: '*',
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Create new password",
                                      // contentPadding: const EdgeInsets.only(top: 12.0),
                                      hintStyle: const TextStyle(
                                        color: Color.fromRGBO(167, 169, 183, 1),
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            isPasswordObscure
                                                ? "assets/images/lock.svg"
                                                : "assets/images/lock.svg",
                                          ),
                                        ),
                                        onTap: () {
                                          stateSetterObject(() {
                                            isPasswordObscure =
                                                !isPasswordObscure;
                                          });
                                        },
                                      ),
                                      suffixIcon: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            isPasswordObscure
                                                ? "assets/images/eye.svg"
                                                : "assets/images/eye.svg",
                                          ),
                                        ),
                                        onTap: () {
                                          stateSetterObject(() {
                                            isPasswordObscure =
                                                !isPasswordObscure;
                                          });
                                        },
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "Confirm new password",
                                    style: TextStyle(
                                      color: Color(0xff191D31),
                                      fontFamily: "Outfit",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      // letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      if (val!.isEmpty) return 'Empty';
                                      if (val != passwordController.text)
                                        return "not match";
                                      return null;
                                    },
                                    controller: confirmpasswordController,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                    obscureText: isPassworconfirmdObscure,
                                    obscuringCharacter: '*',
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Confirm new password",
                                      // contentPadding: const EdgeInsets.only(top: 12.0),
                                      hintStyle: const TextStyle(
                                        color: Color.fromRGBO(167, 169, 183, 1),
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            isPassworconfirmdObscure
                                                ? "assets/images/lock.svg"
                                                : "assets/images/lock.svg",
                                          ),
                                        ),
                                        onTap: () {
                                          stateSetterObject(() {
                                            isPassworconfirmdObscure =
                                                !isPassworconfirmdObscure;
                                          });
                                        },
                                      ),
                                      suffixIcon: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            isPassworconfirmdObscure
                                                ? "assets/images/eye.svg"
                                                : "assets/images/eye.svg",
                                          ),
                                        ),
                                        onTap: () {
                                          stateSetterObject(() {
                                            isPassworconfirmdObscure =
                                                !isPassworconfirmdObscure;
                                          });
                                        },
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    print(
                                        "oldpass ${oldpasswordController.text}");
                                    // print("myOTP ${widget.data}");
                                    if (key.currentState!.validate()) {
                                      if (oldpasswordController.text.isEmpty) {
                                        toastFailedMessage(
                                            'Old Password cannot be empty',
                                            Colors.red);
                                      } else if (passwordController
                                          .text.isEmpty) {
                                        toastFailedMessage(
                                            'New Password cannot be empty',
                                            Colors.red);
                                      } else if (confirmpasswordController
                                          .text.isEmpty) {
                                        toastFailedMessage(
                                            'Confirm Password cannot be empty',
                                            Colors.red);
                                      } else {
                                        stateSetterObject(() {
                                          isInAsyncCall = true;
                                        });
                                        await changePasswordFromProfile();

                                        if (changeMyPasswordModel.status ==
                                            "success") {
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            toastSuccessMessage(
                                                "Changed password successfully",
                                                Colors.green);
                                            Get.back();
                                            stateSetterObject(() {
                                              isInAsyncCall = false;
                                            });
                                            print("false: $isInAsyncCall");
                                          });
                                        }
                                        if (changeMyPasswordModel.status !=
                                            "success") {
                                          toastFailedMessage(
                                              changeMyPasswordModel.message,
                                              Colors.red);
                                          stateSetterObject(() {
                                            isInAsyncCall = false;
                                          });
                                        }
                                      }
                                    }
                                  },
                                  child: mainButton("Update Password",
                                      Color(0xff2B65EC), context)),
                              // SizedBox(
                              //   height: height * 0.02,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  showLogoutAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Text('Cancel'),
    );
    Widget continueButton = TextButton(
      child: Text('Yes, Continue'),
      onPressed: () {
        removeDataFormSharedPreferences();
        setState(() {});
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginTabClass(
                    login: 0,
                  )),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign Out"),
      content: Text("Are you sure you want to Sign Out ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  removeDataFormSharedPreferences() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {});
  }
}
