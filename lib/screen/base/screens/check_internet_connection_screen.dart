import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../controller/base_controller.dart';
import 'no_initernet_screen.dart';

class CheckInternetConnection extends StatefulWidget {
  final Widget child;
  const CheckInternetConnection({super.key, required this.child});

  @override
  State<CheckInternetConnection> createState() =>
      _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  final baseController = Get.find<BaseController>();

  late StreamSubscription<InternetStatus> interNetListener;

  @override
  void initState() {
    interNetListener = InternetConnection()
        .onStatusChange
        .listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          baseController.internetConectionStatus.value = true;
          break;
        case InternetStatus.disconnected:
          baseController.internetConectionStatus.value = false;
          break;
        // default:
        //   baseController.internetConectionStatus.value = null;
        //   break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    interNetListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return baseController.internetConectionStatus.value == null
          ? const Center(child: CircularProgressIndicator())
          : baseController.internetConectionStatus.value == false
              ? const NoIniternetScreen()
              : widget.child;
    });
  }
}
