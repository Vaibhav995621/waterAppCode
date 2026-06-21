import 'package:get/get.dart';
import 'package:zourney/app/welcom_screen/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
  }
}