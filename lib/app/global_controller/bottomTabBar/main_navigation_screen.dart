import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/modules/admin/admin_order_list/admin_order_list_view.dart';
import 'package:zourney/app/modules/admin/dashboard/admin_dashboard_view.dart';
import 'package:zourney/app/modules/customer/booking_order/book_water_screen.dart';
import 'package:zourney/app/modules/customer/home/customer_home_view.dart';
import 'package:zourney/app/modules/customer/order_history/order_view.dart';
import 'package:zourney/app/modules/customer/order_history/orders_controller.dart';
import 'package:zourney/app/modules/customer/pofile/profile_view.dart';
import 'package:zourney/app/modules/customer/wallet/wallet_view.dart';
import 'package:zourney/app/modules/customer/wallet/wallet_controller.dart';
import 'package:zourney/app/modules/delivery/dashboard/delivery_dashboard_controller.dart';
import 'package:zourney/app/modules/delivery/dashboard/delivery_dashboard_view.dart';
import '../../app_session/app_session.dart';
import '../../modules/admin/dashboard/admin_dashboard_controller.dart';
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
    Get.put(BookWaterController());
    Get.put(WalletController());
    Get.put(DeliveryOrderListController());
    Get.put(AdminDashboardController());
    Get.put(DeliveryDashboardController());


    int userType = AppSession.role;

    List<Widget> screens = [];

    if (userType == 1) {
      //customer
      screens = [
        CustomerHomeScreen(),
        BookWaterScreen(),
        WalletView(),
        ProfileView(),
      ];
    } else if (userType == 2) {
      //delivery
      screens = [
        DeliveryDashboardView(),
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
        DeliveryDashboardView(),
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
          unselectedItemColor: Colors.white.withOpacity(0.5),
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
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            activeIcon: Icon(Icons.assignment),
            label: 'Book Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];

      case 2:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            activeIcon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      case 3:
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          activeIcon: Icon(Icons.list_alt),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
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