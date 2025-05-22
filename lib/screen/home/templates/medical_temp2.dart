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

class MedicalTemp2 extends StatelessWidget {
  final Rxn<DeviceTempleteDataModel>? tempData;
  final SocketService socketService = Get.find();
  MedicalTemp2({super.key, required this.tempData});
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: tempData!.value!.data!.device!.deviceAppearance != null
                      ? tempData!.value!.data!.device!.deviceAppearance!
                          .primaryBgColor!
                          .toColor()
                      : const Color(0xffE8E4FF),
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
                                "${tempData!.value!.data!.informations!.docName}",
                                style: TextStyle(
                                  color: tempData!.value!.data!.device!
                                              .deviceAppearance !=
                                          null
                                      ? tempData!.value!.data!.device!
                                          .deviceAppearance!.textColor!
                                          .toColor()
                                      : Colors.black,
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
                                  color: tempData!.value!.data!.device!
                                              .deviceAppearance !=
                                          null
                                      ? tempData!.value!.data!.device!
                                          .deviceAppearance!.secondaryBgColor!
                                          .toColor()
                                      : const Color(0xFFD8D3F5),
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
                                  '${tempData!.value!.data!.informations!.docSpecialist}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: tempData!.value!.data!.device!
                                                .deviceAppearance !=
                                            null
                                        ? tempData!.value!.data!.device!
                                            .deviceAppearance!.textColor!
                                            .toColor()
                                        : Colors.black,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...tempData!.value!.data!.informations!
                                          .docOtherSpecialization!
                                          .split(";")
                                          .map(
                                            (e) => Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 6.h),
                                                  child: SvgPicture.asset(
                                                    "assets/svg/noun-arrow.svg",
                                                    height: 25.r,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    " ${e.trim()}",
                                                    style: TextStyle(
                                                      color: tempData!
                                                                  .value!
                                                                  .data!
                                                                  .device!
                                                                  .deviceAppearance !=
                                                              null
                                                          ? tempData!
                                                              .value!
                                                              .data!
                                                              .device!
                                                              .deviceAppearance!
                                                              .textColor!
                                                              .toColor()
                                                          : Colors.black,
                                                      fontSize: 32.sp,
                                                      fontFamily:
                                                          'Roboto Condensed',
                                                      fontWeight:
                                                          FontWeight.w400,
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
                              Divider(
                                color: tempData!.value!.data!.device!
                                            .deviceAppearance !=
                                        null
                                    ? tempData!.value!.data!.device!
                                        .deviceAppearance!.iconColor!
                                        .toColor()
                                    : const Color(0xff3F2381),
                                height: 1,
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Column(
                                  children: [
                                    Text(
                                      'OPD Details',
                                      style: TextStyle(
                                        color: tempData!.value!.data!.device!
                                                    .deviceAppearance !=
                                                null
                                            ? tempData!.value!.data!.device!
                                                .deviceAppearance!.textColor!
                                                .toColor()
                                            : Colors.black,
                                        fontSize: 34.sp,
                                        height: 0.9,
                                        fontFamily: 'Roboto Condensed',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color: tempData!.value!.data!.device!
                                                      .deviceAppearance !=
                                                  null
                                              ? tempData!.value!.data!.device!
                                                  .deviceAppearance!.iconColor!
                                                  .toColor()
                                              : const Color(0xff3F2381),
                                          size: 50.r,
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          (() {
                                            if (tempData
                                                    ?.value!
                                                    .data
                                                    ?.informations
                                                    ?.docOpdDays !=
                                                null) {
                                              var opdDays = tempData!
                                                  .value!
                                                  .data!
                                                  .informations!
                                                  .docOpdDays!
                                                  .split(";")
                                                  .map((e) => e.trim())
                                                  .toList();
                                              return opdDays
                                                  .map((time) => time)
                                                  .join('\n');
                                            } else {
                                              return '';
                                            }
                                          })(),
                                          style: TextStyle(
                                            color: tempData!
                                                        .value!
                                                        .data!
                                                        .device!
                                                        .deviceAppearance !=
                                                    null
                                                ? tempData!
                                                    .value!
                                                    .data!
                                                    .device!
                                                    .deviceAppearance!
                                                    .textColor!
                                                    .toColor()
                                                : Colors.black,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          color: tempData!.value!.data!.device!
                                                      .deviceAppearance !=
                                                  null
                                              ? tempData!.value!.data!.device!
                                                  .deviceAppearance!.iconColor!
                                                  .toColor()
                                              : const Color(0xff3F2381),
                                          size: 50.r,
                                        ),
                                        SizedBox(width: 15.w),
                                        Text(
                                          (() {
                                            if (tempData
                                                    ?.value!
                                                    .data
                                                    ?.informations
                                                    ?.docOpdTime !=
                                                null) {
                                              var opdTimes = tempData!
                                                  .value!
                                                  .data!
                                                  .informations!
                                                  .docOpdTime!
                                                  .split(";")
                                                  .map((e) => e.trim())
                                                  .toList();
                                              return opdTimes
                                                  .map((time) => time)
                                                  .join('\n');
                                            } else {
                                              return '';
                                            }
                                          })(),
                                          style: TextStyle(
                                            color: tempData!
                                                        .value!
                                                        .data!
                                                        .device!
                                                        .deviceAppearance !=
                                                    null
                                                ? tempData!
                                                    .value!
                                                    .data!
                                                    .device!
                                                    .deviceAppearance!
                                                    .textColor!
                                                    .toColor()
                                                : Colors.black,
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
                          // color: Colors.yellow,
                          decoration: BoxDecoration(
                            color: tempData!.value!.data!.device!
                                        .deviceAppearance !=
                                    null
                                ? tempData!.value!.data!.device!
                                    .deviceAppearance!.primaryBgColor!
                                    .toColor()
                                : const Color(0xffE8E4FF),
                            image: DecorationImage(
                              image: NetworkImage(
                                tempData!.value!.data!.informations!.docAvtar!,
                              ),
                              fit: BoxFit.fill,
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
                child: tempData!.value!.data!.informations!.opdStatus == "1"
                    ? patientQueue()
                    : tempData!.value!.data!.informations!.opdStatus == "2"
                        ? opdStartSoon()
                        : tempData!.value!.data!.informations!.opdStatus == "3"
                            ? onWardRound()
                            : tempData!.value!.data!.informations!.opdStatus ==
                                    "4"
                                ? onLeave()
                                : tempData!.value!.data!.informations!
                                            .opdStatus ==
                                        "5"
                                    ? opdOffLine()
                                    : tempData!.value!.data!.informations!
                                                .opdStatus ==
                                            "6"
                                        ? opdONLine()
                                        : opdOffLine(),
              ),
              CarouselSliderDownloadWidget(
                expandeFlex: 4,
                mediaItems: tempData!.value!.data!.carousal,
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
