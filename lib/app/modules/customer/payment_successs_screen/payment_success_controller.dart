import 'package:get/get.dart';
import '../../../global_controller/bottomTabBar/main_navigation_screen.dart';

class PaymentSuccessController extends GetxController {

  RxString amount = "₹0".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final args = Get.arguments;
    amount.value =
    "₹${args?["amount"] ?? ""}";
  }

  void goToHome() {
    Get.offAll(() => const MainNavigationScreen());

  }
}