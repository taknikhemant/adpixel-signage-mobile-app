import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/api_services.dart';
import '../../../services/socket_service.dart';
import '../models/device_templete_data_model.dart';

class HomeController extends GetxController {
  final socketService = Get.put(SocketService());
  final whatsappNumber = Rxn<String>();
  final templateData = Rxn<DeviceTempleteDataModel>();

  @override
  void onInit() async {
    super.onInit();
    socketService.initSocket(d: templateData);
  }

  Future<DeviceTempleteDataModel?> deviceTempData() async {
    var data = await ApiServices.instance.deviceTempData();
    templateData.value = data;
    return data;
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
