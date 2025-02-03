import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseController extends GetxController {
  // final drawerSelectedIndex = 0.obs;

  Future<bool?> checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("message==>${prefs.getString('jwt')}", name: "UserToken");
    return prefs.getString('jwt') == null || prefs.getString('jwt') == ""
        ? false
        : true;
  }
}
