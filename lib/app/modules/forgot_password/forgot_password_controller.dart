import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utlis/network/repositories/auth_repository.dart';
import '../../../utlis/progress_hud/app_snackbar.dart';

import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final TextEditingController mobileController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> sendOtp() async {
    final mobile = mobileController.text.trim();
    if (mobile.isEmpty) {
      AppSnackbar.error("Please enter your mobile number.");
      return;
    }

    try {
      isLoading.value = true;
      final response = await _repo.sendOtpForgotPassword(mobile: mobile);

      if (response.statusCode == '200') {
        final otp = response.data?.otp;
        AppSnackbar.success(
          "OTP sent successfully.${otp != null ? ' Verification OTP is $otp.' : ''}",
        );
        
        // Clear text field
        mobileController.clear();

        // Navigate to verify OTP screen
        Get.toNamed(AppRoutes.verifyOtp, arguments: mobile);
      } else {
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Failed to send OTP",
        );
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }
}