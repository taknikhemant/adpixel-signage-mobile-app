import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NoIniternetScreen extends StatelessWidget {
  const NoIniternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/svg/noun-no-internet.svg",
              height: 300.r,
            ),
            Text(
              "No internet connection or server unreachable. Please check your connection and retry. If the issue continues, please contact support or maintenance.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 50.sp),
            )
          ],
        ),
      ),
    );
  }
}
