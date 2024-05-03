import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:StandMan/Models/customerDiscount.dart';
import 'package:StandMan/Models/getprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/jobs_create_Model.dart';
import '../../../../Models/jobs_price_Model.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/MyButton.dart';
import '../../../../widgets/ToastMessage.dart';
import '../../../../widgets/TopBar.dart';
import '../../HomePage/HomePage.dart';
import '../../HomePage/Estimated_Payment.dart';
import 'package:http/http.dart' as http;

class JobDetails extends StatefulWidget {
  String? address;
  String? currentaddress;
  String? currentaddress1;
  String? longitude;
  String? latitude;

  JobDetails(
      {Key? key,
      this.address,
      this.latitude,
      this.longitude,
      this.currentaddress,
      this.currentaddress1})
      : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  final key = GlobalKey<FormState>();
  TextEditingController jobName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController describeJob = TextEditingController();
  bool isInAsyncCall = false;
  bool isLoading = false;
  String? date1;
  // late TimeOfDay _time;
  // String valueTime = "Select";
  //
  // Future<Null> selectTime(BuildContext context) async {
  //   TimeOfDay? picked;
  //   picked = await showTimePicker(
  //
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked == null) {
  //     picked = _time;
  //   } else {
  //     valueTime = picked.format(context).toString();
  //     // valueTime = DateFormat.Hm().format(DateTime.now());
  //     // valueTime = DateFormat("hh:mm").format(DateTime.now());
  //     setState(() {
  //       print("Selected Time is : $valueTime");
  //     });
  //   }
  // }
  //
  // late TimeOfDay _Endtime;
  // String valueEndTime = "Select";
  //
  // Future<Null> selectEndTime(BuildContext context) async {
  //   TimeOfDay? picked;
  //   picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked == null) {
  //     picked = _Endtime;
  //   } else {
  //     valueEndTime = picked.format(context).toString();
  //     setState(() {
  //       print("Selected End Time is : $valueEndTime");
  //     });
  //   }
  // }
  //
  // TimeOfDay _selectedTime = TimeOfDay.now();
  //
  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime,
  //   );
  //
  //   // Check if a time was selected
  //   if (pickedTime != null) {
  //     // Check if the selected time is in the future
  //     if (_isTimeInFuture(pickedTime)) {
  //       setState(() {
  //         _selectedTime = pickedTime;
  //       });
  //     } else {
  //       // Show an error message or perform any other action
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Invalid Time'),
  //             content: Text('Please select a future time.'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text('OK'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }
  //
  // bool _isTimeInFuture(TimeOfDay time) {
  //   final now = DateTime.now();
  //   final selectedDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  //
  //   return selectedDateTime.isAfter(now);
  // }

  // JobsCreateModel jobsCreateModel = JobsCreateModel();
  //
  // jobCreated() async {
  //   print("working");
  //   prefs = await SharedPreferences.getInstance();
  //   usersCustomersId = prefs!.getString('usersCustomersId');
  //   print("userId in Prefs is = $usersCustomersId");
  //
  //   String apiUrl = jobsCreateModelApiUrl;
  //   print("working");
  //
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {"Accept": "application/json"},
  //     body: {
  //       "users_customers_id": usersCustomersId,
  //       "name": jobName.text.toString(),
  //       "location": widget.currentaddress.toString() == "" ? widget.currentaddress1.toString() : widget.currentaddress.toString(),
  //       "longitude": widget.longitude,
  //       "lattitude": widget.latitude,
  //       "start_date": selectedDate.toString(),
  //       "start_time": startTime?.format(context),
  //       "end_time": endTime?.format(context),
  //       "description": describeJob.text.toString(),
  //       "payment_gateways_name": "GPay",
  //       "payment_status": "Paid",
  //       "image": base64ID,
  //     },
  //   );
  //   final responseString = response.body;
  //   print("jobsCreateModelApi: ${response.body}");
  //   print("status Code jobsCreateModel: ${response.statusCode}");
  //   print("in 200 jobsCreate");
  //   if (response.statusCode == 200) {
  //     jobsCreateModel = jobsCreateModelFromJson(responseString);
  //     // setState(() {});
  //     print('jobsCreateModel status: ${jobsCreateModel.status}');
  //   }
  //   Future.delayed(const Duration(seconds: 2),
  //           () {
  //         Estimated_PaymentMethod(
  //             ctx: context,
  //             price: jobsCreateModel.data?.totalPrice,
  //             amount: jobsCreateModel.data?.price,
  //             chargers: jobsCreateModel.data?.serviceCharges,
  //             tax: jobsCreateModel.data?.tax);
  //       });
  // }
  double? finecharges;
  GetProfile getProfile = GetProfile();
  getprofile() async {
    // try {

    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");

    String apiUrl = usersProfileApiUrl;
    print("getUserProfileApi: $apiUrl");

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
    }, body: {
      "users_customers_id": usersCustomersId.toString(),
    });
    final responseString = response.body;
    print("response getProfileModels: $responseString");
    print("status Code getProfileModels: ${response.statusCode}");
    print("in 200 getCountrygetProfileModelsListModels");
    if (response.statusCode == 200) {
      print("SuccessFull");
      getProfile = getProfileFromJson(responseString);
      double? wallet = double.tryParse(getProfile.data!.walletAmount!);
      if (wallet != null && wallet < 0) {
        finecharges = wallet.abs();
      }
      print("finecharges $finecharges");

      print('getProfileModels status: ${getProfile.status}');
    }
  }

  CustomerDiscount customerDiscount = CustomerDiscount();

  discountAPI() async {
    // try {

    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");

    String apiUrl = "https://admin.standman.ca/api/is_discount_applicable";
    print("is_discount_applicable: $apiUrl");

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
    }, body: {
      "users_customers_id": usersCustomersId.toString(),
    });
    final responseString = response.body;
    print("response is_discount_applicable: $responseString");
    print("status Code is_discount_applicable: ${response.statusCode}");
    print("in 200 is_discount_applicable");
    if (response.statusCode == 200) {
      print("SuccessFull");
      customerDiscount = customerDiscountFromJson(responseString);

      print('is_discount_applicable status: ${customerDiscount.status}');
    }
  }

  String? discountPercentAge;
  double? tex;
  double? serviceCharges;

  Future<String?> fetchSystemSettingsDescription28() async {
    final String apiUrl = 'https://admin.standman.ca/api/get_system_settings';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Find the setting with system_settings_id equal to 26
        final setting31 = data['data'].firstWhere(
            (setting) => setting['system_settings_id'] == 31,
            orElse: () => null);
        final setting24 = data['data'].firstWhere(
            (setting) => setting['system_settings_id'] == 24,
            orElse: () => null);
        final setting21 = data['data'].firstWhere(
            (setting) => setting['system_settings_id'] == 21,
            orElse: () => null);

        if (setting31 != null && setting24 != null && setting21 != null) {
          // Extract and return the description if setting 28 exists
          discountPercentAge = setting31['description'];
          tex = double.parse(setting24['description']);
          serviceCharges = double.parse(setting21['description']);

          return discountPercentAge;
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

  @override
  void initState() {
    discountAPI();
    // TODO: implement initState
    super.initState();
    // sharePref();
    getprofile();
    print(widget.address);
    print(widget.latitude);
    print(widget.longitude);
    print(widget.currentaddress);
    print(widget.currentaddress1);
    fetchSystemSettingsDescription28();
  }

  JobsPriceModel jobsPriceModel = JobsPriceModel();

  JobsPrice() async {
    // setState(() {
    //   isLoading = true;
    // });
    print("working");
    String apiUrl = jobsPriceModelApiUrl;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "start_time": startTime?.format(context),
        "end_time": endTime?.format(context),
      },
    );
    final responseString = response.body;
    print("jobPriceModelApi: ${response.body}");
    print("status Code jobPriceModel: ${response.statusCode}");
    print("in 200 jobPrice");
    if (response.statusCode == 200) {
      jobsPriceModel = jobsPriceModelFromJson(responseString);
      // setState(() {});
      print('jobsCreateModel status: ${jobsPriceModel.status}');
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  String generateRandomNumbers(int count) {
    Random random = Random();
    String numbers = '';

    for (int i = 0; i < count; i++) {
      int randomNumber =
          random.nextInt(10); // Generate random number between 0 and 9
      numbers += randomNumber.toString();
    }

    return numbers;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when the user taps anywhere on the screen
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: StandManAppBar1(
          title: "Job Details",
          bgcolor: Colors.white,
          titlecolor: Colors.black,
          iconcolor: Colors.black,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
              child: Column(
                children: [
                  Container(
                    child: Form(
                      key: key,
                      child: SingleChildScrollView(
                        // physics: BouncingScrollPhysics(),
                        // physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, bottom: 0),
                                  child: SvgPicture.asset(
                                    'assets/images/locationfill.svg',
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.currentaddress.toString() == ""
                                        ? widget.currentaddress1.toString()
                                        : widget.currentaddress.toString(),
                                    // "No 15 uti street off ovie palace road effurun\ndelta state",
                                    style: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            // Container(
                            //   width: width * 0.9,
                            //   height: height * 0.17,
                            //   // width: 330,
                            //   // height: 139,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(12),
                            //     color: Color(0xffF3F3F3),
                            //   ),
                            //   child: Center(child: SvgPicture.asset("assets/images/uploadimage.svg", width: 75, height: 52,)),
                            // ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                // width: width * 0.9,
                                height: height * 0.2,
                                // width: 330,
                                // height: 139,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xffF3F3F3),
                                ),
                                child: uploadimg == null
                                    ? GestureDetector(
                                        onTap: () {
                                          pickUploadId();
                                        },
                                        child: Center(
                                            child: SvgPicture.asset(
                                          "assets/images/uploadimage.svg",
                                          width: 75,
                                          height: 52,
                                        )))
                                    : Image.file(
                                        uploadimg!,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                const Text(
                                  "Name",
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
                                  controller: jobName,
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
                                    hintText: "Name your job post (Optional)",
                                    hintStyle: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
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
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                const Text(
                                  "Job Date",
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
                                // TextFormField(
                                //   controller: date,
                                //   textAlign: TextAlign.left,
                                //   style: const TextStyle(
                                //     color: Color.fromRGBO(167, 169, 183, 1),
                                //     fontFamily: "Outfit",
                                //     fontWeight: FontWeight.w300,
                                //     fontSize: 14,
                                //   ),
                                //   keyboardType: TextInputType.number,
                                //   decoration: InputDecoration(
                                //     // contentPadding: const EdgeInsets.only(top: 12.0),
                                //     hintText: "Select Date",
                                //     hintStyle: const TextStyle(
                                //       color: Color.fromRGBO(167, 169, 183, 1),
                                //       fontFamily: "Outfit",
                                //       fontWeight: FontWeight.w300,
                                //       fontSize: 14,
                                //     ),
                                //     suffixIcon: Padding(
                                //       padding: const EdgeInsets.all(12.0),
                                //       child: GestureDetector(
                                //         onTap: (){
                                //
                                //         },
                                //         child: SvgPicture.asset(
                                //             "assets/images/note.svg"),
                                //       ),
                                //     ),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //       borderSide: const BorderSide(
                                //         color: Color.fromRGBO(243, 243, 243, 1),
                                //         width: 1.0,
                                //       ),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //       borderSide: const BorderSide(
                                //         color: Color.fromRGBO(243, 243, 243, 1),
                                //         width: 1.0,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                Container(
                                  width: width,
                                  height: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color.fromRGBO(243, 243, 243, 1),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedDate != null
                                            ? '${selectedDate.toString().split(' ')[0]}'
                                            : 'Select Date',
                                        style: TextStyle(
                                          color: selectedDate != null
                                              ? Colors.black
                                              : Color.fromRGBO(
                                                  167, 169, 183, 1),
                                          fontFamily: "Outfit",
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
                                        ),
                                      ),
                                      //     hintStyle: const

                                      InkWell(
                                        onTap: () async {
                                          await _selectDate(context);
                                          print(selectedDate);
                                          date1 =
                                              "${selectedDate.toString().split(' ')[0]}";
                                          print(date1);
                                        },
                                        child:
                                            // Text(
                                            //   valueDate,
                                            //   style: TextStyle(
                                            //       color: valueDate == "Select"
                                            //           ? Colors.green
                                            //           : Colors.black, fontSize: 16 ),
                                            // ),
                                            SvgPicture.asset(
                                                "assets/images/note.svg"),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start Time",
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: "Outfit",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            // letterSpacing: -0.3,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        GestureDetector(
                                            onTap: () =>
                                                _selectStartTime(context),
                                            // onTap: () => selectTime(context),
                                            child: dateContainer(
                                              size,
                                              startTime != null
                                                  ? '${formatTimeOfDay(startTime!)}'
                                                  : 'Start Time',
                                              // valueTime.toString(),
                                              // _selectedTime.format(context),
                                              Icons.calendar_today,
                                            )),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "End Time",
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: "Outfit",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            // letterSpacing: -0.3,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        GestureDetector(
                                            onTap: () =>
                                                _selectEndTime(context),
                                            // onTap: () => _EndSelectTime(context),
                                            child: dateContainer(
                                                size,
                                                // ' ${_endSelectedTime.format(context)}',
                                                endTime != null
                                                    ? '${formatTimeOfDay(endTime!)}'
                                                    : 'End Time',
                                                Icons.calendar_today)),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Text(
                                  "These times are approximate and will be adjusted on the bill based on the registered"
                                  " time when a StandMan starts and when the Customer confirms the job is completed",
                                  style: TextStyle(
                                    color: Color(0xffC70000).withOpacity(0.5),
                                    fontFamily: "Outfit",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                // const Text(
                                //   "Price",
                                //   style: TextStyle(
                                //     color: Color.fromRGBO(0, 0, 0, 1),
                                //     fontFamily: "Outfit",
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w400,
                                //     // letterSpacing: -0.3,
                                //   ),
                                //   textAlign: TextAlign.left,
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // TextFormField(
                                //   controller: price,
                                //   textAlign: TextAlign.left,
                                //   style: const TextStyle(
                                //     color: Color.fromRGBO(167, 169, 183, 1),
                                //     fontFamily: "Outfit",
                                //     fontWeight: FontWeight.w300,
                                //     fontSize: 14,
                                //   ),
                                //   keyboardType: TextInputType.number,
                                //   decoration: InputDecoration(
                                //     // contentPadding: const EdgeInsets.only(top: 12.0),
                                //     hintText: "Enter Price you want to offer",
                                //     hintStyle: const TextStyle(
                                //       color: Color.fromRGBO(167, 169, 183, 1),
                                //       fontFamily: "Outfit",
                                //       fontWeight: FontWeight.w300,
                                //       fontSize: 14,
                                //     ),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //       borderSide: const BorderSide(
                                //         color: Color.fromRGBO(243, 243, 243, 1),
                                //         width: 1.0,
                                //       ),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(12),
                                //       borderSide: const BorderSide(
                                //         color: Color.fromRGBO(243, 243, 243, 1),
                                //         width: 1.0,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: height * 0.02,
                                // ),
                                const Text(
                                  "Special Instructions",
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
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Color.fromRGBO(243, 243, 243, 1),
                                        width: 1.0,
                                      )),
                                  height: height * 0.12, // 97,
                                  child: TextField(
                                    maxLines: null,
                                    controller: describeJob,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(167, 169, 183, 1),
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                          top: 0.0, left: 12),
                                      hintText: "Enter here.....",
                                      hintStyle: const TextStyle(
                                        color: Color.fromRGBO(167, 169, 183, 1),
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  print(
                                      "${selectedDate.toString().split(' ')[0]}");
                                  final currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus &&
                                      currentFocus.focusedChild != null) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                  if (key.currentState!.validate()) {
                                    // if (jobName.text.isEmpty) {
                                    //   toastFailedMessage(
                                    //       'JobName cannot be empty',
                                    //       Colors.red);
                                    // } else
                                    if (selectedDate?.toString() == null) {
                                      toastFailedMessage(
                                          'Date cannot be empty', Colors.red);
                                    } else if (startTime == null) {
                                      // Check if startTime is null before calling formatTimeOfDay
                                      toastFailedMessage(
                                          'Start Time cannot be empty',
                                          Colors.red);
                                    } else if (endTime == null) {
                                      // Check if endTime is null before calling formatTimeOfDay
                                      toastFailedMessage(
                                          'End Time cannot be empty',
                                          Colors.red);
                                    }
                                    // else if (price.text.isEmpty) {
                                    //   toastFailedMessage(
                                    //       'Price cannot be empty', Colors.red);
                                    // }
                                    // else if (describeJob.text.isEmpty) {
                                    //   toastFailedMessage(
                                    //       'Description cannot be empty',
                                    //       Colors.red);
                                    // }
                                    // else if (base64ID == null) {
                                    //     toastFailedMessage(
                                    //         'Image required', Colors.red);
                                    //   }
                                    else {
                                      print(
                                          "users_customers_id: ${usersCustomersId}");
                                      print("jobName: ${jobName.text}");
                                      // print("name123: ${usersProfileModel.data!.fullName}");
                                      print(
                                          "location: ${widget.currentaddress.toString() == "" ? widget.currentaddress1.toString() : widget.currentaddress.toString()}");
                                      print("longitude: ${widget.longitude}");
                                      print("lattitude: ${widget.latitude}");
                                      print(
                                          "Job Date: ${selectedDate.toString().split(' ')[0]}");
                                      print(
                                          "start_time: ${formatTimeOfDay(startTime!)}");
                                      print(
                                          "end_time: ${formatTimeOfDay(endTime!)}");
                                      print(
                                          "description: ${describeJob.text.toString()}");

                                      print("image: ${base64ID}");

                                      // SharedPreferences sharedPref = await SharedPreferences.getInstance();
                                      // await sharedPref.setString('longitude', "${widget.longitude}");
                                      // await sharedPref.setString('lattitude', "${widget.latitude}");

                                      setState(() {
                                        isInAsyncCall = true;
                                      });
                                      await JobsPrice();

                                      String randomNumbers =
                                          generateRandomNumbers(5);
                                      print("randomNumbers ${randomNumbers}");

                                      if (jobsPriceModel.status == "success") {
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          Estimated_PaymentMethod(
                                              ctx: context,
                                              serviceCharges: serviceCharges,
                                              finecharges: finecharges,
                                              tex: tex,
                                              discountPercentAge:
                                                  discountPercentAge,
                                              discountApplicable:
                                                  customerDiscount
                                                      .data!.discountApplicable,
                                              randomNumbers:
                                                  randomNumbers.toString(),
                                              price: jobsPriceModel
                                                  .data?.totalPrice,
                                              amount:
                                                  jobsPriceModel.data?.price,
                                              chargers: jobsPriceModel
                                                  .data?.serviceCharges,
                                              tax: jobsPriceModel.data?.tax,
                                              img: base64ID,
                                              jobName: jobName.text,
                                              date:
                                                  "${selectedDate.toString().split(' ')[0]}",
                                              time: startTime?.format(context),
                                              endtime: endTime?.format(context),
                                              describe:
                                                  describeJob.text.toString(),
                                              address: widget.currentaddress
                                                          .toString() ==
                                                      ""
                                                  ? widget.currentaddress1
                                                      .toString()
                                                  : widget.currentaddress
                                                      .toString(),
                                              long: widget.longitude,
                                              lat: widget.latitude,
                                              total:
                                                  "${jobsPriceModel.data?.totalPrice}",
                                              wallet: double.tryParse(getProfile
                                                      .data!.walletAmount ??
                                                  ''));
                                        });
                                        setState(() {
                                          isInAsyncCall = false;
                                        });
                                      }
                                      if (jobsPriceModel.status != "success") {
                                        toastFailedMessage(
                                            jobsPriceModel.message, Colors.red);
                                        setState(() {
                                          isInAsyncCall = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: isInAsyncCall
                                    ? mainButton(
                                        "Please wait", Colors.grey, context)
                                    : mainButton(
                                        "Next",
                                        Color.fromRGBO(43, 101, 236, 1),
                                        context)),
                            SizedBox(
                              height: height * 0.03,
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
        ),
      ),
    );
  }

  File? uploadimg;
  String? base64ID;

  Future pickUploadId() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
      if (xFile == null) return;

      Uint8List imageByte = await xFile.readAsBytes();
      base64ID = base64.encode(imageByte);
      print("base64ID $base64ID");

      final imageTemporary = File(xFile.path);

      setState(() {
        uploadimg = imageTemporary;
        print("newImage $uploadimg");
      });
    } on PlatformException catch (e) {
      print('Failed to pick uploadID: ${e.toString()}');
    }
  }

//   DateTime? pickDate;
//   String valueDate = "Select Date";
//
//   _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       // firstDate: DateTime(2000),
//       lastDate: DateTime(2025),
//       // firstDate: DateTime(1980),
//       firstDate: DateTime.now().subtract(Duration(days: 0)),
//     );
//     if (picked != null && picked != pickDate) {
//     // print("time: ${tdata}");
// valueDate = DateFormat('yyyy-MM-dd').format(picked);
//   // tdata  = DateFormat("hh:mm").format(DateTime.now());
//       setState(() {
//         print("Selected Date is : $valueDate");
//         // print("Selected time is : $tdata");
//       });
//     }
//   }

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        startTime = null;
        endTime = null;
      });
    }
  }

  // Future<void> _selectStartTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (pickedTime != null) {
  //     final DateTime selectedDateTime = DateTime(
  //       selectedDate!.year,
  //       selectedDate!.month,
  //       selectedDate!.day,
  //       pickedTime.hour,
  //       pickedTime.minute,
  //     );
  //
  //     if (selectedDateTime.isBefore(DateTime.now())) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Invalid Time'),
  //             content: Text('Please select a future time.'),
  //             actions: [
  //               ElevatedButton(
  //                 child: Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       setState(() {
  //         startTime = pickedTime;
  //       });
  //     }
  //   }
  // }

  Future<TimeOfDay?> showCustomTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showCustomTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final DateTime selectedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (selectedDateTime.isBefore(DateTime.now())) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Time'),
              content: Text('Please select a future time.'),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          startTime = pickedTime;
        });
      }
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showCustomTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final DateTime startDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        startTime!.hour,
        startTime!.minute,
      );
      final DateTime endDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Time'),
              content: Text('End time must be greater than start time.'),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          endTime = pickedTime;
        });
      }
    }
  }

