import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/modules/admin/dashboard/admin_dashboard_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class AdminDashboardView extends StatelessWidget {
  AdminDashboardView({super.key});

  final AdminDashboardController controller =
  Get.put(AdminDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff62B5F8),
              ),
            ),
          ),

          Positioned(
            top: -120,
            right: -100,
            child: Container(
              height: 280,
              width: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6B67F6),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Dashboard",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Admin Panel",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                /// CONTENT
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// STATS
                          Obx(
                                () => Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics:
                                const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 1.45,
                                children: [
                                  StatsCard(
                                    title:
                                    "Total Orders",
                                    value: controller
                                        .totalOrders.value
                                        .toString(),
                                    colors: const [
                                      Color(0xff42A5F5),
                                      Color(0xff1976D2),
                                    ],
                                  ),

                                  StatsCard(
                                    title:
                                    "Active Orders",
                                    value: controller
                                        .activeOrders.value
                                        .toString(),
                                    colors: const [
                                      Color(0xff66BB6A),
                                      Color(0xff2E7D32),
                                    ],
                                  ),

                                  StatsCard(
                                    title:
                                    "Completed Orders",
                                    value: controller
                                        .completedOrders
                                        .value
                                        .toString(),
                                    colors: const [
                                      Color(0xffFFB74D),
                                      Color(0xffEF6C00),
                                    ],
                                  ),

                                  StatsCard(
                                    title:
                                    "Total Revenue",
                                    value:
                                    "₹${controller.totalRevenue.value}",
                                    colors: const [
                                      Color(0xffAB47BC),
                                      Color(0xff6A1B9A),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          const Padding(
                            padding:
                            EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Text(
                                  "Recent Orders",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold,
                                    color:
                                    Color(0xff1A2C56),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// RECENT ORDERS
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(16, 10, 16, 16),
                            child: Container(
                              padding:
                              const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                Colors.grey.shade50,
                                borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: Obx(
                                    () {
                                  if (controller
                                      .recentOrders
                                      .isEmpty) {
                                    return const Padding(
                                      padding:
                                      EdgeInsets.all(
                                          20),
                                      child: Center(
                                        child: Text(
                                          "No recent orders found",
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                        .recentOrders
                                        .length,
                                    separatorBuilder:
                                        (_, __) =>
                                    const Divider(),
                                    itemBuilder:
                                        (_, index) {
                                      return InkWell(
                                        onTap: (){
                                          Get.toNamed(
                                            AppRoutes.adminOrderDetail,
                                            arguments: controller
                                                .recentOrders[
                                            index],
                                          );
                                        },
                                        child: OrderTile(
                                          order: controller
                                              .recentOrders[
                                          index],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// STATS CARD
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final List<Color> colors;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius:
        BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:
            colors.first.withValues(alpha: .3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// ORDER TILE
class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({
    super.key,
    required this.order,
  });

  Color getStatusColor() {
    switch (order.status) {
      case 1:
        return Colors.orange;

      case 2:
        return Colors.green;

      case 3:
        return Colors.red;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                order.ordernumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Quantity: ${order.quantity}",
                style: TextStyle(
                  fontSize: 14,
                  color:
                  Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "₹${order.price}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "${order.deliverydate.day}/${order.deliverydate.month}/${order.deliverydate.year}",
                style: TextStyle(
                  fontSize: 12,
                  color:
                  Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color:
            getStatusColor().withValues(
              alpha: .1,
            ),
            borderRadius:
            BorderRadius.circular(20),
          ),
          child: Text(
            order.statusText,
            style: TextStyle(
              color: getStatusColor(),
              fontWeight:
              FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}