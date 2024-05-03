import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:StandMan/Models/getMessageLiveModel.dart';
import 'package:StandMan/Models/get_messge_Model.dart';
import 'package:StandMan/Models/sendMessageModels.dart';
import 'package:StandMan/Pages/Bottombar.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Utils/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminChat extends StatefulWidget {
  const AdminChat({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminChat> createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {
  bool loading = false;
  var sendMessageController = TextEditingController();
  GetMessageLiveModel getMessageLiveModel = GetMessageLiveModel();
  final GlobalKey<FormState> sendMessageFormKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();

  sendMessageApiWidget() async {
    setState(() {
      loading = true;
    });

    prefs = await SharedPreferences.getInstance();
    adminID = prefs!.getString('adminID');
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");
    print("getAdmin = $adminID");

    Map body = {
      "requestType": "sendMessage",
      "users_type": "Customer",
      "message_type": "text",
      "users_id": usersCustomersId,
      "other_users_id": adminID,
      "message": sendMessageController.text,
    };
    http.Response response = await http.post(Uri.parse(sendMessageLiveApiUrl),
        body: body, headers: {"Accept": "application/json"});
    Map jsonData = jsonDecode(response.body);
    print("sendMessageApiUrl: $sendMessageLiveApiUrl");
    print("sendMessageText: ${sendMessageController.text}");
    print('sendMessageApiResponse $jsonData');
    if (jsonData['message'] == 'Message sent successfully.') {
      // toastSuccessMessage("Message sent.", Colors.green);
      print('Message sent successfully.');
      setState(() {
        loading = false;
        getMessageApi();
      });
    }
  }

  // Declare a timer variable
  Timer? timer;

  void startTimer() {
    // Start the timer and call getMessageApi() every 1 second
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      getMessageApi();
    });
  }

  void cancelTimer() {
    // Cancel the timer if it's active
    timer?.cancel();
  }

// Call this function when the user enters the page
  void onPageEnter() {
    // Start the timer to call getMessageApi() every 1 second
    startTimer();
  }

// Call this function when the user leaves the page
  void onPageExit() {
    // Cancel the timer to stop calling getMessageApi()
    cancelTimer();
  }

  getMessageApi() async {
    // setState(() {
    //   loading = true;
    // });
    prefs = await SharedPreferences.getInstance();
    adminID = prefs!.getString('adminID');
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");
    print("getAdmin = $adminID");

    String apiUrl = getMessageLiveApiUrl;
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "requestType": "getMessages",
        "users_id": usersCustomersId,
        "other_users_id": adminID,
      },
    );
    final responseString = response.body;
    print("getMessgeLiveModelApiUrl: ${response.body}");
    print("status Code getMessgeModelLive: ${response.statusCode}");
    print("in 200 getMessgeModelLive");
    if (response.statusCode == 200) {
      getMessageLiveModel = getMessageLiveModelFromJson(responseString);
      print('getMessgemodel status: ${getMessageLiveModel.status}');
      print('getMessgemodel message: ${getMessageLiveModel.data?[0].message}');
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  sharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("userId in Prefs is = $usersCustomersId");
    prefs = await SharedPreferences.getInstance();
    adminID = prefs!.getString('adminID');
    adminName = prefs!.getString('adminName');
    adminImage = prefs!.getString('adminImage');
    print("User Image: $adminImage");
    print("Admin ID: $adminID");
    print("First Name: $adminName");
    setState(() {
      getMessageApi();
    });
  }

  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    onPageExit();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    onPageEnter();
    _scrollController = ScrollController();
    sharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            onPageExit();
            Get.to(() => bottom_bar(
                  currentIndex: 0,
                ));
          },
          child: Center(
              child: SvgPicture.asset(
            "assets/images/left.svg",
          )),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 05),
          child: ListTile(
            title: Text(
              // fullName!,
              // g.data![index].usersData!.fullName.toString(),
              "${adminName}",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Outfit",
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage("${adminImage}"),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ListView.builder(
                  reverse: true, // To show the latest messages at the bottom
                  itemCount: getMessageLiveModel.data != null
                      ? getMessageLiveModel.data!.length
                      : 0,
                  itemBuilder: (context, index) {
                    int revers = getMessageLiveModel.data!.length - 1 - index;
                    final message = getMessageLiveModel.data![revers].message;
                    final imagemessage =
                        getMessageLiveModel.data![revers].messageType ==
                            "attachment";

                    final isMyMessage = getMessageLiveModel
                            .data![revers].senderData?.usersCustomersId
                            .toString() ==
                        usersCustomersId;

                    print(
                        "SenderId :${getMessageLiveModel.data![revers].senderData?.usersCustomersId}");
                    print(
                        "reciver Id: ${getMessageLiveModel.data![revers].receiverData!.usersSystemId}");

                    DateTime inputTime =
                        getMessageLiveModel.data![revers].dateAdded!;
                    DateTime inputDate =
                        getMessageLiveModel.data![revers].dateAdded!;
                    // DateFormat inputFormat = DateFormat("H:mm:ss");
                    DateFormat outputFormat = DateFormat("h:mm a");
                    DateFormat outputDateFormat = DateFormat("EEE, MMM d");
                    // DateTime dateTime = inputFormat.parse(inputTime);
                    String formattedTime = outputFormat.format(inputTime);
                    String formattedDate = outputDateFormat.format(inputDate);
                    return ListTile(
                      title: Align(
                        alignment: usersCustomersId ==
                                getMessageLiveModel
                                    .data![revers].senderData!.usersCustomersId
                                    .toString()
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              color: usersCustomersId ==
                                      getMessageLiveModel.data![revers]
                                          .senderData!.usersCustomersId
                                          .toString()
                                  ? const Color(0xFF2B65EC)
                                  : const Color(0xFFEBEBEB),
                              borderRadius: usersCustomersId ==
                                      getMessageLiveModel.data![revers]
                                          .senderData!.usersCustomersId
                                          .toString()
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.zero,
                                    )
                                  : const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.circular(10),
                                    )),
                          child: Column(
                            crossAxisAlignment: usersCustomersId ==
                                    getMessageLiveModel.data![revers]
                                        .receiverData!.usersSystemId
                                        .toString()
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              if (imagemessage)
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "$baseUrlImage${getMessageLiveModel.data![revers].message}",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (!imagemessage)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    message!,
                                    textAlign: usersCustomersId ==
                                            getMessageLiveModel.data![revers]
                                                .senderData!.usersCustomersId
                                                .toString()
                                        ? TextAlign.end
                                        : TextAlign.start,
                                    style: TextStyle(
                                      color: isMyMessage
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Outfit",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Align(
                        alignment: usersCustomersId ==
                                getMessageLiveModel
                                    .data![revers].senderData!.usersCustomersId
                                    .toString()
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          "$formattedDate $formattedTime",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  })),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      TextFormField(
                        style: const TextStyle(
                            color: Color(0xFFA7A9B7), fontSize: 16),
                        cursorColor: const Color(0xFFA7A9B7),
                        controller: sendMessageController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: "Type your message",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          hintStyle: const TextStyle(
                            color: Color(0xFFA7A9B7),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Outfit",
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () async {
                    if (sendMessageController.text.isNotEmpty) {
                      print(
                          "sendMessageController ${sendMessageController.text}");
                      await sendMessageApiWidget();
                      sendMessageController
                          .clear(); // Clear the text field after sending the message
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please type a Message"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    setState(() {
                      getMessageApi();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SvgPicture.asset(
                      "assets/images/send.svg",
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String formatTime(String time) {
    final timeComponents = time.split(':');
    final hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    // Create a DateTime object with the current date and the given hour and minute
    final dateTime = DateTime.now().add(Duration(hours: hour, minutes: minute));

    // Format the DateTime object as "hh:mm a"
    return DateFormat('hh:mm a').format(dateTime);
  }

  bool isImageUrl(String? message) {
    if (message == null) return false;

    // Regular expression pattern to match image URLs
    RegExp imageUrlRegex = RegExp(
      r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)",
      caseSensitive: false,
    );

    return imageUrlRegex.hasMatch(message);
  }

  String? currentDate;
  String? date;
}
