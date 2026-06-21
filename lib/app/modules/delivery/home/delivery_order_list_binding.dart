import 'package:get/get.dart';
import '../delivery_order_detail/order_detail_controller.dart';
import 'delivery_order_list_controller.dart';


class DeliveryOrdersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryOrderListController>(
          () => DeliveryOrderListController(),
    );
  }
}