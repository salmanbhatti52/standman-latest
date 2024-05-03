import 'package:StandMan/Pages/Customer/HomePage/HomePage.dart';
import 'package:StandMan/Pages/Customer/MessagePage/customerInbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/get_allCaht_Model.dart';
import '../../../Utils/api_urls.dart';
import 'package:http/http.dart' as http;

class MessagesLists extends StatefulWidget {
  @override
  _MessagesListsState createState() => _MessagesListsState();
}

class _MessagesListsState extends State<MessagesLists> {
  GetAllCahtModel getAllChatModel = GetAllCahtModel();

  sharePref() async {
    prefs = await SharedPreferences.getInstance();
    oneSignalID = prefs!.getString('oneSignalId');
    print("oneSignalId = $oneSignalID");
  }

  bool progress = false;
  bool isInAsyncCall = false;

  getAllChat() async {
    setState(() {
      progress = true;
    });

    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
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
  }

  @override
  void initState() {
    super.initState();
    getAllChat();
    sharePref();
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
                          child: Text('No Chat available...',
                              style: TextStyle(fontWeight: FontWeight.bold)))
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: getAllChatModel.data?.length,
                          // messagesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            DateTime? inputTime =
                                getAllChatModel.data?[index].dateAdded!;
                            // DateTime? inputDate =
                            //     getAllChatModel.data?[index].dateAdded;
                            // DateFormat inputFormat = DateFormat("H:mm:ss");
                            DateFormat outputFormat = DateFormat("h:mm a");
                            DateFormat outputDateFormat =
                                DateFormat("EEE, MMM d");
                            // DateTime dateTime = inputFormat.parse(inputTime);
                            String? formattedTime = inputTime != null
                                ? outputFormat.format(inputTime)
                                : null;
                            String? formattedDate = inputTime != null
                                ? outputDateFormat.format(inputTime)
                                : null;
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10, left: 15),
                                    // width: 150,
                                    // height: height * 0.1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Get.to(() => CustomerInbox(
                                                  rId:
                                                      "${getAllChatModel.data?[index].userData?.usersCustomersId}",
                                                  profilepic:
                                                      "$baseUrlImage${getAllChatModel.data![index].userData!.profilePic}",
                                                  fullname:
                                                      "${getAllChatModel.data![index].userData!.firstName} ${getAllChatModel.data![index].userData!.lastName}",
                                                  userId:
                                                      "${getAllChatModel.data?[index].senderId}",
                                                ));
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            // messagesList[index].title,
                                            "${getAllChatModel.data![index].userData!.firstName} ${getAllChatModel.data![index].userData!.lastName}",
                                            style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontFamily: "Outfit",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            // textAlign: TextAlign.center,
                                          ),
                                          subtitle: Text(
                                            "$formattedDate",
                                            style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
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
                                              formattedTime!,
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
