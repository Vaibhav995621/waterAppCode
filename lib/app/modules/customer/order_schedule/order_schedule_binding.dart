import 'package:get/get.dart';
import 'order_schedule_controller.dart';

class OrderScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderScheduleController>(() => OrderScheduleController());
  }
}
