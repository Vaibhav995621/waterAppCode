import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';

class AdminOrderDetailsController extends GetxController {
  Rxn<Order> order = Rxn<Order>();
  final AuthRepository _repo = AuthRepository();
  final RxBool isLoading = false.obs;

  void assignDeliveryBoy() {
    Get.toNamed(
      AppRoutes.adminAssignDelivery,
      arguments: order.value,
    );
  }

  Future<void> updateOrderStatus(String orderStatus) async {
    try {
      isLoading.value = true;

      final data = await _repo.updateOrderStatus(
        order.value!.id.toString(),
        orderStatus,
      );

      if (data.statusCode == "200") {
        AppSnackbar.success("Order Cancelled successfully");

        // Update local order status
        if (order.value != null) {
          order.value!.status = int.tryParse(orderStatus) ?? order.value!.status;
          order.refresh();
        }

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.back(result: true);
        });
      } else {
        AppSnackbar.error(data.message);
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      order.value = Get.arguments as Order;
    }
  }
}