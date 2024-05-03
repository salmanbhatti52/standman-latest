import 'package:StandMan/Models/getprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/customer_wallet_txn_Model.dart';
import '../../../Utils/api_urls.dart';
import '../../../widgets/MyButton.dart';
import '../../../widgets/TopBar.dart';
import '../../Drawer.dart';
import '../HomePage/HomePage.dart';
import '../HomePage/RecentJobs.dart';
import 'CardList.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  CustomerWalletTxnModel customerWalletTxnModel = CustomerWalletTxnModel();

  bool loading = false;
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
    print("in 200 getProfileModels");
    if (response.statusCode == 200) {
      print("SuccessFull");
      getProfile = getProfileFromJson(responseString);

      print('getProfileModels status: ${getProfile.status}');
    }
  }

  customerWalletTxn() async {
    setState(() {
      loading = true;
    });
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("userId = $usersCustomersId");
    String apiUrl = customerWalletTxnModelApiUrl;
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
      },
    );
    final responseString = response.body;
    print("customerWalletTxnModelApi: ${response.body}");
    print("status Code customerWalletTxnModel: ${response.statusCode}");
    print("in 200 customerWalletTxnModel");
    if (response.statusCode == 200) {
      customerWalletTxnModel = customerWalletTxnModelFromJson(responseString);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      // setState(() {});
      // print('getJobsModelImage: $baseUrlImage${getJobsModel.data?[0].image}');
      // print('getJobsModelLength: ${getJobsModel.data?.length}');
      // print('getJobsModelemployeeusersCustomersType: ${ getJobsModel.data?[0].usersEmployeeData?.usersCustomersId}');
      // print('getJobsModelImage: $baseUrlImage${getJobsModel.data![0].image}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("users_customers_id: ${usersCustomersId}");
    super.initState();
    getprofile();
    customerWalletTxn();

    // getUserProfileWidget();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // drawer: MyDrawer(),
      drawer: MyDrawer(),
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        backgroundColor: Color(0xff2B65EC),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            "Wallet",
            style: TextStyle(
              color: Color(0xffffffff),
              fontFamily: "Outfit",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              // letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Color(0xff2B65EC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width * 0.9, // 351,
                height: height * 0.15, // 131,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Wallet Amount",
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          getProfile.data != null
                              ? "\$${getProfile.data!.walletAmount}"
                              : "\$0.00",
                          // "\$4,875.00",
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/images/empty-wallet.svg",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),

              Container(
                width: width * 0.9, // 351,
                height: height * 0.15, // 131,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xffFF9900),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Expenses to date",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          customerWalletTxnModel.data?.transactionHistory !=
                                  null
                              ? "\$${customerWalletTxnModel.data?.totalExpenses}"
                              : "\$0.00",
                          // "\$4,875.00",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SvgPicture.asset("assets/images/empty-wallet.svg"),
                  ],
                ),
              ),

              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Payment methods',
              //         style: TextStyle(
              //           color: Color(0xffffffff),
              //           fontFamily: "Outfit",
              //           fontSize: 16,
              //           fontWeight: FontWeight.w300,
              //           // letterSpacing: -0.3,
              //         ),
              //       ),
              //       Row(
              //         children: [
              //           Text(
              //             'Add Card  ',
              //             style: TextStyle(
              //               color: Color(0xffffffff),
              //               fontFamily: "Outfit",
              //               fontSize: 12,
              //               fontWeight: FontWeight.w500,
              //               // letterSpacing: -0.3,
              //             ),
              //           ),
              //           GestureDetector(
              //             onTap: () {
              //               showDialog(
              //                 context: context,
              //                 builder: (BuildContext context) => Dialog(
              //                     shadowColor: Color(0xff0f172a).withOpacity(0.3),
              //                     // backgroundColor: Color(0xff0f172a).withOpacity(0.3),
              //                     backgroundColor: Colors.transparent,
              //                     elevation: 0,
              //                     child: Container(
              //                       // color: Color(0xff0f172a).withOpacity(0.3),
              //                       width: width,
              //                       // height: 423,
              //                       child: Column(
              //                         mainAxisAlignment: MainAxisAlignment.center,
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         children: [
              //                           Image.asset(
              //                               "assets/images/cardcomplete.png"),
              //                           const Text(
              //                             "Card added\nSuccessfully",
              //                             style: TextStyle(
              //                               color: Colors.white,
              //                               fontFamily: "Outfit",
              //                               fontWeight: FontWeight.w500,
              //                               fontSize: 32,
              //                             ),
              //                             textAlign: TextAlign.left,
              //                           ),
              //                           SizedBox(
              //                             height: height * 0.04,
              //                           ),
              //                           GestureDetector(
              //                               onTap: () {
              //                                 Get.back();
              //                               },
              //                               child: mainButton(
              //                                   "Go Back to Wallet Screen",
              //                                   Color.fromRGBO(43, 101, 236, 1),
              //                                   context))
              //                         ],
              //                       ),
              //                     )),
              //               );
              //             },
              //             child: Container(
              //               width: 20,
              //               height: 20,
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(3),
              //               ),
              //               child: Center(
              //                   child: Icon(
              //                 Icons.add,
              //                 color: Color(0xff2B65EC),
              //                 size: 20,
              //               )),
              //             ),
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // CardList(),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                // height: Get.height * 0.343,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15),
                        child: Text(
                          "Transaction History",
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontFamily: "OutFit",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        height: height * 0.536,
                        child: loading
                            ? Center(
                                child: Lottie.asset(
                                  "assets/images/loading.json",
                                  height: 50,
                                ),
                              )
                            : customerWalletTxnModel
                                            .data?.transactionHistory?.length ==
                                        null ||
                                    customerWalletTxnModel.status == "error"
                                ? Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: Get.height * 0.1),
                                        Center(
                                          child: Text(
                                            "No Transaction History",
                                            style: TextStyle(
                                              color: Color(0xff000000),
                                              fontFamily: "OutFit",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    // height: MediaQuery.of(context).size.height * 0.16,
                                    width: width,
                                    color: Colors.transparent,
                                    height: height * 0.535, //300,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        // physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: customerWalletTxnModel
                                            .data?.transactionHistory?.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          DateTime? inputTime =
                                              customerWalletTxnModel
                                                  .data!
                                                  .transactionHistory![index]
                                                  .dateAdded;
                                          // DateTime? inputDate =
                                          //     getAllChatModel.data?[index].dateAdded;
                                          // DateFormat inputFormat = DateFormat("H:mm:ss");
                                          DateFormat outputFormat =
                                              DateFormat("h:mm a");
                                          DateFormat outputDateFormat =
                                              DateFormat("EEE, MMM d, yyyy");
                                          // DateTime dateTime = inputFormat.parse(inputTime);
                                          String? formattedTime = inputTime !=
                                                  null
                                              ? outputFormat.format(inputTime)
                                              : null;
                                          String? formattedDate =
                                              inputTime != null
                                                  ? outputDateFormat
                                                      .format(inputTime)
                                                  : null;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Get.to("jh");
                                              },
                                              child: Container(
                                                // height: MediaQuery.of(context).size.height * 0.4,
                                                // width: MediaQuery.of(context).size.width * 0.3,
                                                // width: 358,
                                                height: height * 0.1, //80,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color:
                                                            Color(0xffF4F5F7)),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              backgroundImage: customerWalletTxnModel
                                                                          .data
                                                                          ?.transactionHistory?[
                                                                              index]
                                                                          .jobs!
                                                                          .usersCustomers
                                                                          ?.profilePic ==
                                                                      null
                                                                  ? Image.asset(
                                                                          "assets/images/person2.png")
                                                                      .image
                                                                  : NetworkImage(
                                                                      baseUrlImage +
                                                                          "${customerWalletTxnModel.data?.transactionHistory?[index].jobs!.usersCustomers!.profilePic.toString()}")
                                                              // NetworkImage(baseUrlImage+ getUserProfileModelObject.data!.profilePic!)

                                                              ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            3.0),
                                                                child: Text(
                                                                  "${customerWalletTxnModel.data?.transactionHistory?[index].jobs!.usersCustomers?.firstName} ${customerWalletTxnModel.data?.transactionHistory?[index].jobs!.usersCustomers?.lastName}",
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontFamily:
                                                                        "Outfit",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              Text(
                                                                "${formattedDate}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xff9D9FAD),
                                                                  fontFamily:
                                                                      "Outfit",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 10,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "\$${customerWalletTxnModel.data?.transactionHistory?[index].amount}",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff18C85E),
                                                              fontFamily:
                                                                  "Outfit",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                            ),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List transactionList = [
  _transactionList(
      "assets/images/g2.png", "Dr.	Jane	N.	Dacks", '02 Mar 222', Colors.grey),
  _transactionList(
      "assets/images/g2.png", "Dr.	Jane	N.	Dacks", '02 Mar 222', Colors.grey),
  _transactionList(
      "assets/images/g2.png", "Dr.	Jane	N.	Dacks", '02 Mar 222', Colors.grey),
  _transactionList(
      "assets/images/g2.png", "Dr.	Jane	N.	Dacks", '02 Mar 222', Colors.grey),
];

class _transactionList {
  final String image;
  final String title;
  final String subTitle;
  final Color color;

  _transactionList(this.image, this.title, this.subTitle, this.color);
}
