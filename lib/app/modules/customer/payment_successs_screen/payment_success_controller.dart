import 'package:get/get.dart';
import '../../../global_controller/bottomTabBar/main_navigation_screen.dart';

class PaymentSuccessController extends GetxController {
  RxString amount = "₹0".obs;
  RxString type = "online".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    amount.value = "₹${args?["amount"] ?? ""}";
    type.value = args?["type"]?.toString() ?? "online";
  }

  void goToHome() {
    Get.offAll(() => const MainNavigationScreen());
  }
}