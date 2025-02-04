import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signage_pixel/screen/home/home_screen.dart';

import '../login/screens/login_screen.dart';
import 'controller/base_controller.dart';
import 'screens/check_internet_connection_screen.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});
  final baseController = Get.put(BaseController());
  @override
  Widget build(BuildContext context) {
    return CheckInternetConnection(
      child: FutureBuilder(
          future: baseController.checkUserLogin(),
          builder: (context, snap) {
            return snap.data == null
                ? const Center(child: CircularProgressIndicator())
                : snap.data == false || snap.data == null
                    ? LoginScreen()
                    : HomeScreen();
          }),
    );
  }
}
