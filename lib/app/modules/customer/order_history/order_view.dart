import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../routes/app_routes.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import 'orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      body: Stack(
        children: [

          /// Background circles
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              height: 180,
              width: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff62B5F8),
              ),
            ),
          ),

          Positioned(
            top: -80,
            right: -90,
            child: Container(
              height: 250,
              width: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6B67F6),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "My Orders",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1A2C56),
                  ),
                ),

                const SizedBox(height: 10),

                /// Toggle Card
                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                      horizontal: 16),
                  child: Container(
                    padding:
                    const EdgeInsets.all(5),
                    decoration:
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                          30),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Row(
                      children: [

                        _toggleButton(
                            "Active Orders",
                            true),

                        _toggleButton(
                            "History",
                            false),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    margin:
                    const EdgeInsets.only(
                      top: 10,
                    ),
                    padding:
                    const EdgeInsets.only(
                      top: 10,
                    ),
                    decoration:
                    const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(
                        top: Radius.circular(
                            35),
                      ),
                    ),

                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return _buildShimmerLoading();
                      }

                      final orders = controller.isActiveSelected.value
                          ? controller.activeOrders
                          : controller.historyOrders;

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
                                  child: Text("No Orders Found"),
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
                          padding: const EdgeInsets.all(16),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];

                            return _orderCard(order: order);
                          },
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 🔘 Toggle Button (GetX)
  Widget _toggleButton(String text, bool isActive) {
    return Expanded(
      child: Obx(() {
        final selected = controller.isActiveSelected.value == isActive;

        return GestureDetector(
          onTap: () => controller.toggleTab(isActive),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
            children: [
              /// Top Row: Order Number & Status
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              /// Date Text
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 140,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Divider
              Divider(height: 1, color: Colors.grey.shade100),
              const SizedBox(height: 16),

              /// Product Row
              Row(
                children: [
                  /// Product Image Placeholder
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Product Details Placeholder
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 6),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 60,
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

                  /// Price Placeholder
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 50,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildStatusChip(String statusText, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String getCompleteAddress(Order order) {
    final addr = order.customerDetails.address;
    final parts = [
      addr.housenumber,
      addr.flatnumber,
      addr.societyname,
      addr.galinumber,
      addr.landmark,
      addr.city,
      addr.state,
      addr.pincode
    ].map((e) => e.toString().trim()).where((e) => e.isNotEmpty && e != 'null').toList();

    return parts.isEmpty ? "N/A" : parts.join(", ");
  }

  /// 📦 Order Card UI
  Widget _orderCard({required Order order}) {
    final statusColor = controller.getStatusColor(order.paymentstatus);
    final statusText = order.paymentstatus;
    final deliveryName = order.deliveryDetails.deliveryPartnerName.trim().isNotEmpty
        ? order.deliveryDetails.deliveryPartnerName
        : order.deliveryPartnerName;
    final deliveryMobile = order.deliveryDetails.mobileNo;

    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoutes.orderDetails,
          arguments: order,
        );
      },
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
                    "#${order.ordernumber}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1A2C56),
                    ),
                  ),
                ),
                buildStatusChip(statusText, statusColor),
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
                      "₹${order.price}",
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
                      "Qty: ${order.quantity}",
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
                          controller.formatDate(order.deliverydate, order.deliverytime),
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

            if (deliveryName.isNotEmpty && deliveryName != "N/A" && deliveryName != "null") ...[
              const SizedBox(height: 12),
              /// Contact Block (Delivery Partner only since it's the customer side)
              GestureDetector(
                onTap: (deliveryMobile.isNotEmpty && deliveryMobile != "N/A" && deliveryMobile != "null")
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
                          "Delivery Partner: $deliveryName",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: (deliveryMobile.isNotEmpty && deliveryMobile != "N/A" && deliveryMobile != "null")
                                ? Colors.blue.shade700
                                : Colors.black87,
                            decoration: (deliveryMobile.isNotEmpty && deliveryMobile != "N/A" && deliveryMobile != "null")
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      if (deliveryMobile.isNotEmpty && deliveryMobile != "N/A" && deliveryMobile != "null")
                        const Icon(Icons.phone_in_talk_outlined, size: 14, color: Colors.green),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),

            /// Address Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      getCompleteAddress(order),
                      style: TextStyle(
                        height: 1.3,
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// Bottle details
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
                  const Icon(Icons.water_drop_outlined, color: Colors.blue, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "${order.waterbottle_name}${order.bottleWeight.isNotEmpty ? " (${order.bottleWeight})" : ""}",
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