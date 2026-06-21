import 'package:get/get.dart';
import 'package:zourney/app/modules/admin/admin_order_list/admin_order_list_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminOrderListController>(() => AdminOrderListController());
  }
}