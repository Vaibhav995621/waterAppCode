import 'package:get/get.dart';
import 'package:zourney/app/modules/admin/admin_order_details/admin_order_detail_binding.dart';
import 'package:zourney/app/modules/admin/admin_order_details/admin_order_detail_view.dart';
import 'package:zourney/app/modules/admin/dashboard/admin_dashboard_binding.dart';
import 'package:zourney/app/modules/admin/dashboard/admin_dashboard_view.dart';
import 'package:zourney/app/modules/customer/notifications/notifications_binding.dart';
import 'package:zourney/app/modules/customer/notifications/notifications_view.dart';
import 'package:zourney/app/modules/change_password/change_password_binding.dart';
import 'package:zourney/app/modules/change_password/change_password_view.dart';
import 'package:zourney/app/modules/customer/edit_profile/edit_address_binding.dart';
import 'package:zourney/app/modules/customer/edit_profile/edit_address_view.dart';
import 'package:zourney/app/modules/customer/home/customer_home_binding.dart';
import 'package:zourney/app/modules/customer/home/customer_home_view.dart';
import 'package:zourney/app/modules/customer/order_details/order_details_view.dart';
import 'package:zourney/app/modules/customer/order_history/order_view.dart';
import 'package:zourney/app/modules/customer/order_history/orders_binding.dart';
import 'package:zourney/app/modules/customer/payment/payment_binding.dart';
import 'package:zourney/app/modules/customer/payment/payment_screen.dart';
import 'package:zourney/app/modules/customer/payment_histroy/payment_history_binding.dart';
import 'package:zourney/app/modules/customer/payment_histroy/payment_history_screen.dart';
import 'package:zourney/app/modules/customer/payment_successs_screen/payment_success_view.dart';
import 'package:zourney/app/modules/customer/select_address/select_address_binding.dart';
import 'package:zourney/app/modules/customer/subscription_history_list/subscription_history_view.dart';
import 'package:zourney/app/modules/customer/subscription_plan/bottle_subscription_binding.dart';
import 'package:zourney/app/modules/delivery/delivery_order_detail/order_detail_binding.dart';
import 'package:zourney/app/modules/delivery/home/delivery_order_list_binding.dart';
import 'package:zourney/app/modules/delivery/home/delivery_order_list_view.dart';
import 'package:zourney/app/modules/forgot_password/forgot_password_binding.dart';
import 'package:zourney/app/modules/forgot_password/forgot_password_view.dart';
import 'package:zourney/app/modules/login_view/login_binding.dart';
import 'package:zourney/app/modules/login_view/login_view.dart';
import 'package:zourney/app/welcom_screen/welcome_binding.dart';
import 'package:zourney/app/welcom_screen/welcome_view.dart';
import '../app/global_controller/bottomTabBar/main_navigation_screen.dart';
import '../app/modules/admin/admin_order_list/admin_order_list_view.dart';
import '../app/modules/admin/assign_delivery_boy/assign_delivery_boy_view.dart';
import '../app/modules/customer/addresss_list/address_binding.dart';
import '../app/modules/customer/addresss_list/address_view.dart';
import '../app/modules/customer/booking_order/book_water_binding.dart';
import '../app/modules/customer/booking_order/book_water_screen.dart';
import '../app/modules/customer/order_details/order_detail_binding.dart';
import '../app/modules/customer/payment_successs_screen/payment_success_binding.dart';
import '../app/modules/customer/select_address/select_address_screen.dart';
import '../app/modules/customer/subscription_history_list/subscription_history_binding.dart';
import '../app/modules/customer/subscription_plan/bottle_subscription_screen.dart';
import '../app/modules/delivery/delivery_order_detail/order_detail_view.dart';
import '../app/modules/register_screen/register_binding.dart';
import '../app/modules/register_screen/register_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.customerHomeScreen,
      page: () => CustomerHomeScreen(),
      binding: CustomerHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.bookingWaterScreen,
      page: () => BookWaterScreen(),
      binding: BookWaterBinding(),
    ),
    GetPage(
      name: AppRoutes.paymentScreen,
      page: () => PaymentScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: AppRoutes.orderScreen,
      page: () => OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: AppRoutes.editAddressScreen,
      page: () => EditAddressView(),
      binding: EditAddressBinding(),
    ),
    GetPage(
      name: AppRoutes.addressList,
      page: () => AddressListScreen(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: AppRoutes.orderDetails,
      page: () => OrderDetailsScreen(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.subscription,
      page: () => BottleSubscriptionScreen(),
      binding: BottleSubscriptionBinding(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.adminOrderList,
      page: () => AdminOrderListView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.adminOrderDetail,
      page: () => AdminOrderDetailsView(),
      binding: AdminOrderDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.adminAssignDelivery,
      page: () => AssignDeliveryBoyView(),
      binding: AdminOrderDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.selectAddress,
      page: () => SelectAddressScreen(),
      binding: SelectAddressBinding(),
    ),
    GetPage(
      name: AppRoutes.selectAddress,
      page: () => SelectAddressScreen(),
      binding: SelectAddressBinding(),
    ),
    GetPage(
      name: AppRoutes.paymentSuccess,
      page: () => const PaymentSuccessView(),
      binding: PaymentSuccessBinding(),
    ),
    GetPage(
      name: AppRoutes.paymentHistory,
      page: () =>  PaymentHistoryScreen(),
      binding: PaymentHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.mainNavigation,
      page: () => const MainNavigationScreen(),
    ),

    GetPage(
      name: AppRoutes.subscriptionHistoryList,
      page: () =>  SubscriptionHistoryView(),
      binding: SubscriptionHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.deliveryOrderList,
      page: () => const DeliveryOrderListView(),
      binding: DeliveryOrdersListBinding(),
    ),
    GetPage(
      name: AppRoutes.deliveryOrderDetail,
      page: () => const DeliveryOrderDetailView(),
      binding: DeliveryOrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.welcomeScreen,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
  ];
}
