import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../models/device_templete_data_model.dart';
import '../widget/carousel_slider_download_widget.dart';

class SchoolTemp extends StatefulWidget {
  final Rxn<DeviceTempleteDataModel>? tempData;
  const SchoolTemp({this.tempData, super.key});

  @override
  State<SchoolTemp> createState() => _SchoolTempState();
}

class _SchoolTempState extends State<SchoolTemp> {
  final homeController = Get.find<HomeController>();

  String localBgPath = "";
  bool isBgDownloading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final bgUrl = widget.tempData!.value!.data!.informations!.backGroundImage;
      if (mounted) {
        setState(() {
          isBgDownloading = true;
        });
      }
      if (bgUrl != null && bgUrl.isNotEmpty) {
        final savedFiles =
            await homeController.downloader.loadFromSharedPrefs();

        // Check if already saved background file exists
        final existing = savedFiles.firstWhere(
          (e) => e.file == bgUrl && e.category == 'background',
          orElse: () =>
              Carousal(), // ← Fix: must return a valid Carousal object
        );

        final isAlreadySaved =
            existing.file == bgUrl && existing.localFile != null;
        log("isAlreadySaved:$isAlreadySaved", name: "medical temp");
        // Delete any old background files not matching the current one
        for (final item in savedFiles) {
          if (item.category == 'background' && item.file != bgUrl) {
            await homeController.downloader.removeFile(item);
          }
        }

        if (!isAlreadySaved) {
          await homeController.setSavedImg(bgUrl);
        }

        // Load updated list to get new path
        final bgItem = await homeController.getSavedImg(bgUrl);
        log("bgItem:$bgItem", name: "medical temp");

        if (mounted && bgItem!.localFile != null) {
          setState(() {
            isBgDownloading = false;
            localBgPath = bgItem.localFile!;
          });
        }
        log("$localBgPath", name: "medical temp");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
              color: const Color(0xffE8E4FF),
              image: (isBgDownloading == true ||
                      localBgPath.isEmpty ||
                      !File(localBgPath).existsSync())
                  ? null
                  : DecorationImage(
                      image: FileImage(File(localBgPath)),
                      fit: BoxFit.fill,
                    ),
            ),
            padding: EdgeInsets.only(
                left: 100.w, right: 100.w, top: 400.h, bottom: 100.h),
            child: const Column(
              children: [
                CarouselSliderDownloadWidget(
                  expandeFlex: 1,
                  autoScrollSingleFile: false,
                  // mediaItems: tempData!.value!.data!.carousal,
                ),
              ],
            ),
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
