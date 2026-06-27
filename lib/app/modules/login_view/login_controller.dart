import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utlis/constants/app_strings.dart';
import '../../../utlis/network/repositories/auth_repository.dart';
import '../../../utlis/progress_hud/app_snackbar.dart';
import '../../app_session/app_session.dart';
import '../../global_controller/bottomTabBar/main_navigation_screen.dart';

class LoginController extends GetxController {
  /// Controllers
  ///
  final AuthRepository _repo = AuthRepository();

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  int userType = 1;

  /// State
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  /// Toggle Password Visibility
  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  String? validateMobile(String value) {
    final v = phoneController.text.trim();

    if (v.isEmpty) return AppStrings.pleaseEnterMobile;
    if (v.length < 6) return AppStrings.mobileMinLength;
    return null;

  }
  String? validatePassword(String? val) {
    final v = passwordController.text.trim();

    if (v.isEmpty) return AppStrings.pleaseEnterPassword;
    if (v.length < 6) return AppStrings.passwordMinLength;

    return null;
  }

  Future<bool> login(BuildContext context) async {
    final progress = ProgressHUD.of(context);

    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    try {
      progress?.show();

      final mobileError = validateMobile(phone);
      final passwordError = validatePassword(password);

      if (mobileError != null) {
        AppSnackbar.error(mobileError);
        return false;
      }

      if (passwordError != null) {
        AppSnackbar.error(passwordError);
        return false;
      }

      final user = await _repo.login(
        phone,
        password,
      );

      if (user.statusCode == '201') {
        AppSnackbar.error(user.message);
        return false;
      }

      if (user.statusCode == "200") {
        await AppSession.saveUser(
          userId: user.data.id.toString(),
          token: '',
          image: user.data.photo,
          name: user.data.fullname,
          role: user.data.role,
          planType: user.data.plandetail.id,
        );

        Get.offAll(() => const MainNavigationScreen());
      } else {
        Get.offAllNamed(AppRoutes.customerHomeScreen);
      }

      return true;
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
      return false;
    } finally {
      progress?.dismiss();
    }
  }


  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}