import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/empolyee_wallet_txn_Model.dart';
import '../../../Utils/api_urls.dart';
import '../../../widgets/MyButton.dart';
import '../../Customer/HomePage/HomePage.dart';
import '../../Drawer.dart';
import '../../EmpDrawer.dart';
import 'Emp_user_transaction_details.dart';
import 'package:http/http.dart' as http;

class EmpWalletPage extends StatefulWidget {
  const EmpWalletPage({Key? key}) : super(key: key);

  @override
  State<EmpWalletPage> createState() => _EmpWalletPageState();
}

class _EmpWalletPageState extends State<EmpWalletPage> {
  EmployeewalletTxnModel empolyeeWalletTxnModel = EmployeewalletTxnModel();

  bool loading = false;

  employeeWalletTxn() async {
    setState(() {
      loading = true;
    });
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('empUsersCustomersId');
    print("userId = $usersCustomersId");
    String apiUrl = employeeWalletTxnModelApiUrl;
    print("working");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json"},
      body: {
        "users_customers_id": usersCustomersId,
      },
    );
    final responseString = response.body;
    print("employeeWalletTxnModelApi: ${response.body}");
    print("status Code employeeWalletTxnModel: ${response.statusCode}");
    print("in 200 employeeWalletTxnModel");
    if (response.statusCode == 200) {
      empolyeeWalletTxnModel = employeewalletTxnModelFromJson(responseString);
      setState(() {
        loading = false;
      });
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
    employeeWalletTxn();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      // drawer: MyDrawer(),
      drawer: EmpDrawer(),
      appBar: AppBar(
        toolbarHeight: height * 0.10,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width * 0.9, // 351,
              height: height * 0.16, // 131,
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
                        "Earning to date",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        empolyeeWalletTxnModel.data?.transactionHistory != null
                            ? "\$${empolyeeWalletTxnModel.data?.totalEarnings}"
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
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              width: width * 0.9, // 351,
              height: height * 0.16, // 131,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xffffffff),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Available to Withdraw",
                        style: TextStyle(
                          color: Color(0xff2B65EC),
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        empolyeeWalletTxnModel.data?.transactionHistory != null
                            ? "\$${empolyeeWalletTxnModel.data?.withdrawableAmount}"
                            : "\$0.00",
                        // "\$4,875.00",
                        style: TextStyle(
                          color: Color(0xff2B65EC),
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  smallButton("Withdraw", Color(0xff2B65EC), context),
                ],
              ),
            ),
            SizedBox(height: 11),
            Container(
              width: width,
              height: height * 0.4045,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                      child: Text(
                        "Amount History",
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
                      child: loading
                          ? Center(
                              child: Lottie.asset(
                                "assets/images/loading.json",
                                height: 50,
                              ),
                            )
                          : empolyeeWalletTxnModel.message ==
                                  "No transaction found."
                              ? Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: Get.height * 0.1),
                                      Text(
                                        "No Amount History",
                                        style: TextStyle(
                                          color: Color(0xff000000),
                                          fontFamily: "OutFit",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height * 0.16,
                                    width: width,
                                    color: Colors.transparent,
                                    height: height * 0.35, //300,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        // physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: empolyeeWalletTxnModel
                                            .data?.transactionHistory?.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Get.to("jh");
                                                // Emp_user_transaction_details(
                                                //   ctx: context,
                                                //   name: "${empolyeeWalletTxnModel.data?.transactionHistory?[index] .jobs!.usersCustomers?.firstName} ${empolyeeWalletTxnModel.data?.transactionHistory?[index].jobs!.usersCustomers?.lastName}",
                                                //   date: "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.date}",
                                                //   price: "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.previousPrice}",
                                                //   previousAmount: "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.previousPrice != null
                                                //       ? "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.previousPrice}" : "0"}",
                                                //   extraAmount: "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.extraPrice}",
                                                //   serviceCharges: "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.extraServiceCharges != null
                                                //       ? "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.extraServiceCharges}" : "0"}",
                                                //   bookTime: "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.bookedTime}",
                                                //   closeTime: "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.bookedClose}",
                                                //   extraTime: "${empolyeeWalletTxnModel.data?.transactionHistory?[index].txnDetail?.extraTime}",
                                                // );
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
                                                              backgroundImage: empolyeeWalletTxnModel
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
                                                                          "${empolyeeWalletTxnModel.data?.transactionHistory?[index].jobs!.usersCustomers!.profilePic.toString()}")
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
                                                                  "${empolyeeWalletTxnModel.data?.transactionHistory?[index].jobs!.usersCustomers?.firstName} ${empolyeeWalletTxnModel.data?.transactionHistory?[index].jobs!.usersCustomers?.lastName}",
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
                                                                "${empolyeeWalletTxnModel.data?.transactionHistory?[index].dateAdded}",
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
                                                            "\$${empolyeeWalletTxnModel.data?.transactionHistory?[index].amount}",
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
                    ),
                  ],
                ),
              ),
            ),
          ],
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
