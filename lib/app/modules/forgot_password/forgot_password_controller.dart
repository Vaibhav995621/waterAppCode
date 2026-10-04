import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utlis/network/repositories/auth_repository.dart';
import '../../../utlis/progress_hud/app_snackbar.dart';

import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppSnackbar.error("Please enter your email address.");
      return;
    }

    try {
      isLoading.value = true;
      final response = await _repo.sendOtpForgotPassword(
        mobile: '',
        email: email,
      );

      if (response.statusCode == '200') {
        final otp = response.data?.otp;
        AppSnackbar.success(
          "OTP sent successfully.${otp != null ? ' Verification OTP is $otp.' : ''}",
        );

        final resolvedMobile = response.data?.mobile ?? '';
        final resolvedEmail = (response.data?.email != null && response.data!.email!.isNotEmpty)
            ? response.data!.email!
            : email;

        // Clear text field
        emailController.clear();

        // Navigate to verify OTP screen
        Get.toNamed(
          AppRoutes.verifyOtp,
          arguments: {
            'mobile': resolvedMobile,
            'email': resolvedEmail,
          },
        );
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
    emailController.dispose();
    super.onClose();
  }
}