import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signage_pixel/screen/home/templates/no_templete_found.dart';
import 'controller/home_controller.dart';
import 'models/device_templete_data_model.dart';
import 'templates/medical_temp2.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: homeController.deviceTempData(),
          builder: (context, AsyncSnapshot<DeviceTempleteDataModel?> snap) {
            return snap.data == null
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    top: true,
                    child: snap.data!.data!.device!.templateId ==
                            "ed1f51de-2d13-4bf7-bb9d-3c42ef93f0f0"
                        ? MedicalTemp2(
                            tempData: homeController.templateData,
                          )
                        : const NoTempleteFound());
          }),
    );
  }
}
