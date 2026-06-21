import 'package:get/get.dart';
import 'payment_success_controller.dart';

class PaymentSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentSuccessController>(
          () => PaymentSuccessController(),
    );
  }
}