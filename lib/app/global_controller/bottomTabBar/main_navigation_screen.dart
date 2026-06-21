import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/modules/admin/admin_order_list/admin_order_list_view.dart';
import 'package:zourney/app/modules/admin/dashboard/admin_dashboard_view.dart';
import 'package:zourney/app/modules/customer/booking_order/book_water_screen.dart';
import 'package:zourney/app/modules/customer/home/customer_home_view.dart';
import 'package:zourney/app/modules/customer/order_history/order_view.dart';
import 'package:zourney/app/modules/customer/order_history/orders_controller.dart';
import 'package:zourney/app/modules/customer/pofile/profile_view.dart';
import '../../app_session/app_session.dart';
import '../../modules/customer/booking_order/book_water_controller.dart';
import '../../modules/customer/home/customer_home_controller.dart';
import '../../modules/customer/pofile/profile_controller.dart';
import '../../modules/delivery/home/delivery_order_list_controller.dart';
import '../../modules/delivery/home/delivery_order_list_view.dart';
import 'navigation_controller.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller =
    Get.put(NavigationController());
    Get.put(CustomerHomeController());
    Get.put(ProfileController());
    Get.put(OrdersController());
    Get.put(BookWaterController());
    Get.put(DeliveryOrderListController());


    int userType = AppSession.role;

    List<Widget> screens = [];

    if (userType == 1) {
      //customer
      screens = [
        CustomerHomeScreen(),
        BookWaterScreen(),
        OrdersView(),
        ProfileView(),
      ];
    } else if (userType == 2) {
      //delivery
      screens = [
        DeliveryOrderListView(),
        ProfileView(),
      ];

    } else if (userType == 3) {
     // admin
      screens = [
        AdminDashboardView(),
        AdminOrderListView(),
        ProfileView(),
      ];

    } else {
      // fallback
      screens = [
        const Center(child: Text("Home")),
        ProfileView(),
      ];
    }

    final items = _getNavBarItems(userType);

    // safety check
    if (controller.selectedIndex.value >= screens.length) {
      controller.selectedIndex.value = 0;
    }

    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),

      bottomNavigationBar: Obx(() {
        if (items.length < 2) {
          return const SizedBox();
        }

        return BottomNavigationBar(
          backgroundColor:  Color(0xff6B67F6),
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: items,
        );
      }),
    );
  }

  List<BottomNavigationBarItem> _getNavBarItems(int userType) {
    switch (userType) {

      case 1:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ];

      case 2:

        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ];
      case 3:
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ];


      default:
      // MUST HAVE 2 ITEMS
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
    }
  }
}