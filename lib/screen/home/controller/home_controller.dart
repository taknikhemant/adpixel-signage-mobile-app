import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/api_services.dart';
import '../models/device_templete_data_model.dart';

class HomeController extends GetxController {
  final whatsappNumber = Rxn<String>();

  @override
  void onInit() async {
    super.onInit();
  }

  Future<DeviceTempleteDataModel?> deviceTempData() async {
    return await ApiServices.instance.deviceTempData();
  }

  Future<String?> getUserNumer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userNumber');
  }

  clearUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
