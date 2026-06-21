import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController
    extends GetxController {

  TextEditingController mobileController =
  TextEditingController();

  void sendOtp() {

    if (mobileController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Enter mobile number",
      );

      return;
    }

    Get.snackbar(
      "Success",
      "OTP sent successfully",
    );
  }

  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }
}