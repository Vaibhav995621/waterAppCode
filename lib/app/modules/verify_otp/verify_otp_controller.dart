import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';

class VerifyOtpController extends GetxController {
  final FocusNode otp1Focus = FocusNode();
  final FocusNode otp2Focus = FocusNode();
  final FocusNode otp3Focus = FocusNode();
  final FocusNode otp4Focus = FocusNode();

  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthRepository _repo = AuthRepository();
  late final String mobile;

  final RxBool isLoading = false.obs;
  final RxBool showNewPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    mobile = Get.arguments as String? ?? '';
  }

  Future<void> verifyOtp() async {
    final otp = "${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}".trim();
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (otp.length < 4) {
      AppSnackbar.error("Please enter the 4-digit OTP.");
      return;
    }

    if (newPassword.isEmpty) {
      AppSnackbar.error("Please enter a new password.");
      return;
    }

    if (newPassword.length < 6) {
      AppSnackbar.error("Password must be at least 6 characters.");
      return;
    }

    if (newPassword != confirmPassword) {
      AppSnackbar.error("Passwords do not match.");
      return;
    }

    try {
      isLoading.value = true;
      final response = await _repo.forgotPasswordReset(
        mobile: mobile,
        newPassword: newPassword,
        otp: otp,
      );

      if (response.statusCode == '200') {
        FocusManager.instance.primaryFocus?.unfocus();
        AppSnackbar.success("Password reset successfully. Please login with your new password.");
        Future.delayed(const Duration(seconds: 2), () {
          Get.until((route) => route.settings.name == AppRoutes.login);
        });
      } else {
        isLoading.value = false;
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Failed to reset password",
        );
      }
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    }
  }

  final RxBool isResending = false.obs;

  Future<void> resendOtp() async {
    if (mobile.isEmpty) {
      AppSnackbar.error("Invalid mobile number.");
      return;
    }

    try {
      isResending.value = true;
      final response = await _repo.resendOtp(mobile: mobile);

      if (response.statusCode == '200') {
        final otp = response.data?.otp;
        AppSnackbar.success(
          "OTP resent successfully.${otp != null ? ' Verification OTP is $otp.' : ''}",
        );
        
        // Clear previous input digits
        otp1Controller.clear();
        otp2Controller.clear();
        otp3Controller.clear();
        otp4Controller.clear();
      } else {
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Failed to resend OTP",
        );
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();

    otp1Focus.dispose();
    otp2Focus.dispose();
    otp3Focus.dispose();
    otp4Focus.dispose();

    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
