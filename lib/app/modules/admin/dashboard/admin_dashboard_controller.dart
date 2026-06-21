import 'package:get/get.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/Admin/admin_dashboard/admin_dashboard_model.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class AdminDashboardController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  RxBool isLoading = false.obs;

  RxInt totalOrders = 0.obs;
  RxInt activeOrders = 0.obs;
  RxInt completedOrders = 0.obs;
  RxInt cancelledOrders = 0.obs;
  RxInt totalRevenue = 0.obs;

  RxList<Order> recentOrders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    adminDashboardApi();
  }

  Future<void> adminDashboardApi() async {
    try {
      isLoading.value = true;

      final response = await _repo.adminDashboardApi();

      if (response.statusCode == '200') {
        totalOrders.value = response.data.totalOrders;
        activeOrders.value = response.data.totalActiveOrders;
        completedOrders.value = response.data.totalCompletedOrders;
        cancelledOrders.value = response.data.totalCancelledOrders;
        totalRevenue.value = response.data.totalEarning;

        recentOrders.assignAll(response.data.recentOrder);
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      isLoading.value = false;
    }
  }

}