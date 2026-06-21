import 'package:get/get.dart';
import 'package:zourney/app/modules/customer/subscription_plan/bottle_subscription_controller.dart';

class BottleSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottleSubscriptionController());
  }
}