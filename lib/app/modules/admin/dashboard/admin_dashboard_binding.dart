import 'package:get/get.dart';
import 'package:zourney/app/modules/admin/dashboard/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
  }
}