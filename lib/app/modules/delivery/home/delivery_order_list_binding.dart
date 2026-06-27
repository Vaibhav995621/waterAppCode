import 'package:get/get.dart';
import 'delivery_order_list_controller.dart';


class DeliveryOrdersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryOrderListController>(
          () => DeliveryOrderListController(),
    );
  }
}