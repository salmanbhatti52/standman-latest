import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/ToastMessage.dart';
import '../../../widgets/social_button.dart';
import '../../TermConditions.dart';
import '../Login_tab_class.dart';
import 'Emp_UploadPhoto.dart';

class EmployeeSignUpPage extends StatefulWidget {
  const EmployeeSignUpPage({Key? key}) : super(key: key);

  @override
  State<EmployeeSignUpPage> createState() => _EmployeeSignUpPageState();
}

class _EmployeeSignUpPageState extends State<EmployeeSignUpPage> {
  final firstNameController = TextEditingController();
  final lastController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final key = GlobalKey<FormState>();
  bool isPasswordObscure = true;
  bool isPasswordConfirmObscure = true;
  bool isInAsyncCall = false;
  String countryCode = '';

  void onCountryChange(PhoneNumber number) {
    setState(() {
      countryCode = number.countryISOCode;
      print("countryCode ${countryCode}");
    });
  }

  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();
  bool required = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: key,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: height * 0.08,
                                backgroundColor: Colors.transparent,
                                backgroundImage: imagePath == null
                                    ? AssetImage(
                                        "assets/images/fade_in_image.jpeg",
                                      )
                                    : Image.file(
                                        imagePath!,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.contain,
                                      ).image,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: width * 0.37, //150,
                              child: GestureDetector(
                                onTap: () async {
                                  // pickCoverImage();
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
                                            width: 350,
                                            height: height * 0.3, // 321,
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
                                                  GestureDetector(
                                                      onTap: () {
                                                        pickImageGallery();
                                                        Get.back();
                                                      },
                                                      child: mainButton(
                                                          "PICK FROM GALLERY",
                                                          Color(0xff2B65EC),
                                                          context)),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        pickImageCamera();

                                                        Get.back();
                                                      },
                                                      child: mainButton(
                                                          "PICK FROM CAMERA",
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
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: Color(0xff1D272F),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                  ),
                                  child: Center(
                                      child: SvgPicture.asset(
                                          "assets/images/camera.svg")),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: width,
                          // height: height * 0.55,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                const Text(
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
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: firstNameController,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(167, 169, 183, 1),
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    // contentPadding: const EdgeInsets.only(top: 12.0),
                                    hintText: "Enter your first name",
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SvgPicture.asset(
                                          "assets/images/profile.svg"),
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
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                const Text(
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
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: lastController,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(167, 169, 183, 1),
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    // contentPadding: const EdgeInsets.only(top: 12.0),
                                    hintText: "Enter your last name",
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SvgPicture.asset(
                                          "assets/images/profile.svg"),
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
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Text(
                                  "*Must Match the Government-Issued ID",
                                  style: TextStyle(
                                    color: Color(0xffC70000),
                                    fontFamily: "Outfit",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
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
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, left: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: IntlPhoneField(
                                          dropdownTextStyle: const TextStyle(
                                              color: Color(0xFF000000)),
                                          cursorColor: const Color(0xFF000000),
                                          controller: phoneController,
                                          style: const TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 16),
                                          decoration: InputDecoration(
                                            prefixStyle: const TextStyle(
                                              color: Color(0xFFF3F3F3),
                                            ),
                                            labelStyle: const TextStyle(
                                                color: Colors.white),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF2B65EC)),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            // labelText: 'Email',
                                            hintText: "Phone Number",
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  color: Color(
                                                      0xFFF3F3F3)), // change border color
                                            ),

                                            hintStyle: const TextStyle(
                                                color: Color(0xFFA7A9B7),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: "Satoshi"),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          initialCountryCode:
                                              'US', // You can set your initial country code (will be set as +91 for India)
                                          onChanged: (phone) {
                                            // Prints "+911234567890"
                                            phoneNumber = phone.completeNumber;
                                            print(phoneNumber);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Text(
                                  "Email Address",
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: "Outfit",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    // letterSpacing: -0.3,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: emailController,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(167, 169, 183, 1),
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    return RegExp(
                                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                            .hasMatch(val!)
                                        ? null
                                        : "Please enter correct Email";
                                  },
                                  decoration: InputDecoration(
                                    // contentPadding: const EdgeInsets.only(top: 12.0),
                                    hintText: "Enter your email address",

                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SvgPicture.asset(
                                          "assets/images/email.svg"),
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
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                const Text(
                                  "Password",
                                  style: TextStyle(
                                    color: Color.fromRGBO(25, 29, 49, 1),
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
                                  controller: passwordController,
                                  onTap: () {
                                    setState(() {
                                      required = true;
                                    });
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(167, 169, 183, 1),
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                  validator: (val) {
                                    return RegExp(
                                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                            .hasMatch(val!)
                                        ? null
                                        : "Password must be at least 8 characters and  Must have\n Atleast 1 uppercase & lowercase letter & 1 number";
                                  },
                                  obscureText: isPasswordObscure,
                                  obscuringCharacter: '*',
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Create Password",
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
                                        setState(() {
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
                                        setState(() {
                                          isPasswordObscure =
                                              !isPasswordObscure;
                                        });
                                      },
                                    ),
                                    enabledBorder: OutlineInputBorder(
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
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                if (required == true)
                                  new FlutterPwValidator(
                                    defaultColor: Color(0xffEA4335),
                                    failureColor: Color(0xffEA4335),
                                    successColor: Color(0xff4267B2),
                                    key: validatorKey,
                                    controller: passwordController,
                                    minLength: 8,
                                    uppercaseCharCount: 1,
                                    numericCharCount: 1,
                                    specialCharCount: 1,
                                    normalCharCount: 1,
                                    width: 400,
                                    height: 160,
                                    onSuccess: () {
                                      print("MATCHED");
                                    },
                                    onFail: () {
                                      print("NOT MATCHED");
                                    },
                                  ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                const Text(
                                  "Confirm Password",
                                  style: TextStyle(
                                    color: Color.fromRGBO(25, 29, 49, 1),
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
                                  controller: passwordConfirmController,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(167, 169, 183, 1),
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty)
                                      return 'Please enter confirm password';
                                    if (val != passwordController.text)
                                      return "Password don't match";
                                    return null;
                                  },
                                  obscureText: isPasswordConfirmObscure,
                                  obscuringCharacter: '*',
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Confirm Password",
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
                                          isPasswordConfirmObscure
                                              ? "assets/images/lock.svg"
                                              : "assets/images/lock.svg",
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isPasswordConfirmObscure =
                                              !isPasswordConfirmObscure;
                                        });
                                      },
                                    ),
                                    suffixIcon: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          isPasswordConfirmObscure
                                              ? "assets/images/eye.svg"
                                              : "assets/images/eye.svg",
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isPasswordConfirmObscure =
                                              !isPasswordConfirmObscure;
                                        });
                                      },
                                    ),
                                    enabledBorder: OutlineInputBorder(
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: width * 0.15, top: 10),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                () => TermsandConditions(),
                                transition: Transition.upToDown,
                                duration: Duration(milliseconds: 350),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                  text: "By Clicking Next, you agree to our ",
                                  style: TextStyle(
                                      fontFamily: "Outfit",
                                      fontSize: 14,
                                      color: Color.fromRGBO(34, 34, 34, 0.5),
                                      fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Terms and\nPolicy",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontFamily: "Outfit",
                                          fontSize: 14,
                                          color: Color(0xff2B65EC),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text: " that you have read.",
                                      style: TextStyle(
                                          fontFamily: "Outfit",
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(34, 34, 34, 0.5),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        GestureDetector(
                            onTap: () async {
                              if (key.currentState!.validate()) {
                                if (firstNameController.text.isEmpty) {
                                  toastFailedMessage(
                                      'First Name cannot be empty', Colors.red);
                                } else if (lastController.text.isEmpty) {
                                  toastFailedMessage(
                                      'Last Name cannot be empty', Colors.red);
                                } else if (phoneController.text.isEmpty) {
                                  toastFailedMessage(
                                      'phone number cannot be empty',
                                      Colors.red);
                                } else if (emailController.text.isEmpty) {
                                  toastFailedMessage(
                                      'email cannot be empty', Colors.red);
                                } else if (passwordController.text.length < 8) {
                                  toastFailedMessage(
                                      'password must be 8 digit', Colors.red);
                                } else if (passwordConfirmController
                                        .text.length <
                                    8) {
                                  toastFailedMessage(
                                      'Confirm password must be 8 digit',
                                      Colors.red);
                                } else if (base64img == null) {
                                  toastFailedMessage(
                                      'Please provide a photo of yourself.',
                                      Colors.red);
                                } else {
                                  Get.to(
                                    () => EMp_UploadPhoto(
                                      profileimg: base64img,
                                      firstname:
                                          firstNameController.text.toString(),
                                      lastname: lastController.text.toString(),
                                      email: emailController.text.toString(),
                                      phonenumber: phoneNumber.toString(),
                                      selectedCountryCode:
                                          countryCode.toString(),
                                      password:
                                          passwordController.text.toString(),
                                      passwordConfirm: passwordConfirmController
                                          .text
                                          .toString(),
                                    ),
                                    transition: Transition.rightToLeftWithFade,
                                    duration: Duration(milliseconds: 250),
                                  );
                                }
                              }
                              //
                            },
                            child: mainButton("Next",
                                Color.fromRGBO(43, 101, 236, 1), context)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            "OR",
                            style: TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 14,
                                color: Color.fromRGBO(167, 169, 183, 1),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        socialButton(context),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Color(0xffA7A9B7),
                                  fontFamily: "Outfit",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  // letterSpacing: -0.3,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(
                                    () => LoginTabClass(
                                      login: 1,
                                    ),
                                    transition: Transition.upToDown,
                                    duration: Duration(milliseconds: 350),
                                  );
                                },
                                child: const Text(
                                  'Sign In here',
                                  style: TextStyle(
                                    color: Color(0xff2B65EC),
                                    fontFamily: "Outfit",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    // letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
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
    );
  }

  String? phoneNumber;
  File? imagePath;
  String? base64img;
  Future pickImageGallery() async {
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

  Future pickImageCamera() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? xFile = await _picker.pickImage(source: ImageSource.camera);
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
