import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:StandMan/Models/get_messge_Model.dart';
import 'package:StandMan/Models/sendMessageModels.dart';
import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Utils/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeInbox extends StatefulWidget {
  final String? rId;
  final String? fullname;
  final String? profilepic;
  final String? userId;

  const EmployeeInbox({
    Key? key,
    this.rId,
    this.fullname,
    this.profilepic,
    this.userId,
  }) : super(key: key);

  @override
  State<EmployeeInbox> createState() => _EmployeeInboxState();
}

class _EmployeeInboxState extends State<EmployeeInbox> {
  final TextEditingController _messageController = TextEditingController();
  SendMessagesModel sendMessagesModel = SendMessagesModel();
  GetMessgeModel getMessageModel = GetMessgeModel();

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show error or ask user to enable it
      return Future.error('Location services are disabled');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, show error or ask user to grant permission
      return Future.error('Location permissions are permanently denied');
    }

    if (permission == LocationPermission.denied) {
      // Location permissions are denied, ask user to grant permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permissions are denied, show error or ask user to grant permission
        return Future.error('Location permissions are denied');
      }
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  sharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    oneSignalID = prefs!.getString('oneSignalId');
    print("oneSignalId = $oneSignalID");
    setState(() {
      allmessages();
    });
  }

  bool isLoading = false;
  Future<http.Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    print("Hello world");

    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": appID,
        //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,
        //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  // Create a timer that fires every second
  sendMessages() async {
    String apiUrl = sendMessageCustomerApiUrl;
    print("api: $apiUrl");

    try {
      if (!_isDisposed) {
        setState(() {
          isLoading = true;
        });
      }
      String message = _messageController.text;
      String messageType = "text";

      if (base64imgGallery != null) {
        messageType = "attachment";
        message = base64imgGallery!;
      }
      final response = await http.post(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json',
      }, body: {
        "requestType": "sendMessage",
        "users_customers_type": "Employee",
        "users_customers_id": "${widget.userId}",
        "other_users_customers_id": "${widget.rId}",
        "message_type": messageType,
        "message": message
      });

      final responseString = response.body;
      print("responsejobModel: $responseString");
      print("status Code jobModel: ${response.statusCode}");
      print("in 200 Update");

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          allmessages();
        });
        print("Successful");
        sendMessagesModel = sendMessagesModelFromJson(responseString);
        print('jobModel status: ${sendMessagesModel.status}');
      } else {
        // Handle other status codes or error cases here
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions here
      print("Exception: $e");
    }
  }

  Timer? timer;

  void cancelTimer() {
    // Cancel the timer if it's active
    timer?.cancel();
  }

// Call this function when the user enters the page
  void onPageEnter() {
    // Start the timer to call getMessageApi() every 1 second
    _startTimer();
  }

