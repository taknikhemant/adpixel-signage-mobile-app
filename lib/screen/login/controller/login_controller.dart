import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../services/api_services.dart';
import '../../home/home_screen.dart';

class LoginController extends GetxController {
  // Controllers to retrieve entered values
  final TextEditingController pinController = TextEditingController();

  @override
  void onClose() {
    super.onClose();
    pinController.dispose();
  }

  // Validation logic
  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Enter a valid 10-digt mobile number';
    }
    return null;
  }

  // // Validation logic
  // String? validateOtp(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your OTP';
  //   } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
  //     return 'Enter a valid 4-digit OTP';
  //   }
  //   return null;
  // }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your pin';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Submit function
  Future<void> submitLoginForm(GlobalKey<FormState> loginFormKey) async {
    if (loginFormKey.currentState!.validate()) {
      // Form is valid, proceed further
      await ApiServices.instance
          .login(password: pinController.text)
          .then((v) => v != null && v.status == true
              ? {
                  pinController.clear(),
                  showLoginToast(isSuccess: true),
                  Get.offAll(() => HomeScreen()),
                }
              : showMessageToast(message: v!.message, isSuccess: true));
    }
  }

  void showMessageToast({required String? message, required bool isSuccess}) {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: isSuccess ? null : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showLoginToast({required bool isSuccess}) {
    Fluttertoast.showToast(
      msg: isSuccess
          ? "Login successful! Welcome back."
          : "Login failed! Please check your credentials.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: isSuccess ? null : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showOtpSentToast({bool isSuccess = true}) {
    Fluttertoast.showToast(
      msg: isSuccess
          ? "OTP sent successfully!"
          : "Failed to send OTP. Please try again.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: isSuccess ? null : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showPasswordUpdatedToast({bool isSuccess = true}) {
    Fluttertoast.showToast(
      msg: isSuccess
          ? "Password updated successfully!"
          : "Failed to update password. Please try again.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: isSuccess ? null : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
