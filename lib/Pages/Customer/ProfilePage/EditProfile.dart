import 'dart:convert';
import 'dart:io';
import 'package:StandMan/Models/getprofile.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/update_profile_customer_model.dart';
import '../../../Utils/api_urls.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/ToastMessage.dart';
import '../../../widgets/TopBar.dart';
import 'package:http/http.dart' as http;
import '../../Bottombar.dart';
import '../HomePage/HomePage.dart';

class EditProfile extends StatefulWidget {
  final String? email;
  final String? countryCode;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final String? profilePic;
  final String? jobRadius;

  const EditProfile({
    Key? key,
    this.email,
    this.firstname,
    this.lastname,
    this.jobRadius,
    this.phone,
    this.countryCode,
    this.profilePic,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('value', _selected);
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? count = prefs.getInt("value");
    return count;
  }

  checkvalue() async {
    int count = await _getData() ?? 0;
    setState(() {
      _selected = count;
    });
  }

  String countryCode1 = '';

  void onCountryChange(PhoneNumber number) {
    setState(() {
      countryCode1 = number.countryISOCode;
      print("countryCode ${countryCode1}");
    });
  }

  UpdateProfileCustomerModel updateProfileCustomerModel =
      UpdateProfileCustomerModel();
  final key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isInAsyncCall = false;
  bool progress = false;

  sharedPrefs() async {
    // loading = true;
    print('in LoginPage shared prefs');
    prefs = await SharedPreferences.getInstance();
    // userId = (prefs!.getString('userid'));
    userEmail = (prefs!.getString('user_email'));
    phoneNumber = (prefs!.getString('phoneNumber'));
    // fullName = (prefs!.getString('fullName'));
    profilePic1 = (prefs!.getString('profilePic'));
    usersCustomersId = prefs?.getString('usersCustomersId');
    print("userId in Prefs is = $usersCustomersId");
    // editUserProfileWidget();
    // userFirstName = (prefs!.getString('user_first_name'));
    // userLastName = (prefs!.getString('user_last_name'));
    // print("userId in LoginPrefs is = $userId");
    print("userEmail in Profile is = $userEmail");

    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString('_selectedC', "${_selected}");
    _selected = "${(prefs!.getString('_selectedC'))}" as int;
  }

  setData() async {
    firstName.text = "${widget.firstname}";
    lastName.text = "${widget.lastname}";
    emailController.text = "${widget.email}";
    phoneController.text = "${widget.phone}";

    print("firstName ${firstName.text}");
    print("lastName ${lastName.text}");
    print("email ${emailController.text}");
    print("phone ${phoneController.text}");
  }

  editUserProfileWidget() async {
    progress = true;
    // try {
    String apiUrl = updateCustomerProfileApiUrl;
    print("editUserProfileApi: $apiUrl");
    print("usersCustomersId: $usersCustomersId");
    print("emailController: ${emailController.text}");
    print("phoneController: ${phoneController.text}");
    print("baseProfileImage: ${base64img ?? widget.profilePic}");

    final response = await http.post(Uri.parse(apiUrl), body: {
      "users_customers_id": usersCustomersId,
      "first_name": firstName.text,
      "last_name": lastName.text,
      "job_radius": "${widget.jobRadius}",
      "phone": phoneController.text,
      "profile_pic": base64img ?? base64Image,
    }, headers: {
      'Accept': 'application/json'
    });
    print('${response.statusCode}');
    print(response);
    if (response.statusCode == 200) {
      final responseString = response.body;
      print("editUserProfileResponse: ${responseString.toString()}");
      updateProfileCustomerModel =
          updateProfileCustomerModelFromJson(responseString);
      print("getUserName: ${updateProfileCustomerModel.data!}");
      setState(() {});
      // print("getUserEmail: ${updateProfileCustomerModel.data[0].profilePic}");
      // print("getUserNumber: ${updateProfileCustomerModel.data!.phoneNumber}");
      // print("getUserProfileImage: $baseUrlImage${updateProfileCustomerModel.data!.profilePic}");
    }
    // } catch (e) {
    //   print('Error in getUserProfileWidget: ${e.toString()}');
    // }
    progress = false;
  }

  bool isLoading = false;
  String? base64Image;
  GetProfile getProfile = GetProfile();
  getUserProfile() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("userId is = $usersCustomersId");

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
      await convertImageToBase64(widget.profilePic!);

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

  Future<void> convertImageToBase64(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final List<int> imageBytes = response.bodyBytes;
      final String base64 = base64Encode(imageBytes);

      setState(() {
        base64Image = base64;
        print("base64Image : $base64Image");
      });
    }
  }

