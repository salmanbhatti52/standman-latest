import 'package:StandMan/Models/editJobByWalletOrStripe.dart';
import 'package:StandMan/Models/getprofile.dart';
import 'package:StandMan/Models/jobEditModels.dart';
import 'package:StandMan/Models/jobs_price_Model.dart';
import 'package:StandMan/Pages/Bottombar.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Pages/Customer/JobsPage/Edit%20Jobs%20Section/chargesSheet.dart';
import 'package:StandMan/Utils/api_urls.dart';
import 'package:StandMan/widgets/ToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/MyButton.dart';
import '../../../../widgets/TopBar.dart';
import 'package:http/http.dart' as http;

class EditJob extends StatefulWidget {
  final String? jobDate;
  final String? startTime;
  final String? endTime;
  final String? jobid;
  final String? charges;
  final String? price;
  final String? tax;
  final String? service_charges;
  EditJob(
      {Key? key,
      this.jobDate,
      this.startTime,
      this.endTime,
      this.charges,
      this.jobid,
      this.price,
      this.tax,
      this.service_charges})
      : super(key: key);

  @override
  State<EditJob> createState() => _EditJobState();
}

class _EditJobState extends State<EditJob> {
  JobEditModels jobEditModels = JobEditModels();
  bool isLoading = false;
  Editjobs() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("userId in Prefs is = $usersCustomersId");
    String apiUrl = "https://admin.standman.ca/api/edit_job";
    setState(() {
      isInAsyncCall = true;
    });
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "jobs_id": "${widget.jobid}",
        "job_date": "${selectedDate.toString()}",
        "start_time": "${startTime?.format(context)}",
        "end_time": "${endTime?.format(context)}",
        "price": "${widget.price}",
        "service_charges": "${widget.service_charges}",
        "tax": "${widget.tax}",
        "total_price": "${widget.charges}"
      },
    );
    final responseString = response.body;
    print("jobEditListModels: ${response.body}");
    print("status Code jobEditListModels: ${response.statusCode}");
    print("in 200 jobEditListModels");
    if (response.statusCode == 200) {
      jobEditModels = jobEditModelsFromJson(response.body);
      setState(() {
        isInAsyncCall = false;
      });

      if (jobEditModels.status == "success") {
        toastSuccessMessage("Job Edit SuccessFully", Colors.green);
        Get.to(() => bottom_bar(currentIndex: 0));
      } else {
        final status = jobEditModels.status ?? 'Unknown error';
        toastFailedMessage(status, Colors.red);
      }
    } else {
      // Handle non-200 status codes here
      toastFailedMessage(
          "Failed to edit job. Status code: ${response.statusCode}",
          Colors.red);
    }
  }

  EditJobWalletOrStripe editJobWalletOrStripe = EditJobWalletOrStripe();

  editJobByWallet() async {
    try {
      setState(() {
        isInAsyncCall = true;
      });
      print("working");
      String apiUrl = "https://admin.standman.ca/api/edit_job_other";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Accept": "application/json"},
        body: {
          "jobs_id": "${widget.jobid}",
          "job_date": "${selectedDate.toString()}",
          "start_time": startTime?.format(context),
          "end_time": endTime?.format(context),
          "price": "${jobsPriceModel.data!.price}",
          "service_charges": "${jobsPriceModel.data!.serviceCharges}",
          "tax": "${jobsPriceModel.data!.tax}",
          "total_price": "${jobsPriceModel.data!.totalPrice}",
          "extra_charges": "${formattedNumber}",
          "requestType": "payByWallet", // "refundAmount" or "payByWallet" or ""
          "transaction_id": ""
        },
      );
      final responseString = response.body;
      print("editJobByWallet: ${response.body}");
      print("status Code editJobByWallet: ${response.statusCode}");
      print("in 200 jobPrice");

      if (response.statusCode == 200) {
        editJobWalletOrStripe = editJobWalletOrStripeFromJson(response.body);
        print('editJobByWallet status: ${editJobWalletOrStripe.status}');

        if (editJobWalletOrStripe.status == "success") {
          toastSuccessMessage("Job Edit SuccessFully", Colors.green);
          Navigator.pop(context);
        } else {
          toastFailedMessage(editJobWalletOrStripe.status, Colors.red);
        }
      } else {
        toastFailedMessage("Failed to edit job", Colors.red);
      }
    } catch (e) {
      toastFailedMessage('An error occurred: $e', Colors.red);
    } finally {
      setState(() {
        isInAsyncCall = false;
      });
    }
  }

  editJobRefund() async {
    setState(() {
      isInAsyncCall = true;
    });
    print("working");
    String apiUrl = "https://admin.standman.ca/api/edit_job_other";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "jobs_id": "${widget.jobid}",
        "job_date": "${selectedDate.toString()}",
        "start_time": startTime?.format(context),
        "end_time": endTime?.format(context),
        "price": "${jobsPriceModel.data!.price}",
        "service_charges": "${jobsPriceModel.data!.serviceCharges}",
        "tax": "${jobsPriceModel.data!.tax}",
        "total_price": "${jobsPriceModel.data!.totalPrice}",
        "extra_charges": "${formattedNumber}",
        "requestType": "refundAmount", // "refundAmount" or "payByWallet" or ""
        "transaction_id": ""
      },
    );
    final responseString = response.body;
    print("editJobRefund: ${response.body}");
    print("status Code editJobRefund: ${response.statusCode}");
    print("in 200 jobPrice");
    if (response.statusCode == 200) {
      editJobWalletOrStripe = editJobWalletOrStripeFromJson(response.body);
      print('editJobRefund status: ${editJobWalletOrStripe.status}');

      if (editJobWalletOrStripe.status == "success") {
        toastSuccessMessage(
            "Job Edit SuccessFully & Amount Refunded to your Wallet",
            Colors.green);
        Navigator.pop(context);
      } else {
        toastFailedMessage(editJobWalletOrStripe.status, Colors.red);
      }
    } else {
      toastFailedMessage("Failed to refund amount", Colors.red);
    }
  }

  double? formattedNumber;
  String? extraCharges;
  String? payPrice;
  JobsPriceModel jobsPriceModel = JobsPriceModel();

  JobsPrice() async {
    setState(() {
      isInAsyncCall = true;
    });
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
      jobsPriceModel = jobsPriceModelFromJson(response.body);
      payPrice = jobsPriceModel.data!.totalPrice;

      double payPriceDouble = double.tryParse(payPrice ?? '0.0') ?? 0.0;
      double chargesDouble = double.tryParse(widget.charges ?? '0.0') ?? 0.0;

      double difference = payPriceDouble - chargesDouble;

      // Ensure extraCharges is not negative
      double extraCharges = difference > 0 ? difference : 0.0;

      formattedNumber = difference < 0 ? difference * -1 : difference;
      // Round to 2 decimal places

      print("difference ${difference}");
      print("extraCharges ${formattedNumber}");
      print("payPrice $payPrice");
    } else {
      toastFailedMessage("Failed to get job price", Colors.red);
    }
  }

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

      print('getProfileModels status: ${getProfile.status}');
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

  String? startTime24Hour;
  String? endTime24Hour;
