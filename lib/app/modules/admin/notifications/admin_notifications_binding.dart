import 'package:get/get.dart';
import 'admin_notifications_controller.dart';

class AdminNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminNotificationsController>(() => AdminNotificationsController());
  }
}
