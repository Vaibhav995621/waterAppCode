import 'package:get/get.dart';
import 'signup_verify_otp_controller.dart';

class SignupVerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupVerifyOtpController>(
      () => SignupVerifyOtpController(),
    );
  }
}
