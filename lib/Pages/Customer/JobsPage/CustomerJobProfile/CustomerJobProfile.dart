import 'package:StandMan/Pages/Customer/MessagePage/customerInbox.dart';
import 'package:StandMan/widgets/ToastMessage.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import '../../../../Models/all_ratings_Model.dart';
import '../../../../Models/chat_start_user_Model.dart';
import '../../../../Utils/api_urls.dart';

import 'package:http/http.dart' as http;

class Customer_Profile extends StatefulWidget {
  String? customerId;
  String? employeeId;
  String? oneSignalId;
  String? name;
  String? rating;
  String? profilePic;
  Customer_Profile({
    Key? key,
    this.oneSignalId,
    this.customerId,
    this.employeeId,
    this.profilePic,
    this.name,
    this.rating,
  }) : super(key: key);

  @override
  State<Customer_Profile> createState() => _Customer_ProfileState();
}

class _Customer_ProfileState extends State<Customer_Profile> {
  AllRatingsModel allRatingsModel = AllRatingsModel();
  bool loading = false;

  allJobRating() async {
    // prefs = await SharedPreferences.getInstance();
    // usersCustomersId = prefs!.getString('usersCustomersId');
    // print("userId in Prefs is = $usersCustomersId");
    String apiUrl = allJobRatingModelApiUrl;
    print("working");
    setState(() {
      loading = true;
    });
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": widget.employeeId,
      },
    );
    final responseString = response.body;
    print("allJobRatingModelApi: ${response.body}");
    print("status Code allJobRatingModel: ${response.statusCode}");
    print("in 200 allJobRatingModel");
    if (response.statusCode == 200) {
      allRatingsModel = allRatingsModelFromJson(responseString);
      setState(() {
        loading = false;
      });
      // print('getJobsModelImage: $baseUrlImage${al.data?[0].image}');
      // print('getJobsModelLength: ${getJobsModel.data?.length}');
      // print('getJobsModelemployeeusersCustomersType: ${ getJobsModel.data?[0].usersEmployeeData?.usersCustomersId}');
      // print('getJobsModelImage: $baseUrlImage${getJobsModel.data![0].image}');
    }
  }

  double? rating;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allJobRating();
    print("rating ${widget.rating}");

    try {
      rating = double.parse(widget.rating!);
    } catch (e) {
      rating = 4.00; // default value
    }
  }

  ChatStartUserModel chatStartUserModel = ChatStartUserModel();

  bool progress = false;

  chatStartUser() async {
    // try {
    String apiUrl = userChatApiUrl;
    print("userChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "requestType": "startChat",
        "users_customers_type": "Customer",
        "users_customers_id": widget.customerId,
        "other_users_customers_id": widget.employeeId,
      },
      headers: {'Accept': 'application/json'},
    );
    print('${response.statusCode}');
    print(response);
    print("responseStartChat: $response");
    print("status Code chat: ${response.statusCode}");
    print("in 200 chat");
    if (response.statusCode == 200) {
      final responseString = response.body;
      print("userChatResponse: ${responseString.toString()}");
      chatStartUserModel = chatStartUserModelFromJson(responseString);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (loading == true) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (loading == false && allRatingsModel.status == "error") {
      return Scaffold(
        appBar: AppBar(
          title: Text("Ratings Profile"),
          centerTitle: true,
          backgroundColor: Color(0xff2B65EC),
        ),
        body: Center(
          child: Text("No Ratings Yet"),
        ),
      );
    } else {
      return Scaffold(
          // drawer: MyDrawer(),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xff2B65EC),
            // leading: IconButton(
            //   icon: Icon(Icons.menu, color: Colors.black,),
            //   onPressed: () {
            //     Get.to(MyDrawer());
            //     // Scaffold.of(context).openDrawer();
            //   },
            // ),
            title: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                "Rating Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Outfit",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  // letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                    width: width * 0.9,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                        color: Color(0xff2B65EC),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            backgroundImage: "${widget.profilePic}" == null
                                ? Image.asset("assets/images/person2.png").image
                                : NetworkImage("${widget.profilePic}"),
                            // NetworkImage(baseUrlImage+ getUserProfileModelObject.data!.profilePic!)
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.name}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Outfit",
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await chatStartUser();
                                if (chatStartUserModel.status == "success") {
                                  Get.to(
                                    () => CustomerInbox(
                                      userId: widget.customerId,
                                      rId: widget.employeeId,
                                      profilepic: widget.profilePic.toString(),
                                      fullname: widget.name.toString(),
                                    ),
                                  );
                                } else if (chatStartUserModel.message ==
                                    "Chat is already started.") {
                                  Get.to(
                                    () => CustomerInbox(
                                      userId: widget.customerId,
                                      rId: widget.employeeId,
                                      profilepic: widget.profilePic.toString(),
                                      fullname: widget.name.toString(),
                                    ),
                                  );
                                } else {
                                  //toast Message
                                  toastSuccessMessage(
                                      "${chatStartUserModel.message}",
                                      Colors.green);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                // height: MediaQuery.of(context).size.height*0.07,
                                height: 48,
                                width: 118,
                                decoration: BoxDecoration(
                                    // color: Color(0xff4DA0E6),
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 0,
                                          blurRadius: 15,
                                          offset: Offset(1, 10),
                                          color: Color.fromRGBO(7, 1, 87, 0.1)),
                                    ]),
                                child: Center(
                                  child: Text(
                                    "Chat",
                                    style: TextStyle(
                                        fontFamily: "Outfit",
                                        fontSize: 14,
                                        color: Color(0xff2B65EC),
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                widget.rating == "null"
                                    ? Text("")
                                    : RatingBarIndicator(
                                        rating: rating!,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Color(0xffFFDF00),
                                        ),
                                        itemCount: rating?.toInt() ?? 0,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                // RatingBar(
                                //     initialRating: widget.rating != null &&
                                //             double.tryParse(
                                //                     widget.rating.toString()) !=
                                //                 null
                                //         ? double.parse(widget.rating.toString())
                                //         : 0.0,
                                //     direction: Axis.horizontal,
                                //     allowHalfRating: true,
                                //     itemSize: 20,
                                //     itemCount:
                                //         int.tryParse(widget.rating ?? '0') ?? 0,
                                //     ratingWidget: RatingWidget(
                                //         full: const Icon(
                                //           Icons.star,
                                //           color: Color(0xffFFDF00),
                                //         ),
                                //         half: const Icon(
                                //           Icons.star_half,
                                //           color: Color(0xffFFDF00),
                                //         ),
                                //         empty: const Icon(
                                //           Icons.star_outline,
                                //           color: Color(0xffA7A9B7),
                                //         )),
                                //     // onRatingUpdate: (double value) {},
                                //     onRatingUpdate: (value) {
                                //       setState(() {
                                //         widget.rating = value.toString();
                                //       });
                                //     }),

                                widget.rating == "null"
                                    ? Text("")
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          widget.rating!.isEmpty
                                              ? ""
                                              : "${widget.rating}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Outfit",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )),
                // Customer_ProfileLists(),
                Container(
                  child: allRatingsModel.data?.length == null
                      ? Center(
                          child: Lottie.asset(
                            "assets/images/loading.json",
                            height: 50,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // color: Color(0xff9D9FAD),
                            // height: MediaQuery.of(context).size.height * 0.16,
                            // width: 358,
                            // height: 150,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                // physics: BouncingScrollPhysics(),
                                itemCount: allRatingsModel.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // Get.to(page);
                                              },
                                              child: CircleAvatar(
                                                  radius: 32,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: allRatingsModel
                                                              .data![index]
                                                              .jobs
                                                              .usersCustomers!
                                                              .profilePic ==
                                                          null
                                                      ? Image.asset(
                                                              "assets/images/person2.png")
                                                          .image
                                                      : NetworkImage(baseUrlImage +
                                                          "${allRatingsModel.data![index].jobs.usersCustomers!.profilePic.toString()}")),
                                            ),
                                            SizedBox(
                                              width: width * 0.02,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${allRatingsModel.data?[index].jobs.usersCustomers!.firstName} ${allRatingsModel.data?[index].jobs.usersCustomers!.lastName}",
                                                    style: TextStyle(
                                                      color: Color(0xff000000),
                                                      fontFamily: "Outfit",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5.0),
                                                    child: Container(
                                                      width: Get.width * 0.68,
                                                      child: AutoSizeText(
                                                        "${allRatingsModel.data?[index].comment}",
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                          fontFamily: "Outfit",
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10,
                                                        ),
                                                        maxLines: 2,
                                                        minFontSize: 10,
                                                        maxFontSize: 10,
                                                        presetFontSizes: [10],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xffFFDF00),
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        "${allRatingsModel.data?[index].rating}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                          fontFamily: "Outfit",
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                ),
              ],
            ),
          ));
    }
  }
}
