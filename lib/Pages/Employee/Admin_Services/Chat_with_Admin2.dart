import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:StandMan/Models/getMessageLiveModel.dart';
import 'package:StandMan/Models/get_messge_Model.dart';
import 'package:StandMan/Models/sendMessageModels.dart';
import 'package:StandMan/Models/sendmessageliveModels.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Pages/EmpBottombar.dart';
import 'package:StandMan/Utils/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminChatEmployee extends StatefulWidget {
  const AdminChatEmployee({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminChatEmployee> createState() => _AdminChatEmployeeState();
}

class _AdminChatEmployeeState extends State<AdminChatEmployee> {
  bool loading = false;
  TextEditingController sendMessageController = TextEditingController();
  GetMessageLiveModel getMessageLiveModel = GetMessageLiveModel();
  final GlobalKey<FormState> sendMessageFormKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  SendMessageLive sendMessageLive = SendMessageLive();
  sendMessageApiWidget() async {
    prefs = await SharedPreferences.getInstance();
    adminID = prefs!.getString('adminID');
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("usersCustomersId = $usersCustomersId");
    print("getAdmin = $adminID");
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('https://admin.standman.ca/api/user_chat_live');

    var body = {
      "requestType": "sendMessage",
      "users_type": "Customer",
      "users_id": usersCustomersId.toString(),
      "other_users_id": adminID,
      "message_type": "text",
      "message": sendMessageController.text,
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      sendMessageLive = sendMessageLiveFromJson(resBody);
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
    // String apiurl1 = "https://admin.standman.ca/api/user_chat_live";

    // print("working");
    // final response = await http.post(
    //   Uri.parse(apiurl1),
    //   headers: {"Accept": "application/json"},
    //   body: {
    //     "requestType": "sendMessage",
    //     "sender_type": "Employee",
    //     "message_type": "text",
    //     "users_id": usersCustomersId.toString(),
    //     "other_users_id": adminID.toString(),
    //     "message": sendMessageController.text,
    //   },
    // );
    // final responseString = response.body;
    // print("sendMessageLiveApiUrl: ${response.body}");
    // print("status Code sendMessageLiveApiUrl: ${response.statusCode}");
    // print("in 200 sendMessageLiveApiUrl");
    // print("sendMessageApiUrl: $sendMessageLiveApiUrl");
    // print("sendMessageText: ${sendMessageController.text}");
    // if (response.statusCode == 200) {
    //   sendMessageLive = sendMessageLiveFromJson(responseString);
    //   print('Message sent successfully.');
    // }
    // setState(() {
    //   loading = false;
    //   // getMessageApi();
    // });
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
    usersCustomersId = prefs!.getString('empUsersCustomersId');
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
            Get.to(() => Empbottom_bar(
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
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(120),
                //   child: FadeInImage(
                //     placeholder: AssetImage("assets/images/fade_in_image.jpeg"),
                //     image: NetworkImage("${widget.img}"),
                //   ),
                // ),
                CircleAvatar(
                  // radius: (screenWidth > 600) ? 90 : 70,
                  radius: 30,

                  backgroundImage: NetworkImage("${adminImage}"),
                ),
                // Image.network(widget.img.toString(),),
                // Positioned(
                //   top: 5,
                //   right: 3,
                //   child: Container(
                //     height: 10,
                //     width: 10,
                //     decoration: BoxDecoration(
                //       color: Colors.green,
                //       shape: BoxShape.circle,
                //       border: Border.all(
                //           color: Theme.of(context).scaffoldBackgroundColor,
                //           width: 1.5),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        // actions: [
        //   Padding(
        //   padding:  EdgeInsets.only(left:  width * 0.08),
        //   child: Row(
        //     children: [
        //       GestureDetector(
        //           onTap: (){
        //             Get.back();
        //           },
        //           child: SvgPicture.asset("assets/images/left.svg",)),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 20.0, right: 10),
        //         child:
        //       ),
        //       Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //

        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        // ],
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

                    final isMyMessage = (getMessageLiveModel
                                .data?[revers].senderData?.usersCustomersId
                                .toString() ==
                            usersCustomersId) ??
                        false;

                    print(
                        "SenderId :${getMessageLiveModel.data?[revers].senderData?.usersCustomersId ?? ''}");
                    print(
                        "reciver Id: ${getMessageLiveModel.data![revers].receiverId}");

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
                                getMessageLiveModel.data![revers].senderId
                                    .toString()
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (imagemessage) {
                              // Open the image in a dialog or a new screen

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImageGallery(
                                    images: [
                                      "$baseUrlImage${getMessageLiveModel.data![revers].message}"
                                      // Add more image URLs if needed
                                    ],
                                    initialIndex:
                                        0, // Index of the initially displayed image
                                  ),
                                ),
                              );
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => Dialog(
                              //     child: Container(
                              //       width: 400,
                              //       height: 300,
                              //       decoration: BoxDecoration(
                              //         color: Colors.transparent,
                              //         borderRadius: BorderRadius.circular(10),
                              //         image: DecorationImage(
                              //           image: NetworkImage(
                              //             "$baseUrlImage${getMessageLiveModel.data![revers].message}",
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: usersCustomersId ==
                                        getMessageLiveModel
                                            .data![revers].senderId
                                            .toString()
                                    ? const Color(0xFF2B65EC)
                                    : const Color(0xFFEBEBEB),
                                borderRadius: usersCustomersId ==
                                        getMessageLiveModel
                                            .data![revers].senderId
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
                                      getMessageLiveModel
                                          .data![revers].receiverId
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
                                              getMessageLiveModel
                                                  .data![revers].senderId
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
                      ),
                      subtitle: Align(
                        alignment: usersCustomersId ==
                                getMessageLiveModel.data![revers].senderId
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
                // GestureDetector(
                //   onTap: () async {},
                //   child: SvgPicture.asset(
                //     "assets/marker.svg",
                //     width: 20,
                //     height: 20,
                //   ),
                // ),
                // const SizedBox(
                //   width: 5,
                // ),

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

class FullScreenImageGallery extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageGallery(
      {super.key, required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gallery",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B65EC),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black, // Background color
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
