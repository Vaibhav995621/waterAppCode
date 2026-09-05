import 'package:get/get.dart';
import 'delivery_dashboard_controller.dart';

class DeliveryDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryDashboardController>(() => DeliveryDashboardController());
  }
}