  int _selected = 0;
  String _selectedcountrycode = "Pk";
  @override
  initState() {
    print("name: ${widget.firstname}");
    print("name: ${widget.lastname}");
    print("email: ${widget.email}");
    print("phone: ${widget.phone}");
    print("profilePic: ${widget.profilePic}");

    // TODO: implement initState
    super.initState();
    checkvalue();
    setData();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: StandManAppBar1(
        title: "Edit Profile",
        bgcolor: Color(0xfffffff),
        titlecolor: Colors.black,
        iconcolor: Colors.black,
      ),
      body
          // : progress
          // ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          // : updateProfileCustomerModel.status != "success"
          //     ? Center(
          //         child: Text('no data found...',
          //             style: TextStyle(fontWeight: FontWeight.bold)))
          :
          // ModalProgressHUD(
          //   inAsyncCall: progress,
          //   opacity: 0.02,
          //   blur: 0.5,
          //   color: Colors.transparent,
          //   progressIndicator: CircularProgressIndicator(color: Colors.blueAccent),
          //   child:
          SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                // SizedBox(
                //   height: height * 0.02,
                // ),
                // Padding(
                //   padding:  EdgeInsets.symmetric(vertical: height * 0.02),
                //   child: Bar(
                //     "Edit Profile",
                //     'assets/images/arrow-back.svg',
                //     Colors.black,
                //     Colors.black,
                //         () {
                //       Get.back();
                //     },
                //   ),
                // ),
                Column(
                  children: [
                    // for(int i=0;i<updateProfileCustomerModel
                    //     .data!.length;i++)
                    Stack(
                      children: [
                        // CircleAvatar(
                        //   // radius: (screenWidth > 600) ? 90 : 70,
                        //     radius: 50,
                        //     backgroundColor: Colors.transparent,
                        //     backgroundImage: NetworkImage(widget.profilePic.toString()),
                        //   // NetworkImage(baseUrlImage+ getUserProfileModelObject.data!.profilePic!)
                        //
                        // ),

                        Container(
                          // child: imagePath == null
                          //     ? CircleAvatar(
                          //   radius: height * 0.08,
                          //   backgroundColor:
                          //   Colors.transparent,
                          //   backgroundImage: imagePath == null
                          //       ? AssetImage(
                          //       "assets/images/person2.png")
                          //       : Image.file(
                          //     imagePath!,
                          //     height: 50,
                          //     width: 50,
                          //     fit: BoxFit.contain,
                          //   ).image,
                          // )
                          //     :
                          child: CircleAvatar(
                            radius: height * 0.08,
                            backgroundColor: Colors.transparent,
                            backgroundImage: imagePath == null
                                ? NetworkImage(widget.profilePic.toString())
                                : Image.file(
                                    imagePath!,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.contain,
                                  ).image,
                          ),
                        ),
                        Positioned(
                          // top: 80,
                          right: 1,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () async {
                              pickCoverImage();
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: Color(0xff1D272F),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                      "assets/images/camera.svg")),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Form(
                        key: key,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: const Text(
                                    "First Name",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: "Outfit",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      // letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 16),
                                        cursorColor: const Color(0xFF000000),
                                        controller: firstName,
                                        // keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SvgPicture.asset(
                                              "assets/images/profile-2.svg",
                                              color: Color(0xff2B65EC),
                                              width: 10,
                                              height: 10,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xff2B65EC)),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          // labelText: 'Email',
                                          hintText: "First Name",
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color(
                                                    0xFFF3F3F3)), // change border color
                                          ),
                                          labelStyle: const TextStyle(),
                                          hintStyle: const TextStyle(
                                              color: Color(0xFFA7A9B7),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: "Satoshi"),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: const Text(
                                    "Last Name",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: "Outfit",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      // letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 16),
                                        cursorColor: const Color(0xFF000000),
                                        controller: lastName,
                                        // keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SvgPicture.asset(
                                              "assets/images/profile-2.svg",
                                              color: Color(0xff2B65EC),
                                              width: 10,
                                              height: 10,
                                            ),
                                          ),

                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xff2B65EC)),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          // labelText: 'Email',
                                          hintText: "Last Name",
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Color(
                                                    0xFFF3F3F3)), // change border color
                                          ),
                                          labelStyle: const TextStyle(),
                                          hintStyle: const TextStyle(
                                              color: Color(0xFFA7A9B7),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: "Satoshi"),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: const Text(
                                    "Email",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: "Outfit",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      // letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                TextFormField(
                                  enableInteractiveSelection: false,
                                  focusNode: FocusNode(),
                                  readOnly: true,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Container(
                                              width: 300,
                                              height: height * 0.15, // 321,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "You cannot edit your Email.",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 1),
                                                        fontFamily: "Outfit",
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        // letterSpacing: -0.3,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.02,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: smallButton(
                                                            "OK",
                                                            Color(0xff2B65EC),
                                                            context))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  controller: emailController,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 12.0),
                                    // hintText: "Marvis Ighedosa",
                                    hintText: "${widget.email}",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SvgPicture.asset(
                                          "assets/images/wallet-2.svg"),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(243, 243, 243, 1),
                                        width: 1.0,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(243, 243, 243, 1),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(243, 243, 243, 1),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(243, 243, 243, 1),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, left: 2),
                              child: Row(
                                children: [
                                  const Text(
                                    "Phone Number",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: "Outfit",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      // letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: const TextStyle(
                                        color: Color(0xFF000000), fontSize: 16),
                                    cursorColor: const Color(0xFF000000),
                                    controller: phoneController,
                                    // keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                          "assets/images/call.svg",
                                          color: Color(0xff2B65EC),
                                          width: 10,
                                          height: 10,
                                        ),
                                      ),

                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xff2B65EC)),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      // labelText: 'Email',
                                      hintText: "Phone Number",
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Color(
                                                0xFFF3F3F3)), // change border color
                                      ),
                                      labelStyle: const TextStyle(),
                                      hintStyle: const TextStyle(
                                          color: Color(0xFFA7A9B7),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "Satoshi"),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          12), // Limit to 11 characters
                                      // You can also add other formatters if needed
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: const Text(
                            "Gender",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: "Outfit",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              // letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _saveData();
                                    _selected = 1;
                                  });
                                },
                                child: Container(
                                    width: 82,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffF3F3F3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          _selected == 1
                                              ? "assets/images/Ring.svg"
                                              : "assets/images/Ring2.svg",
                                        ),
                                        const Text(
                                          "   Male",
                                          style: TextStyle(
                                            color: Color(0xffA7A9B7),
                                            fontFamily: "Outfit",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            // letterSpacing: -0.3,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _saveData();
                                    _selected = 2;
                                  });
                                },
                                child: Container(
                                    width: 82,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffF3F3F3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          _selected == 2
                                              ? "assets/images/Ring.svg"
                                              : "assets/images/Ring2.svg",
                                        ),
                                        const Text(
                                          "   Female",
                                          style: TextStyle(
                                            color: Color(0xffA7A9B7),
                                            fontFamily: "Outfit",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            // letterSpacing: -0.3,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _saveData();
                                    _selected = 3;
                                  });
                                },
                                child: Container(
                                    width: 82,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffF3F3F3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          _selected == 3
                                              ? "assets/images/Ring.svg"
                                              : "assets/images/Ring2.svg",
                                        ),
                                        const Text(
                                          "   Other",
                                          style: TextStyle(
                                            color: Color(0xffA7A9B7),
                                            fontFamily: "Outfit",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            // letterSpacing: -0.3,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // fullName= nameController.text;
                        // print("fullName $fullName");
                        print("imafe $imagePath");
                        // print("fullName $fullName");
                        // print("fullName $fullName");
                        // print("fullName $fullName");
                        setState(() {
                          isInAsyncCall = true;
                        });
                        await editUserProfileWidget();

                        if (updateProfileCustomerModel.status == "success") {
                          Future.delayed(const Duration(seconds: 3), () {
                            toastSuccessMessage("success", Colors.green);
                            // toastOTPMessage("${signUpModel.data![0].verifyCode}", Colors.green);
                            Get.to(() => bottom_bar(
                                  currentIndex: 0,
                                ));
                            setState(() {
                              isInAsyncCall = false;
                            });
                            print("false: $isInAsyncCall");
                          });
                        }
                        if (updateProfileCustomerModel.status != "success") {
                          toastFailedMessage(
                              updateProfileCustomerModel.message, Colors.red);
                          setState(() {
                            isInAsyncCall = false;
                          });
                        }
                      },
                      child: isInAsyncCall
                          ? loadingBar(context)
                          : mainButton(
                              "Update Profile", Color(0xff2B65EC), context),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }

  File? imagePath;
  String? base64img;

  Future pickCoverImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
      if (xFile == null) return;

      Uint8List imageByte = await xFile.readAsBytes();
      base64img = base64.encode(imageByte);
      print("base64img $base64img");

      final imageTemporary = File(xFile.path);

      setState(() {
        imagePath = imageTemporary;
        print("newImage $imagePath");
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: ${e.toString()}');
    }
  }
}
