import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../models/device_templete_data_model.dart';
import '../widget/carousel_slider_download_widget.dart';

class RetailerTemplate extends StatelessWidget {
  final Rxn<DeviceTempleteDataModel>? tempData;
  RetailerTemplate({this.tempData, super.key});
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Column(
            children: [
              CarouselSliderDownloadWidget(
                expandeFlex: 1,
                autoScrollSingleFile: false,
                // mediaItems: tempData!.value!.data!.carousal,
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
            child: const SizedBox(),
            onPressed: () async {
              await homeController.logOut();
            },
          ),
        ],
      ),
    );
  }
}
