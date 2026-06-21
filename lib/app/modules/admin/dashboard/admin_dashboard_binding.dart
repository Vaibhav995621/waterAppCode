import 'package:get/get.dart';
import 'package:zourney/app/modules/admin/dashboard/admin_dashboard_controller.dart';
import 'package:zourney/app/modules/customer/addresss_list/address_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
  }
}