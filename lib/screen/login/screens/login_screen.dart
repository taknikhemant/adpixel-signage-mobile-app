import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common/login_common_widget.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final loginController = Get.put(LoginController());
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100.w),
        child: Form(
          key: loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Row(
                children: [
                  Image.asset(
                    "assets/logo/signagePixel_logo.png",
                    width: 850.w,
                  ),
                ],
              ),
              SizedBox(
                height: 60.h,
              ),
              buildInputField(
                controller: loginController.pinController,
                validator: loginController.validatePassword,
                label: "Enter Pin",
                hintText: "Please enter pin",
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 50.h),
              ElevatedButton(
                onPressed: () async {
                  await loginController.submitLoginForm(loginFormKey);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    backgroundColor: const Color(0xff1E1E1E),
                    minimumSize: Size(Get.width, 100.h)),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 60.sp),
                ),
              ),
              const Spacer(),
              Text.rich(
                style: TextStyle(fontSize: 40.sp),
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "A Property of ",
                    ),
                    TextSpan(
                      text: "ADSL Technologies Pvt. Ltd.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 42.sp),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "assets/logo/adpixel_without_back.png",
                fit: BoxFit.contain,
                // height: 350.r,
                width: 400.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