// Function to format the time in 12-hour clock format with AM/PM
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  // DateTime? selectedDate;
  // TimeOfDay? startTime;
  // TimeOfDay? endTime;
  //
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //       startTime = null;
  //       endTime = null;
  //     });
  //   }
  // }
  //
  // Future<void> _selectStartTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (pickedTime != null) {
  //     final DateTime selectedDateTime = DateTime(
  //       selectedDate!.year,
  //       selectedDate!.month,
  //       selectedDate!.day,
  //       pickedTime.hour,
  //       pickedTime.minute,
  //     );
  //
  //     if (selectedDateTime.isBefore(DateTime.now())) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Invalid Time'),
  //             content: Text('Please select a future time.'),
  //             actions: [
  //               ElevatedButton(
  //                 child: Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       setState(() {
  //         startTime = pickedTime;
  //       });
  //     }
  //   }
  // }
  //
  // Future<void> _selectEndTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (pickedTime != null) {
  //     final DateTime startDateTime = DateTime(
  //       selectedDate!.year,
  //       selectedDate!.month,
  //       selectedDate!.day,
  //       startTime!.hour,
  //       startTime!.minute,
  //     );
  //     final DateTime endDateTime = DateTime(
  //       selectedDate!.year,
  //       selectedDate!.month,
  //       selectedDate!.day,
  //       pickedTime.hour,
  //       pickedTime.minute,
  //     );
  //
  //     if (endDateTime.isBefore(startDateTime)) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Invalid Time'),
  //             content: Text('End time must be greater than start time.'),
  //             actions: [
  //               ElevatedButton(
  //                 child: Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       setState(() {
  //         endTime = pickedTime;
  //       });
  //     }
  //   }
  // }

  Widget dateContainer(size, text, icon) {
    return Container(
      height: 50,
      width: size.width / 2.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color.fromRGBO(243, 243, 243, 1),
            width: 1.0,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, size: 12, color: Colors.black),
          Text(text,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black)),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 18,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
