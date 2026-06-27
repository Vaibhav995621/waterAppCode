import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import '../../../utlis/network/repositories/auth_repository.dart';
import '../../../utlis/progress_hud/app_snackbar.dart';
import '../../app_session/app_session.dart';

class ChangePasswordController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool hideOld = true.obs;
  RxBool hideNew = true.obs;
  RxBool hideConfirm = true.obs;

  void toggleOld() {
    hideOld.value = !hideOld.value;
  }

  void toggleNew() {
    hideNew.value = !hideNew.value;
  }

  void toggleConfirm() {
    hideConfirm.value = !hideConfirm.value;
  }

  Future<void> changePassword(BuildContext context) async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      AppSnackbar.error("Please enter current password");
      return;
    }
    if (oldPassword.length < 6) {
      AppSnackbar.error("Current password must be at least 6 characters");
      return;
    }

    if (newPassword.isEmpty) {
      AppSnackbar.error("Please enter new password");
      return;
    }
    if (newPassword.length < 6) {
      AppSnackbar.error("New password must be at least 6 characters");
      return;
    }

    if (confirmPassword.isEmpty) {
      AppSnackbar.error("Please confirm your new password");
      return;
    }

    if (newPassword != confirmPassword) {
      AppSnackbar.error("Passwords do not match");
      return;
    }

    if (oldPassword == newPassword) {
      AppSnackbar.error("New password cannot be the same as current password");
      return;
    }

    final progress = ProgressHUD.of(context);
    try {
      progress?.show();

      final response = await _repo.changePassword(
        customerId: AppSession.userId,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (response.statusCode == '200') {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.back();
        AppSnackbar.success(response.message);
      } else {
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Failed to change password",
        );
      }
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      progress?.dismiss();
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}