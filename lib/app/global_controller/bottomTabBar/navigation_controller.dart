import 'package:get/get.dart';
import 'package:zourney/app/app_session/app_session.dart';
import 'package:zourney/app/modules/admin/admin_order_list/admin_order_list_controller.dart';
import 'package:zourney/app/modules/customer/home/customer_home_controller.dart';
import '../../modules/customer/order_history/orders_controller.dart';
import '../../modules/customer/pofile/profile_controller.dart';


class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;

    // Profile tab
    if (index == 0 && AppSession.role == 1) {
      Get.find<CustomerHomeController>().getProfile();
    }
    else if (index == 1 && AppSession.role == 2) {
      Get.find<ProfileController>().getProfile();
    }
    if (index == 3 && AppSession.role == 1) {
      Get.find<ProfileController>().getProfile();
    }
    else if (index == 2 && AppSession.role == 3) {
      Get.find<ProfileController>().getProfile();
    }




    // Orders tab example
    if (index == 2 && AppSession.role == 1) {
      Get.find<OrdersController>().getCustomerActiveOrder();
      Get.find<OrdersController>().getCustomerHistoryOrder();
    }
    else if (index == 1 && AppSession.role == 3) {
      Get.find<AdminOrderListController>().getOrdersApi();

    }
  }
}