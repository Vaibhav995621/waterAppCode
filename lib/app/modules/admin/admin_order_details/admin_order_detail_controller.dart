/// ===============================
/// admin_order_details_controller.dart
/// ===============================
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class AdminOrderDetailsController extends GetxController {
  Rxn<Order> order = Rxn<Order>();
  void assignDeliveryBoy() {
    Get.toNamed(
      AppRoutes.adminAssignDelivery,
      arguments: order.value,
    );
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
      order.value = Get.arguments as Order;
    }
  }



}