// Call this function when the user leaves the page
  void onPageExit() {
    // Cancel the timer to stop calling getMessageApi()
    cancelTimer();
  }

  sendImage() async {
    setState(() {
      isLoading = true;
    });

    String apiUrl = sendMessageCustomerApiUrl;
    print("api: $apiUrl");

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
    }, body: {
      "requestType": "sendMessage",
      "users_customers_type": "Employee",
      "users_customers_id": "${widget.userId}",
      "other_users_customers_id": "${widget.rId}",
      "message_type": "attachment",
      "message": base64imgGallery
    });

    final responseString = response.body;
    print("responsejobModel: $responseString");
    print("status Code jobModel: ${response.statusCode}");
    print("in 200 Update");

    if (response.statusCode == 200) {
      sendNotification(
          ["${oneSignalID}"], "StandMan send a message", "StandMan");
      setState(() {
        isLoading = false;
        allmessages();
      });
      print("Successfull");
      sendMessagesModel = sendMessagesModelFromJson(responseString);

      print('jobModel status: ${sendMessagesModel.status}');
    }
  }

  File? imagePathGallery;
  String? base64imgGallery;
  Future pickImageGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile == null) {
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        // const NavBar()), (Route<dynamic> route) => false);
      } else {
        Uint8List imageByte = await xFile.readAsBytes();
        base64imgGallery = base64.encode(imageByte);
        print("base64img $base64imgGallery");

        final imageTemporary = File(xFile.path);

        setState(() {
          imagePathGallery = imageTemporary;
          print("newImage $imagePathGallery");
          print("newImage64 $base64imgGallery");
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => SaveImageScreen(
          //           image: imagePath,
          //           image64: "$base64img",
          //         )));
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: ${e.toString()}');
    }
  }

  void _startTimer() {
    const Duration updateInterval =
        Duration(seconds: 2); // Adjust the interval as needed
    _timer = Timer.periodic(updateInterval, (Timer timer) {
      _streamController.add(null);
      allmessages();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    sharedPrefs();
  }

  void updateMessages() async {
    try {
      String apiUrl = sendMessageCustomerApiUrl;

      final response = await http.post(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json',
      }, body: {
        "requestType": "getMessages",
        "users_customers_id": "${widget.userId}",
        "other_users_customers_id": "${widget.rId}",
      });

      final responseString = response.body;
      print("responsejobModel: $responseString");
      print("status Code jobModel: ${response.statusCode}");
      print("in 200 Update");

      if (response.statusCode == 200) {
        if (responseString != _lastResponse) {
          // Data has been updated
          setState(() {
            getMessageModel = getMessgeModelFromJson(responseString);
          });
          _lastResponse = responseString; // Update the last response
          print("Successful");
          print('jobModel status: ${getMessageModel.status}');
        } else {
          // Data has not been updated
          print("Data is up to date");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  final bool _isDisposed = false;
  String _lastResponse = ""; // Variable to store the last API response

  Future<void> allmessages() async {
    String apiUrl = sendMessageCustomerApiUrl;
    print("api: $apiUrl");
    print("Widget Reciver Id: ${widget.rId}");
    print("widget User id: ${widget.userId}");

    try {
      if (!_isDisposed) {
        setState(() {
          isLoading = true;
        });
      }

      final response = await http.post(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json',
      }, body: {
        "requestType": "getMessages",
        "users_customers_id": "${widget.userId}",
        "other_users_customers_id": "${widget.rId}",
      });

      final responseString = response.body;
      print("responsejobModel: $responseString");
      print("status Code jobModel: ${response.statusCode}");
      print("in 200 Update");

      if (response.statusCode == 200) {
        updateMessages();
        if (responseString != _lastResponse) {
          // Data has been updated
          setState(() {
            getMessageModel = getMessgeModelFromJson(responseString);
          });
          _lastResponse = responseString; // Update the last response
          print("Successful");
          print('jobModel status: ${getMessageModel.status}');
        } else {
          // Data has not been updated
          print("Data is up to date");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _timer?.cancel();
    _streamController.close();
    super.dispose();
  }

  Timer? _timer;
  final StreamController<void> _streamController =
      StreamController<void>.broadcast();
  Future<void> _sendlocation() async {
    Position? position;

    try {
      position = await getCurrentLocation();
    } catch (e) {}
    String messageLocation =
        'Location: ${position?.latitude}, ${position?.longitude}';
  }
//   void _showLocationOnMap(double latitude, double longitude) {
//   // Show the location on the map using the coordinates
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: SizedBox(
//         width: double.maxFinite,
//         height: 300,
//         child: FlutterMap(
//           options: MapOptions(
//             center: LatLng(latitude, longitude),
//             zoom: 13.0,
//           ),
//           layers: [
//             TileLayerOptions(
//               urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//               subdomains: ['a', 'b', 'c'],
//             ),
//             MarkerLayerOptions(
//               markers: [
//                 Marker(
//                   width: 80.0,
//                   height: 80.0,
//                   point: LatLng(latitude, longitude),
//                   builder: (ctx) => Container(
//                     child: Icon(
//                       Icons.location_on,
//                       color: Colors.red,
//                       size: 40.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

  Future<void> _sendMessage() async {
    String message = _messageController.text;
    // TODO: Implement logic to send the message
    await sendMessages();
    if (sendMessagesModel.status == "success") {
      print("Message sent");
    }
    print("Sending message: $message");
    _messageController.clear();
  }

  Future<void> refresh() async {
    await allmessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onPageExit();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 05),
          child: ListTile(
            title: Text(
              // fullName!,
              // g.data![index].usersData!.fullName.toString(),
              "${widget.fullname.toString()}",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Outfit",
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              "Online",
              // getUserChatModel.data
              style: TextStyle(
                color: Color(0xffA7AEC1),
                fontFamily: "Outfit",
                fontWeight: FontWeight.w300,
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

                  backgroundImage: NetworkImage("${widget.profilepic}"),
                ),
                // Image.network(widget.img.toString(),),
                Positioned(
                  top: 5,
                  right: 3,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1.5),
                    ),
                  ),
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
                  itemCount: getMessageModel.data != null
                      ? getMessageModel.data!.length
                      : 0,
                  itemBuilder: (context, index) {
                    int revers = getMessageModel.data!.length - 1 - index;
                    final message = getMessageModel.data![revers].message;
                    final imagemessage =
                        getMessageModel.data![revers].messageType ==
                            "attachment";

                    final isMyMessage = getMessageModel
                            .data![revers].senderData.usersCustomersId
                            .toString() ==
                        widget.userId;

                    print(
                        "SenderId :${getMessageModel.data![revers].senderData.usersCustomersId}");
                    print(
                        "reciver Id: ${getMessageModel.data![revers].receiverData.usersCustomersId}");

                    DateTime inputTime =
                        getMessageModel.data![revers].dateAdded;
                    DateTime inputDate =
                        getMessageModel.data![revers].dateAdded;
                    // DateFormat inputFormat = DateFormat("H:mm:ss");
                    DateFormat outputFormat = DateFormat("h:mm a");
                    DateFormat outputDateFormat = DateFormat("EEE, MMM d");
                    // DateTime dateTime = inputFormat.parse(inputTime);
                    String formattedTime = outputFormat.format(inputTime);
                    String formattedDate = outputDateFormat.format(inputDate);
                    return ListTile(
                      title: Align(
                        alignment: widget.userId ==
                                getMessageModel
                                    .data![revers].senderData.usersCustomersId
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
                                      "$baseUrlImage${getMessageModel.data![revers].message}"
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
                              //             "$baseUrlImage${getMessageModel.data![revers].message}",
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
                                color: widget.userId ==
                                        getMessageModel.data![revers].senderData
                                            .usersCustomersId
                                            .toString()
                                    ? const Color(0xFF2B65EC)
                                    : const Color(0xFFEBEBEB),
                                borderRadius: widget.userId ==
                                        getMessageModel.data![revers].senderData
                                            .usersCustomersId
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
                              crossAxisAlignment: widget.userId ==
                                      getMessageModel.data![revers].receiverData
                                          .usersCustomersId
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
                                          "$baseUrlImage${getMessageModel.data![revers].message}",
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
                                      message,
                                      textAlign: widget.userId ==
                                              getMessageModel.data![revers]
                                                  .senderData.usersCustomersId
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
                        alignment: widget.userId ==
                                getMessageModel
                                    .data![revers].senderData.usersCustomersId
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
                GestureDetector(
                  onTap: () async {
                    pickImageGallery();
                  },
                  child: SvgPicture.asset(
                    "assets/images/paperclip.svg",
                    width: 20,
                    height: 20,
                  ),
                ),
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
                        controller: _messageController,
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
                      if (imagePathGallery != null)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Image.file(
                            imagePathGallery!,
                            width: 70,
                            height: 70,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage();
                      _messageController
                          .clear(); // Clear the text field after sending the message
                      setState(() {
                        imagePathGallery =
                            null; // Reset the image preview after sending
                        base64imgGallery = null;
                      });
                    } else if (base64imgGallery != null) {
                      sendImage();
                      setState(() {
                        imagePathGallery =
                            null; // Reset the image preview after sending
                        base64imgGallery = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please type a Message"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    setState(() {
                      allmessages();
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
