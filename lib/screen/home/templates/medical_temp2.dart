import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:signage_pixel/screen/home/widget/carousel_slider_widget.dart';
import 'package:signage_pixel/utils/extensions/hex_color_extension.dart';

import '../models/device_templete_data_model.dart';
import '../widget/medical_temp2_widgets.dart';

class MedicalTemp2 extends StatelessWidget {
  final DeviceTempleteDataModel? tempData;
  const MedicalTemp2({super.key, required this.tempData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: tempData!.data!.device!.deviceAppearance != null
                ? tempData!.data!.device!.deviceAppearance!.primaryBgColor!
                    .toColor()
                : const Color(0xffE8E4FF),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: NetworkImage(
            //         "https://img.freepik.com/free-vector/demo-concept-illustration_114360-7492.jpg?t=st=1735030249~exp=1735033849~hmac=fe06557056f49dc1aa6215be59d639c9a8d87ceeb624ee4718e6ca68f3b73dd7&w=740"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "${tempData!.data!.informations!.docName}",
                          style: TextStyle(
                              color: tempData!.data!.device!.deviceAppearance !=
                                      null
                                  ? tempData!.data!.device!.deviceAppearance!
                                      .textColor!
                                      .toColor()
                                  : Colors.black,
                              fontSize: 50.sp,
                              fontFamily: 'Roboto Condensed',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          margin: EdgeInsets.symmetric(horizontal: 30.w),
                          width: Get.width,
                          decoration: ShapeDecoration(
                            color:
                                tempData!.data!.device!.deviceAppearance != null
                                    ? tempData!.data!.device!.deviceAppearance!
                                        .secondaryBgColor!
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
                              )
                            ],
                          ),
                          child: Text(
                            '${tempData!.data!.informations!.docSpecialist}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: tempData!.data!.device!.deviceAppearance !=
                                      null
                                  ? tempData!.data!.device!.deviceAppearance!
                                      .textColor!
                                      .toColor()
                                  : Colors.black,
                              fontSize: 40.sp,
                              fontFamily: 'Roboto Condensed',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: 20.h, right: 30.w, left: 30.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...tempData!
                                    .data!.informations!.docOtherSpecialization!
                                    .split(",")
                                    .map(
                                      (e) => Text(
                                        '-> ${e.trim()}',
                                        style: TextStyle(
                                          color: tempData!.data!.device!
                                                      .deviceAppearance !=
                                                  null
                                              ? tempData!.data!.device!
                                                  .deviceAppearance!.textColor!
                                                  .toColor()
                                              : Colors.black,
                                          fontSize: 32.sp,
                                          fontFamily: 'Roboto Condensed',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          color: Color(0xff3F2381),
                          height: 1,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Column(
                            children: [
                              Text(
                                'OPD Details',
                                style: TextStyle(
                                  color: tempData!
                                              .data!.device!.deviceAppearance !=
                                          null
                                      ? tempData!.data!.device!
                                          .deviceAppearance!.textColor!
                                          .toColor()
                                      : Colors.black,
                                  fontSize: 35.sp,
                                  fontFamily: 'Roboto Condensed',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: tempData!.data!.device!
                                                .deviceAppearance !=
                                            null
                                        ? tempData!.data!.device!
                                            .deviceAppearance!.iconColor!
                                            .toColor()
                                        : const Color(0xff3F2381),
                                    size: 50.r,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    tempData!.data!.informations!.docOpdDays!
                                        .trim(),
                                    style: TextStyle(
                                      color: tempData!.data!.device!
                                                  .deviceAppearance !=
                                              null
                                          ? tempData!.data!.device!
                                              .deviceAppearance!.textColor!
                                              .toColor()
                                          : Colors.black,
                                      fontSize: 30.sp,
                                      fontFamily: 'Roboto Condensed',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    color: tempData!.data!.device!
                                                .deviceAppearance !=
                                            null
                                        ? tempData!.data!.device!
                                            .deviceAppearance!.iconColor!
                                            .toColor()
                                        : const Color(0xff3F2381),
                                    size: 50.r,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    (() {
                                      if (tempData?.data?.informations
                                              ?.docOpdTime !=
                                          null) {
                                        var opdTimes = tempData!
                                            .data!.informations!.docOpdTime!
                                            .split(",")
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
                                      color: tempData!.data!.device!
                                                  .deviceAppearance !=
                                              null
                                          ? tempData!.data!.device!
                                              .deviceAppearance!.textColor!
                                              .toColor()
                                          : Colors.black,
                                      fontSize: 30.sp,
                                      fontFamily: 'Roboto Condensed',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
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
                      color: tempData!.data!.device!.deviceAppearance != null
                          ? tempData!
                              .data!.device!.deviceAppearance!.primaryBgColor!
                              .toColor()
                          : const Color(0xffE8E4FF),
                      image: DecorationImage(
                        image: NetworkImage(
                            tempData!.data!.informations!.docAvtar!),
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
          child: tempData!.data!.device!.opdStatus == "1"
              ? patientQueue()
              : tempData!.data!.device!.opdStatus == "2"
                  ? opdStartSoon()
                  : tempData!.data!.device!.opdStatus == "3"
                      ? onWardRound()
                      : tempData!.data!.device!.opdStatus == "4"
                          ? onLeave()
                          : tempData!.data!.device!.opdStatus == "5"
                              ? opdOffLine()
                              : opdOffLine(),
        ),
        CarouselSliderWidget(
          expandeFlex: 4,
          mediaItems: tempData!.data!.carousal,
        ),
      ],
    );
  }
}
