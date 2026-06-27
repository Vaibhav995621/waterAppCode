import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utlis/network/repositories/auth_repository.dart';
import '../../../utlis/progress_hud/app_snackbar.dart';
import '../../app_session/app_session.dart';
import '../../global_controller/bottomTabBar/main_navigation_screen.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final AuthRepository _repo = AuthRepository();
  RxBool isPasswordVisible = false.obs;

  // Text Controllers
  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final houseNoController = TextEditingController();
  final flatNoController = TextEditingController();
  final streetController = TextEditingController();
  final societyController = TextEditingController();
  final galiController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Role selection
  var selectedRole = "User".obs;

  void setRole(String role) {
    selectedRole.value = role;
  }

  // Validation Methods
  String? validateRequired(String value, String field) {
    if (value.isEmpty) return "$field is required";
    return null;
  }

  String? validateMobile(String value) {
    if (value.isEmpty) return "Mobile number is required";
    if (value.length != 10) return "Enter valid 10 digit number";
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Minimum 6 characters required";
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  // void register() {
  //   if (formKey.currentState!.validate()) {
  //     print("Role: ${selectedRole.value}");
  //     print("Name: ${fullNameController.text}");
  //     print("Mobile: ${mobileController.text}");
  //
  //     Get.snackbar("Success", "Registered Successfully");
  //   }
  // }

  Future<bool> register() async {
    if (formKey.currentState!.validate()) {
      try {
        final user = await _repo.registerApi(
          userName: '',
          fullName: fullNameController.text.isEmpty
              ? ""
              : fullNameController.text,
          fullAddress: addressController.text.isEmpty
              ? ""
              : addressController.text,
          houseNumber: houseNoController.text.trim().isEmpty
              ? ""
              : houseNoController.text.trim(),
          flatNumber: flatNoController.text.trim().isEmpty
              ? ""
              : flatNoController.text,

          societyName: societyController.text.trim().isEmpty
              ? ""
              : societyController.text,
          galiNumber: galiController.text.trim().isEmpty
              ? ""
              : galiController.text.trim(),
          landmark: landmarkController.text.trim().isEmpty
              ? ""
              : landmarkController.text.trim(),
          city: cityController.text.trim().isEmpty
              ? ""
              : cityController.text.trim(),

          state: stateController.text.trim().isEmpty
              ? ""
              : stateController.text.trim(),
          photo: '',
          pinCode: pinCodeController.text.trim().isEmpty
              ? ""
              : pinCodeController.text.trim(),
          password: passwordController.text.trim().isEmpty
              ? ""
              : passwordController.text.trim(),

          mobile: mobileController.text.trim().isEmpty
              ? ""
              : mobileController.text.trim(),

          email: '',
          role:  "1"
        );

        /// ✅ Handle API-level failure
        if (user.statusCode == '201') {
          AppSnackbar.error(user.message);
          return false;
        }

        /// ✅ Navigation
        if (user.statusCode == "200") {
          await AppSession.saveUser(
              userId: user.data.id.toString(),
              token: '',
              image: user.data.photo,
              name: user.data.fullname,
              role: user.data.role,
              planType: user.data.plandetail.id
          );
          Get.offAll(() => const MainNavigationScreen());
        }
        return true;
      } catch (e) {
        final message = e.toString().replaceAll("Exception: ", "");
        AppSnackbar.error(message);
        return false;
      } finally {
        // isLoading.value = false;
      }
    }
    return false;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
