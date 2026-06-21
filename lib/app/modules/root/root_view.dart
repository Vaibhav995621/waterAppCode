//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../global_controller/app_controller.dart';
// import '../customer/home/customer_home_view.dart';
// import '../admin/dashboard/admin_dashboard_view.dart';
// import '../delivery/home/delivery_order_list_model.dart';
//
// class RootView extends StatelessWidget {
//   final controller = Get.find<AppController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       switch (controller.role.value) {
//         case UserRole.customer:
//           return CustomerHomeScreen();
//         case UserRole.admin:
//           return AdminDashboardView();
//         case UserRole.delivery:
//           return DeliveryHomeView();
//       }
//     });
//   }
// }
