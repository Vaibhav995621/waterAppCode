import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../routes/app_routes.dart';
import 'delivery_order_list_controller.dart';
import 'package:zourney/app/models/Admin/admin_order_list/admin_order_model.dart';

class DeliveryOrderListView extends GetView<DeliveryOrderListController> {
  const DeliveryOrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          buildHeader(),
          const SizedBox(height: 12),

          /// Tabs
          SizedBox(
            height: 45,
            child: Obx(() {
              final isSelectedActive = controller.isActiveSelected.value;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _tabItem(
                    title: "Active Orders",
                    isSelected: isSelectedActive,
                    onTap: () => controller.toggleTab(true),
                  ),
                  _tabItem(
                    title: "History",
                    isSelected: !isSelectedActive,
                    onTap: () => controller.toggleTab(false),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),

          /// Order List
          Expanded(
            child: Obx(() {
              final isLoading = controller.isLoading.value;
              final orders = controller.isActiveSelected.value
                  ? controller.activeOrders
                  : controller.historyOrders;

              if (isLoading) {
                return _buildShimmerLoading();
              }

              if (orders.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => controller.isActiveSelected.value
                      ? controller.getCustomerActiveOrder()
                      : controller.getCustomerHistoryOrder(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: const Center(
                          child: Text(
                            "No Orders Found",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.isActiveSelected.value
                    ? controller.getCustomerActiveOrder()
                    : controller.getCustomerHistoryOrder(),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  addSemanticIndexes: false,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _orderCard(context, order);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff3949AB), Color(0xff5C6BC0)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 44),
          const Text(
            "My Deliveries",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Notification Icon Button
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.notifications);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff3949AB) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xff3949AB) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildStatusChip(String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.isEmpty ? 'N/A' : status,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _orderCard(BuildContext context, Order order) {
    final customerName = safeValue(order.customerDetails.fullname);
    final customerMobile = safeValue(order.customerDetails.mobile);

    return InkWell(
      onTap: () async {
        final result = await Get.toNamed(
          AppRoutes.deliveryOrderDetail,
          arguments: order,
        );

        if (result == true) {
          if (controller.isActiveSelected.value) {
            controller.getCustomerActiveOrder(); // reload API
          } else {
            controller.getCustomerHistoryOrder(); // reload API
          }
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
              color: Colors.black.withOpacity(.03),
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
                buildStatusChip(
                  order.paymentstatus,
                  controller.getStatusColor(order.paymentstatus),
                ),
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
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${formatDate(order.deliverydate)} | ${safeValue(order.deliverytime)}",
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Contacts Block (Customer Details)
            GestureDetector(
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
                    const Icon(Icons.person_outline, size: 14, color: Color(0xff3949AB)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        customerName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: (customerMobile != "N/A" && customerMobile.isNotEmpty)
                              ? const Color(0xff3949AB)
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
                      getCompleteAddress(order.customerDetails.address),
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

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row: Order ID + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16, thickness: 0.5),

              /// Details Row (Price, Qty, Date & Time)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Qty
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
                  // Date & Time
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Contacts Block (Customer Details)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              /// Address Box
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
                    const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
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
      },
    );
  }

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
}