import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 60.h, right: 30.w, left: 30.w),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 320.w,
                    height: 400.h,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Text(
                        'Dr. Photo',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Ritvik Agarwal',
                          style: TextStyle(
                            fontSize: 55.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'General Physician, Medical School Of London',
                          style:
                              TextStyle(fontSize: 35.sp, color: Colors.black87),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Availability Status',
                          style: TextStyle(fontSize: 45.sp),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'OPD Visiting hours',
                          style: TextStyle(fontSize: 45.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Container(
                width: Get.width,
                height: 150.h,
                padding: EdgeInsets.all(16.r),
                color: Colors.grey.shade300,
                child: Text(
                  'Other important Notification with info graphics',
                  style: TextStyle(fontSize: 38.sp, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 5.h,
          color: Colors.black,
        ),
        Expanded(
          child: Center(
            child: Text(
              'All Facilities/OPD Slider',
              style: TextStyle(fontSize: 70.sp, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
