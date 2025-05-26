import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/api_services.dart';
import '../../../services/file_downloader.dart';
import '../../../services/socket_service.dart';
import '../models/device_templete_data_model.dart';

class HomeController extends GetxController {
  final socketService = Get.put(SocketService());
  final whatsappNumber = Rxn<String>();
  final templateData = Rxn<DeviceTempleteDataModel>();
  final isTemplateVideoPlaying = false.obs;
  final isDownloading = true.obs;

  final mediaItems = Rxn<List<Carousal>>();
  final downloader = FileDownloader();

  final hasShownToast = false.obs;

  @override
  void onInit() async {
    socketService.initSocket(d: templateData);
    super.onInit();

    log("${socketService.isSocketConnected.value}", name: "isSocketConnected");
  }

  Future<DeviceTempleteDataModel?> deviceTempData() async {
    var data = await ApiServices.instance.deviceTempData();
    templateData.value = data;
    return data;
  }

  Future<Carousal?> getSavedImg(String img, {String cat = 'background'}) async {
    final saved = await downloader.loadFromSharedPrefs();
    // return saved.firstWhereOrNull((item) => item.category == img);
    return saved.firstWhere(
      (item) => item.file == img && item.category == 'background',
      orElse: () => Carousal(), // ← same fix here
    );
  }

  Future setSavedImg(String img, {String category = "background"}) async {
    return await downloader.downloadFile(
      Carousal(
        sequence: "$category-1",
        file: img,
        fileType: "image",
      ),
      category: category,
    );
  }

  Future logOut() async {
    var data = await ApiServices.instance.logOut(logOutFxn: () async {
      log("data==> logOut", name: "logOut");
      await downloader.clearAllDownloadedFiles();
      socketService.closeSocket();
    });

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
