import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {

  final oldPasswordController =
  TextEditingController();

  final newPasswordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

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
    hideConfirm.value =
    !hideConfirm.value;
  }

  void changePassword() {

    if (newPasswordController.text !=
        confirmPasswordController.text) {

      Get.snackbar(
        "Error",
        "Passwords do not match",
      );

      return;
    }

    Get.snackbar(
      "Success",
      "Password Updated",
      snackPosition:
      SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}