import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:StandMan/Models/completeJobModels.dart';
import 'package:StandMan/Models/customerCompleteJobModels.dart';
import 'package:StandMan/Models/fineJobCustomerModel.dart';
import 'package:StandMan/Pages/Customer/JobsPage/CustomerJobProfile/CustomerJobProfile.dart';
import 'package:StandMan/Pages/Customer/MessagePage/customerInbox.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Models/chat_start_user_Model.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/MyButton.dart';
import '../../../../widgets/ToastMessage.dart';
import '../../../../widgets/TopBar.dart';
import '../../../Employee/HomePage/EmpHomePage.dart';
import '../../HomePage/HomePage.dart';
import '../../MessagePage/MessageDetails.dart';
import '../Customer_QR_Scanner/QRCodeScanner.dart';
import 'package:http/http.dart' as http;
import '../CustomerRatingSection/CustomerRatingSection.dart';
import '../Payment_Sheet/Customer_Payment_Sheet.dart';

class CustomerWithoutExtraTime extends StatefulWidget {
  String? customerId;
  String? employeeId;
  String? jobRequestId;
  String? jobId;
  String? jobName;
  String? totalPrice;
  String? completeJobTime;
  String? description;
  String? address;
  CustomerWithoutExtraTime({
    Key? key,
    this.address,
    this.description,
    this.jobRequestId,
    this.completeJobTime,
    this.totalPrice,
    this.customerId,
    this.jobName,
    this.employeeId,
    this.jobId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomerWithoutExtraTimeState();
}

class _CustomerWithoutExtraTimeState extends State<CustomerWithoutExtraTime> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  verify() {
    print(
        "CustomerId, jobId, jobName ${widget.employeeId} ${widget.jobId} ${widget.jobName}");
    Future.delayed(const Duration(seconds: 2), () {
      print("resultssss ${result?.code}");
      if (result?.code ==
          "${widget.employeeId} ${widget.jobId} ${widget.jobName}") {
        controller?.pauseCamera();
        completeJob();
        // checkJobStatus();
        // makePayment();
      } else if (result?.code !=
          "${widget.employeeId} ${widget.jobId} ${widget.jobName}") {
        toastFailedMessage("Invalid Scan", Colors.red);
      } else {
        toastFailedMessage("Failed to Scan", Colors.red);
        verify();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verify();
  }

  bool progress = false;

  List checkJobsTime = [];
  CustomerJobsCompleteModels customerJobsCompleteModels =
      CustomerJobsCompleteModels();
  completeJob() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("UsersCustomersId = $usersCustomersId");
    print("customerId = ${widget.customerId}");

    // try {
    setState(() {
      progress = true;
    });
    String apiUrl = completeJobCustomerAPI;
    print("userChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": "${widget.employeeId}",
        "jobs_id": "${widget.jobId}",
        "jobs_requests_id": "${widget.jobRequestId}",
      },
      headers: {'Accept': 'application/json'},
    );
    print('${response.statusCode}');
    print(response);
    print("completeJobJobModels response: ${response.body}");
    print("status Code chat: ${response.statusCode}");
    print("in 200 chat");
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Customer_Rating(
            jobName: "${widget.jobName}",
            totalPrice: "${widget.totalPrice}",
            address: "${widget.address}",
            jobId: "${widget.jobId}",
            completeJobTime: "${widget.completeJobTime}",
            description:
                "${widget.description != null ? widget.description : ""}",
            status: "Completed",
            customerId: "${widget.customerId}",
            employeeId: "${widget.employeeId}",
          ), // Replace SecondScreen() with your intended replacement screen
        ),
      );
      final responseString = response.body;
      print("completeJobJobModels: ${responseString.toString()}");
      customerJobsCompleteModels =
          customerJobsCompleteModelsFromJson(responseString);

      setState(() {
        progress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      print("Scanned Data: ${result?.code}");
      print(
          "Comparison Value: ${widget.employeeId} ${widget.jobId} ${widget.jobName}");

      // Compare scanned data with the expected value here
      if (result?.code ==
          "${widget.employeeId} ${widget.jobId} ${widget.jobName}") {
        // Data matches, navigate to the next page
        controller.pauseCamera();
        completeJob();
      } else {
        // Data does not match, show a snackbar with an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid job ID'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
