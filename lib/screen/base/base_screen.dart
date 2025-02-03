import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signage_pixel/screen/home/home_screen.dart';

import '../login/screens/login_screen.dart';
import 'controller/base_controller.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});
  final baseController = Get.put(BaseController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: baseController.checkUserLogin(),
        builder: (context, snap) {
          return snap.data == null
              ? const Center(child: CircularProgressIndicator())
              : snap.data == false || snap.data == null
                  ? LoginScreen()
                  : HomeScreen();
        });
  }
}
