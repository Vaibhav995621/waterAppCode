import 'package:get/get.dart';
import 'package:zourney/app/modules/customer/subscription_history_list/subscription_history_controller.dart';

class SubscriptionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionHistoryController>(() => SubscriptionHistoryController());
  }
}