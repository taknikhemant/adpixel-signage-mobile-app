import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget patientQueue() {
  return Container(
    color: const Color(0xFF00A254),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/svg/patients.svg",
              height: 35.r,
            ),
            SizedBox(
              width: 6.w,
            ),
            Text(
              'PATIENT QUEUE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.sp,
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
            SvgPicture.asset(
              "assets/svg/patients.svg",
              height: 35.r,
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '<-- LAST PATIENT CALL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72.r,
                          height: 72.r,
                          decoration: const ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                          child: Center(
                            child: Text(
                              '16',
                              style: TextStyle(
                                color: const Color(0xFF1C1D1E),
                                fontSize: 30.sp,
                                fontFamily: 'Roboto Condensed',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.h,
                        ),
                        Text(
                          'Patient Full Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontFamily: 'Roboto Condensed',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer()
                  ],
                ),
              ),
              Container(
                width: 2,
                color: Colors.white,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'NEXT PATIENT -->',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontFamily: 'Roboto Condensed',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72.r,
                          height: 72.r,
                          decoration: const ShapeDecoration(
                            color: Colors.red,
                            shape: OvalBorder(),
                          ),
                          child: Center(
                            child: Text(
                              '16',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontFamily: 'Roboto Condensed',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.h,
                        ),
                        Text(
                          'Patient Full Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontFamily: 'Roboto Condensed',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer()
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget opdStartSoon() {
  return Container(
    color: const Color(0xFF74F9B9),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.h, right: 20.w),
          child: Image.asset(
            "assets/svg/doctor_stethoscope.png",
            width: 100.r,
          ),
        ),
        Text(
          'OPD Will Start Very Soon.',
          style: TextStyle(
            color: const Color(0xFF1C1D1E),
            fontSize: 62.sp,
            fontFamily: 'Roboto Condensed',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

Widget onWardRound() {
  return Container(
    color: const Color(0xFFE2B522),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.h, right: 20.w),
          child: Image.asset(
            "assets/svg/doctor_stethoscope.png",
            width: 100.r,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'On Ward Rounds',
              style: TextStyle(
                height: 1,
                color: const Color(0xFF1C1D1E),
                fontSize: 62.sp,
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Will be back in 30 mins',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.sp,
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget onLeave() {
  return Container(
    color: const Color(0xFFA4A4A4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.h, right: 20.w),
          child: Image.asset(
            "assets/svg/doctor_stethoscope.png",
            width: 100.r,
            color: Colors.white,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'On Leave.',
              style: TextStyle(
                height: 1,
                color: const Color(0xFFC22D2D),
                fontSize: 62.sp,
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Next OPD Date : 12-12-2025',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.sp,
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget opdOffLine() {
  return Container(
    color: const Color(0xFF5C5C5C),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.h, right: 20.w),
          child: Image.asset(
            "assets/svg/doctor_stethoscope.png",
            width: 100.r,
            color: Colors.white,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'OPD Off-line',
              style: TextStyle(
                height: 1,
                color: Colors.white,
                fontSize: 62.sp,
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Will start tomorrow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.sp,
                fontFamily: 'Roboto Condensed',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
