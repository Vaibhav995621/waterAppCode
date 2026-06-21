import 'package:get/get.dart';

import 'payment_history_controller.dart';

class PaymentHistoryBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<PaymentHistoryController>(
          () => PaymentHistoryController(),
    );

  }
}