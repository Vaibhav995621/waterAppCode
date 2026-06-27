import 'package:get/get.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class DeliveryOrderDetailController extends GetxController {
  late Order order;
  final AuthRepository _repo = AuthRepository();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    order = Get.arguments as Order;
  }

  String get statusText {
    switch (order.status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Assigned';
      case 2:
        return 'Delivered';
      case 3:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
  Future<void> markAsDelivered(String orderStatus) async {
    try {
      isLoading.value = true;

      final success = await updateOrderStatus(orderStatus);

      if (success) {
        AppSnackbar.success("Order delivered successfully");

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back(result: true);
        });
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateOrderStatus(String orderStatus) async {
    try {
      final data =
      await _repo.updateOrderStatus(order.id.toString(), orderStatus);

      if (data.statusCode == "200") {
        order.status = 2;
        update(['status']);
        AppSnackbar.success(data.message);

        return true;
      }

      AppSnackbar.error(data.message);
      return false;
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
      return false;
    }
  }

}