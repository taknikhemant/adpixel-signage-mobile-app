import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:signage_pixel/utils/extensions/hex_color_extension.dart';

import '../../../services/socket_service.dart';
import '../controller/home_controller.dart';
import '../models/device_templete_data_model.dart';
import '../widget/carousel_slider_download_widget.dart';
import '../widget/medical_temp2_widgets.dart';

class MedicalTemp2 extends StatefulWidget {
  final Rxn<DeviceTempleteDataModel>? tempData;

  const MedicalTemp2({super.key, required this.tempData});

  @override
  State<MedicalTemp2> createState() => _MedicalTemp2State();
}

class _MedicalTemp2State extends State<MedicalTemp2> {
  final SocketService socketService = Get.find();
  final homeController = Get.find<HomeController>();

  String localBgPath = "";
  bool isBgDownloading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final bgUrl = widget.tempData?.value?.data?.informations?.docAvtar;
      if (mounted) {
        setState(() {
          isBgDownloading = true;
        });
      }
      if (bgUrl != null && bgUrl.isNotEmpty) {
        final savedFiles = await homeController.downloader.loadFromSharedPrefs();

        final existing = savedFiles.firstWhere(
          (e) => e.file == bgUrl && e.category == 'background',
          orElse: () => Carousal(),
        );

        final isAlreadySaved = existing.file == bgUrl && existing.localFile != null;
        log("isAlreadySaved:$isAlreadySaved", name: "medical temp");

        for (final item in savedFiles) {
          if (item.category == 'background' && item.file != bgUrl) {
            await homeController.downloader.removeFile(item);
          }
        }

        if (!isAlreadySaved) {
          await homeController.setSavedImg(bgUrl);
        }

        final bgItem = await homeController.getSavedImg(bgUrl);
        log("bgItem:$bgItem", name: "medical temp");

        if (mounted && bgItem?.localFile != null) {
          setState(() {
            isBgDownloading = false;
            localBgPath = bgItem!.localFile!;
          });
        }
        log("$localBgPath", name: "medical temp");
      }
    });
  }

  @override
  void dispose() {
    localBgPath = "";
    isBgDownloading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      log("bg: (isEmpty:${localBgPath.isEmpty} | downloading:$isBgDownloading | exists:${localBgPath.isNotEmpty && File(localBgPath).existsSync()})",
          name: "MedicalTemp2");

      final appearance = widget.tempData?.value?.data?.device?.deviceAppearance;
      final primaryColor = appearance?.primaryBgColor?.toColor() ?? const Color(0xffE8E4FF);
      final secondaryColor = appearance?.secondaryBgColor?.toColor() ?? const Color(0xFFD8D3F5);
      final fgTextColor = appearance?.textColor?.toColor() ?? Colors.black;
      final fgIconColor = appearance?.iconColor?.toColor() ?? const Color(0xff3F2381);

      final info = widget.tempData!.value!.data!.informations!;
      final specializations = (info.docOtherSpecialization ?? '')
          .split(';')
          .where((e) => e.trim().isNotEmpty)
          .toList();

      return Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: primaryColor,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.only(top: 30.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "${info.docName}",
                                style: TextStyle(
                                  color: fgTextColor,
                                  fontSize: 52.sp,
                                  fontFamily: 'Roboto Condensed',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                margin: EdgeInsets.symmetric(horizontal: 30.w),
                                width: Get.width,
                                decoration: ShapeDecoration(
                                  color: secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${info.docSpecialist}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: fgTextColor,
                                    fontSize: 38.sp,
                                    fontFamily: 'Roboto Condensed',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                    top: 20.h,
                                    right: 30.w,
                                    left: 30.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...specializations.map(
                                        (e) => Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 6.h),
                                              child: SvgPicture.asset(
                                                "assets/svg/noun-arrow.svg",
                                                height: 25.r,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                " ${e.trim()}",
                                                style: TextStyle(
                                                  color: fgTextColor,
                                                  fontSize: 32.sp,
                                                  fontFamily: 'Roboto Condensed',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0.995,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(color: fgIconColor, height: 1),
                              SizedBox(height: 8.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Column(
                                  children: [
                                    Text(
                                      'OPD Details',
                                      style: TextStyle(
                                        color: fgTextColor,
                                        fontSize: 34.sp,
                                        height: 0.9,
                                        fontFamily: 'Roboto Condensed',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color: fgIconColor,
                                          size: 50.r,
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          info.docOpdDays
                                                  ?.split(";")
                                                  .map((e) => e.trim())
                                                  .join('\n') ??
                                              '',
                                          style: TextStyle(
                                            color: fgTextColor,
                                            fontSize: 30.sp,
                                            fontFamily: 'Roboto Condensed',
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          color: fgIconColor,
                                          size: 50.r,
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          info.docOpdTime
                                                  ?.split(";")
                                                  .map((e) => e.trim())
                                                  .join('\n') ??
                                              '',
                                          style: TextStyle(
                                            color: fgTextColor,
                                            fontSize: 30.sp,
                                            fontFamily: 'Roboto Condensed',
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            image: (isBgDownloading ||
                                    localBgPath.isEmpty ||
                                    !File(localBgPath).existsSync())
                                ? null
                                : DecorationImage(
                                    image: FileImage(File(localBgPath)),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          child: Center(
                            child: Text(
                              isBgDownloading ? "Downloading.." : "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: info.opdStatus == "1"
                    ? patientQueue()
                    : info.opdStatus == "2"
                        ? opdStartSoon()
                        : info.opdStatus == "3"
                            ? onWardRound()
                            : info.opdStatus == "4"
                                ? onLeave()
                                : info.opdStatus == "5"
                                    ? opdOffLine()
                                    : info.opdStatus == "6"
                                        ? opdONLine()
                                        : opdOffLine(),
              ),
              const CarouselSliderDownloadWidget(
                expandeFlex: 4,
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
      );
    });
  }
}
