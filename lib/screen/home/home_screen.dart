import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:signage_pixel/screen/base/screens/no_internet_screen.dart';
import 'package:signage_pixel/screen/home/templates/no_template_found.dart';
import 'controller/home_controller.dart';
import 'models/device_templete_data_model.dart';
import 'templates/medical_temp2.dart';
import 'templates/retailer_template.dart';
import 'templates/school_temp.dart';

// "ed1f51de-2d13-4bf7-bb9d-3c42ef93f0f0" for opd or hospital
// "c9247836-2243-4f40-acfb-be5d2dc15a9d" for retail

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
            () => homeFunction(homeController.socketService.refreshKey.value)));
  }

  Widget homeFunction(int refreshKey) {
    return FutureBuilder(
      key: ValueKey(refreshKey), // Important: forces FutureBuilder to refresh
      future: homeController.deviceTempData(),
      builder: (context, AsyncSnapshot<DeviceTempleteDataModel?> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snap.hasError && snap.data == null) {
          return NoInternetScreen();
        } else if (snap.data == null) {
          return Center(
            child: Text(
              "Something went wrong.\nPlease check your internet or contact tech team.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50.sp,
              ),
            ),
          );
        } else {
          final templateId = snap.data!.data!.device!.templateId;

          if (templateId == "ed1f51de-2d13-4bf7-bb9d-3c42ef93f0f0") {
            return MedicalTemp2(tempData: homeController.templateData);
          } else if (templateId == "c9247836-2243-4f40-acfb-be5d2dc15a9d") {
            return RetailerTemplate(tempData: homeController.templateData);
          } else if (templateId == "66e246dd-df30-4044-8ef0-a6c46d41b9b7" ||
              templateId == "f2f8deb3-f8f6-4d60-a08a-62a66efda861") {
            return SchoolTemp(
              tempData: homeController.templateData,
              isTemp2: true,
            );
          } else {
            return NoTemplateFound();
          }
        }
      },
    );
  }
}