// Example usage:
// Output: 15:30:00
  String convertTimeOfDayTo24HourFormat(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

// Example usage:
  // Output: 15:30:00

  final key = GlobalKey<FormState>();
  bool isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    getprofile();
    print("jobDate ${widget.jobDate}");
    print("TimeStart ${widget.startTime}");
    print("TimeEnd ${widget.endTime}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: StandManAppBar1(
        title: "Edit Job",
        bgcolor: Color(0xff2B65EC),
        titlecolor: Colors.white,
        iconcolor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when the user taps anywhere on the screen
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
              child: Column(
                children: [
                  Container(
                    child: Form(
                      key: key,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  width: MediaQuery.of(context).size.width,
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
                                        onTap: () {
                                          _selectDate(context);
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
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
                                SizedBox(
                                  height: Get.height * 0.02,
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
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus &&
                                    currentFocus.focusedChild != null) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                                if (key.currentState!.validate()) {
                                  if (selectedDate == null) {
                                    toastFailedMessage(
                                        'Date cannot be empty', Colors.red);
                                  } else if (formatTimeOfDay(startTime!) ==
                                      null) {
                                    toastFailedMessage(
                                        'Start Time cannot be empty',
                                        Colors.red);
                                  } else if (formatTimeOfDay(endTime!) ==
                                      null) {
                                    toastFailedMessage(
                                        'End Time cannot be empty', Colors.red);
                                  } else {
                                    setState(() {
                                      isInAsyncCall = true;
                                    });

                                    try {
                                      await JobsPrice();

                                      if (jobsPriceModel.status == "success") {
                                        String? charges = widget.charges;
                                        String? newCharges =
                                            jobsPriceModel.data!.totalPrice;

                                        if (charges == newCharges) {
                                          await Editjobs();
                                          if (jobEditModels.status ==
                                              "success") {
                                            toastSuccessMessage(
                                                "Job Edit SuccessFully",
                                                Colors.green);
                                            Get.to(() =>
                                                bottom_bar(currentIndex: 3));
                                            return; // Exit the function if EditJobs succeeds
                                          } else {
                                            Navigator.pop(context);
                                            // toastFailedMessage(
                                            //     jobEditModels.status ??
                                            //         'Unknown error',
                                            //     Colors.red);
                                          }
                                        } else if (charges != null &&
                                            newCharges != null) {
                                          double chargesDouble =
                                              double.tryParse(charges) ?? 0.0;
                                          double newChargesDouble =
                                              double.tryParse(newCharges) ??
                                                  0.0;

                                          if (newChargesDouble <=
                                              chargesDouble) {
                                            await editJobRefund();

                                            // Check if the refund was successful
                                            if (jobEditModels.status ==
                                                "success") {
                                              toastSuccessMessage(
                                                  "Job Edit SuccessFully & Amount Refunded to your Wallet",
                                                  Colors.green);
                                             Get.to(() =>
                                                bottom_bar(currentIndex: 3));
                                              return; // Exit the function after successful refund and navigation
                                            }
                                          } else {
                                            print(newChargesDouble -
                                                chargesDouble);
                                            ChargesSheet(
                                              ctx: context,
                                              extraCharges: (newChargesDouble -
                                                      chargesDouble)
                                                  .toString(),
                                              jobId: widget.jobid!,
                                              price: jobsPriceModel
                                                  .data?.totalPrice,
                                              amount:
                                                  jobsPriceModel.data?.price,
                                              chargers: jobsPriceModel
                                                  .data?.serviceCharges,
                                              tax: jobsPriceModel.data?.tax,
                                              serviceCharges: jobsPriceModel
                                                  .data!.serviceCharges,
                                              totalPrice: jobsPriceModel
                                                  .data?.totalPrice,
                                              date: selectedDate.toString(),
                                              time: startTime?.format(context),
                                              endtime: endTime?.format(context),
                                              total:
                                                  "${jobsPriceModel.data?.totalPrice}",
                                              wallet: double.tryParse(getProfile
                                                      .data!.walletAmount ??
                                                  ''),
                                            );
                                          }
                                        }
                                      } else {
                                        toastFailedMessage(
                                            jobsPriceModel.message, Colors.red);
                                      }
                                    } finally {
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
                                  : mainButton("Next",
                                      Color.fromRGBO(43, 101, 236, 1), context),
                            ),
                            SizedBox(
                              height: Get.height * 0.03,
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
