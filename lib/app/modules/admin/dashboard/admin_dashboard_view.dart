import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
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

                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.notifications),
                        child: Container(
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
                                () =>
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: controller.isLoading.value
                                      ? _buildStatsShimmer()
                                      : GridView.count(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 14,
                                    crossAxisSpacing: 14,
                                    childAspectRatio: 1.45,
                                    children: [
                                      StatsCard(
                                        title: "Total Orders",
                                        value: controller.totalOrders.value
                                            .toString(),
                                        colors: const [
                                          Color(0xff42A5F5),
                                          Color(0xff1976D2),
                                        ],
                                      ),
                                      StatsCard(
                                        title: "Active Orders",
                                        value: controller.activeOrders.value
                                            .toString(),
                                        colors: const [
                                          Color(0xff66BB6A),
                                          Color(0xff2E7D32),
                                        ],
                                      ),
                                      StatsCard(
                                        title: "Completed Orders",
                                        value: controller.completedOrders.value
                                            .toString(),
                                        colors: const [
                                          Color(0xffFFB74D),
                                          Color(0xffEF6C00),
                                        ],
                                      ),
                                      StatsCard(
                                        title: "Total Revenue",
                                        value: "₹${controller.totalRevenue
                                            .value}",
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Obx(
                              () {
                                if (controller.isLoading.value) {
                                  return _buildRecentOrdersShimmer();
                                }

                                if (controller.recentOrders.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: Text(
                                        "No recent orders found",
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.recentOrders.length,
                                  itemBuilder: (_, index) {
                                    return OrderTile(
                                      order: controller.recentOrders[index],
                                    );
                                  },
                                );
                              },
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

  Widget _buildStatsShimmer() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.45,
      children: List.generate(4, (index) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 90,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 50,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRecentOrdersShimmer() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 80,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 50,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 80,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String safeValue(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return "N/A";
    }
    return value.toString();
  }

  String getCompleteAddress(dynamic address) {
    final parts = <String>[];

    if (address.housenumber?.toString().isNotEmpty ?? false) {
      parts.add("House No. ${address.housenumber}");
    }

    if (address.flatnumber?.toString().isNotEmpty ?? false) {
      parts.add("Flat ${address.flatnumber}");
    }

    if (address.floornumber != null && address.floornumber != 0) {
      parts.add("Floor ${address.floornumber}");
    }

    if (address.societyname?.toString().isNotEmpty ?? false) {
      parts.add(address.societyname);
    }

    if (address.galinumber?.toString().isNotEmpty ?? false) {
      parts.add("Gali ${address.galinumber}");
    }

    if (address.landmark?.toString().isNotEmpty ?? false) {
      parts.add("Near ${address.landmark}");
    }

    if (address.city?.toString().isNotEmpty ?? false) {
      parts.add(address.city);
    }

    if (address.state?.toString().isNotEmpty ?? false) {
      parts.add(address.state);
    }

    if (address.pincode?.toString().isNotEmpty ?? false) {
      parts.add(address.pincode);
    }

    return parts.where((e) => e.trim().isNotEmpty).join(", ");
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty || phoneNumber == "N/A") return;

    final Uri uri = Uri.parse('tel:$phoneNumber');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Unable to call: $e");
    }
  }

  Widget buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'Failed':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;

      case 'assigned':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;

      case 'out for delivery':
        bgColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        break;

      case 'delivered':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;

      case 'cancelled':
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case 'Failed':
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      default:
        bgColor = Colors.green.shade200;
        textColor = Colors.green.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.isEmpty ? 'N/A' : status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerName = safeValue(order.customerDetails.fullname);
    final customerMobile = safeValue(order.customerDetails.mobile);
    final deliveryName = safeValue(order.deliveryDetails.deliveryPartnerName);
    final deliveryMobile = safeValue(order.deliveryDetails.mobileNo);

    return InkWell(
      onTap: () async {
        final result = await Get.toNamed(AppRoutes.adminOrderDetail, arguments: order);
        if (result == true) {
          Get.find<AdminDashboardController>().adminDashboardApi();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Order ID + Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    "#${safeValue(order.ordernumber)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1A2C56),
                    ),
                  ),
                ),
                buildStatusChip(order.paymentstatus),
              ],
            ),

            const Divider(height: 16, thickness: 0.5),

            /// Details Row (Price, Qty, Date & Time)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Row(
                  children: [
                    const Icon(Icons.currency_rupee, size: 14, color: Colors.green),
                    const SizedBox(width: 2),
                    Text(
                      "₹${safeValue(order.price)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                // Qty
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 14, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      "Qty: ${safeValue(order.quantity)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                // Date & Time
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "${formatDate(order.deliverydate)} | ${safeValue(order.deliverytime)}",
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Contacts Block (Customer & Delivery Partner side-by-side)
            Row(
              children: [
                // Customer
                Expanded(
                  child: GestureDetector(
                    onTap: (customerMobile != "N/A" && customerMobile.isNotEmpty)
                        ? () => makePhoneCall(customerMobile)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14, color: Color(0xff5E35B1)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              customerName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: (customerMobile != "N/A" && customerMobile.isNotEmpty)
                                    ? const Color(0xff5E35B1)
                                    : Colors.black87,
                                decoration: (customerMobile != "N/A" && customerMobile.isNotEmpty)
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          if (customerMobile != "N/A" && customerMobile.isNotEmpty)
                            const Icon(Icons.phone_in_talk_outlined, size: 14, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Delivery Partner
                Expanded(
                  child: GestureDetector(
                    onTap: (deliveryMobile != "N/A" && deliveryMobile.isNotEmpty)
                        ? () => makePhoneCall(deliveryMobile)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_shipping_outlined, size: 14, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              deliveryName != "N/A" ? deliveryName : "Unassigned",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: deliveryName != "N/A"
                                    ? ((deliveryMobile != "N/A" && deliveryMobile.isNotEmpty)
                                        ? Colors.blue.shade700
                                        : Colors.black87)
                                    : Colors.grey,
                                decoration: (deliveryMobile != "N/A" && deliveryMobile.isNotEmpty)
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          if (deliveryMobile != "N/A" && deliveryMobile.isNotEmpty)
                            const Icon(Icons.phone_in_talk_outlined, size: 14, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Address Box (very clean and compact)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffF4F7FC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.red, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.customerDetails.address.fulladdress,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}