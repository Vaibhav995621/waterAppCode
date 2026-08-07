import 'package:get/get.dart';
import 'schedule_orders_list_controller.dart';

class ScheduleOrdersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleOrdersListController>(
      () => ScheduleOrdersListController(),
    );
  }
}
