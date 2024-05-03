// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:StandMan/Models/customerCompleteJobModels.dart';
import 'package:StandMan/widgets/MyButton.dart'; 
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Utils/api_urls.dart';
import '../../../../widgets/ToastMessage.dart';
import '../../../../widgets/TopBar.dart';
import '../../HomePage/HomePage.dart';
import 'package:http/http.dart' as http;

class CustomerQRCodeScanner extends StatefulWidget {
  String? customerId;
  String? employeeId;
  String? jobId;
  String? jobName;
  String? buttonClickTime;
  CustomerQRCodeScanner({
    Key? key,
    this.customerId,
    this.employeeId,
    this.buttonClickTime,
    this.jobId,
    this.jobName,
  }) : super(key: key);

  @override
  State<CustomerQRCodeScanner> createState() => _CustomerQRCodeScannerState();
}

class _CustomerQRCodeScannerState extends State<CustomerQRCodeScanner> {
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
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
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

  CustomerJobsCompleteModels customerJobsCompleteModels =
      CustomerJobsCompleteModels();
  completeJob() async {
    prefs = await SharedPreferences.getInstance();
    usersCustomersId = prefs!.getString('usersCustomersId');
    print("usersCustomersId = $usersCustomersId");
    print("customerId = ${widget.customerId}");

    // try {
    String apiUrl = completeJobCustomerAPI;
    print("userChatApiUrl: $apiUrl");
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "users_customers_id": usersCustomersId,
        "jobs_id": "${widget.jobId}",
        "jobs_requests_id": "204",
      },
      headers: {'Accept': 'application/json'},
    );
    print('${response.statusCode}');
    print(response);
    print("completeJobJobModels response: ${response.body}");
    print("status Code chat: ${response.statusCode}");
    print("in 200 chat");
    if (response.statusCode == 200) {
      final responseString = response.body;
      print("completeJobJobModels: ${responseString.toString()}");
      customerJobsCompleteModels =
          customerJobsCompleteModelsFromJson(responseString);
      progress = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  bool progress = false;

  @override
  void initState() {
    super.initState();
    print(
        "CustomerId, jobId, jobName ${widget.customerId} ${widget.jobId} ${widget.jobName}");

    // Delay the scanning process for 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      // Verify the QR code after the delay
      print("resultssss ${result?.code}");
      print("Scanned QR code: ${result?.code}");
      print(
          "Expected format: ${widget.customerId} ${widget.jobId} ${widget.jobName}");
      if (result?.code ==
          "${widget.customerId} ${widget.jobId} ${widget.jobName}") {
        controller?.pauseCamera();
        completeJob();
        // makePayment();
      } else if (result?.code !=
          "${widget.customerId} ${widget.jobId} ${widget.jobName}") {
        toastFailedMessage("Invalid Scan", Colors.red);
      } else {
        toastFailedMessage("Failed to Scan", Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandManAppBar1(
        title: "Scan QR",
        bgcolor: Color(0xff000000),
        titlecolor: Colors.white,
        iconcolor: Colors.white,
      ),
      // backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }
}
