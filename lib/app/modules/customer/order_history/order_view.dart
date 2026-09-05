import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../routes/app_routes.dart';
import '../../../global_controller/bottomTabBar/navigation_controller.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import 'orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),

            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                        Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xff1976D2),
                        size: 18,
                      ),
                    ),
                  ),
                  const Text(
                    "My Orders",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff0A1D5E),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            const SizedBox(height: 15),

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
                        child: Builder(
                          builder: (_) {
                            final grouped = controller.groupOrdersByDate(orders);
                            final dateKeys = grouped.keys.toList();

                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: dateKeys.length,
                              itemBuilder: (context, groupIndex) {
                                final dateKey = dateKeys[groupIndex];
                                final groupOrders = grouped[dateKey]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDateHeader(dateKey, groupOrders.length),
                                    ...groupOrders.map((order) => _orderCard(order: order)),
                                    const SizedBox(height: 4),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
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

  Widget _buildOrderStatusChip(Order order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: order.statusBgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: order.statusColor.withOpacity(0.25), width: 0.8),
      ),
      child: Text(
        order.displayStatusText.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: order.statusColor,
        ),
      ),
    );
  }

  Widget _buildPaymentModeChip(Order order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: order.paymentModeBgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: order.paymentModeColor.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(order.paymentModeIcon, size: 11, color: order.paymentModeColor),
          const SizedBox(width: 4),
          Text(
            order.formattedPaymentMode,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: order.paymentModeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusChip(Order order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: order.paymentStatusBgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: order.paymentStatusColor.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(order.paymentStatusIcon, size: 11, color: order.paymentStatusColor),
          const SizedBox(width: 4),
          Text(
            order.formattedPaymentStatus,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: order.paymentStatusColor,
            ),
          ),
        ],
      ),
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
      addr.fulladdress,
      // addr.houseFlatFloorNo,
      // addr.landmark,
      // addr.city,
      // addr.state,
      // addr.pincode
    ].map((e) => e.toString().trim()).where((e) => e.isNotEmpty && e != 'null').toList();

    return parts.isEmpty ? "N/A" : parts.join(", ");
  }

  /// 📅 Date Header for Grouped List
  Widget _buildDateHeader(String date, int count) {
    const accentColor = Color(0xff1976D2);
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded, size: 14, color: accentColor),
          const SizedBox(width: 6),
          Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: accentColor,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$count order${count == 1 ? '' : 's'}",
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Divider(
              color: accentColor.withOpacity(0.2),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
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
            /// Header: Order ID + Status Chip + Payment Mode & Payment Status
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
                _buildOrderStatusChip(order),
                const SizedBox(width: 6),
                _buildPaymentModeChip(order),
                const SizedBox(width: 6),
                _buildPaymentStatusChip(order),
              ],
            ),

            /// Quick Delivery / Scheduled badges
            if (order.quickDelivery == 1 || order.isSchedule == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  if (order.quickDelivery == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0)
                    _badgeChip("⚡ Quick Delivery", Colors.orange),
                  if ((order.quickDelivery == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0) && order.isSchedule == 1)
                    const SizedBox(width: 6),
                  if (order.isSchedule == 1)
                    _badgeChip("🗓 Scheduled", Colors.purple),
                ],
              ),
            ],

            const Divider(height: 16, thickness: 0.5),

            /// Details Row (Price, Qty)
            Row(
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
                const SizedBox(width: 16),
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
              ],
            ),

            const SizedBox(height: 8),

            /// Order Time (cdate in DD-MMM-YYYY hh:mm a)
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Order Time: ",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Text(
                    DateFormat('dd-MMM-yyyy hh:mm a').format(order.cdate),
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            /// Delivery Time / Slot
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined, size: 13, color: Colors.blueGrey),
                const SizedBox(width: 4),
                Text(
                  "Delivery Time: ",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Text(
                    order.deliverytime.isNotEmpty
                        ? "${DateFormat('dd-MMM-yyyy').format(order.deliverydate)} | ${order.deliverytime}"
                        : DateFormat('dd-MMM-yyyy').format(order.deliverydate),
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 💰 Price Breakup
            _priceBreakup(order),

            if (deliveryName.isNotEmpty && deliveryName != "N/A" && deliveryName != "null") ...[
              const SizedBox(height: 10),
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
                      "${order.waterbottleName}${order.bottleWeight.isNotEmpty ? " (${order.bottleWeight})" : ""}",
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

  /// 💰 Price Breakup Widget
  Widget _priceBreakup(Order order) {
    final double rawBottlePrice = double.tryParse(order.bottleDiscountprice.isNotEmpty && order.bottleDiscountprice != '0' ? order.bottleDiscountprice : order.bottleprice) ?? 0;
    final double floorRate      = double.tryParse(order.floorprice) ?? 0;
    final int    floorNo        = order.custFloornumber;
    final bool   isLift         = order.custIsLiftAvailable == 1;
    final int    qty            = order.quantity > 0 ? order.quantity : 1;
    final double quickP         = double.tryParse(order.quickdeliverycharge) ?? 0;
    final double totalP         = double.tryParse(order.price) ?? 0;
    final bool   isQuick        = order.quickDelivery == 1 || quickP > 0;

    final double floorTotal = isLift ? 0 : (floorRate * floorNo * qty);
    final double bottleTotal = rawBottlePrice > 0
        ? (rawBottlePrice * qty)
        : (totalP > 0 ? (totalP - floorTotal - (isQuick ? quickP : 0)).clamp(0, totalP) : 0);
    final double perBottlePrice = qty > 0 ? (bottleTotal / qty) : bottleTotal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCCE0FF), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined, size: 13, color: Color(0xff1976D2)),
              const SizedBox(width: 5),
              const Text(
                "Price Breakup",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// Bottle price row: ₹perBottlePrice × qty = ₹bottleTotal
          if (bottleTotal > 0 || perBottlePrice > 0)
            _breakupRow(
              "Bottle Price (${perBottlePrice > 0 ? "₹${perBottlePrice.toStringAsFixed(0)} × " : ""}$qty)",
              "₹${bottleTotal.toStringAsFixed(0)}",
              Colors.black87,
            ),

          /// Floor charge row
          if (floorTotal > 0) ...[
            const SizedBox(height: 3),
            _breakupRow(
              "Floor Charges (₹${floorRate.toStringAsFixed(0)} × $floorNo floor × $qty)",
              "+ ₹${floorTotal.toStringAsFixed(0)}",
              Colors.orange.shade700,
            ),
          ] else if (isLift && floorNo > 0) ...[
            const SizedBox(height: 3),
            _breakupRow(
              "Floor Charges (Floor $floorNo)",
              "Free (Lift Available)",
              Colors.green.shade700,
            ),
          ],

          /// Quick delivery charge row — show whenever it's a quick delivery order or quickP > 0
          if (isQuick) ...[
            const SizedBox(height: 3),
            _breakupRow(
              "Quick Delivery Charge",
              quickP > 0 ? "+ ₹${quickP.toStringAsFixed(0)}" : "+ ₹0",
              Colors.deepOrange.shade600,
            ),
          ],

          /// Fallback when no sub-prices are available
          if (bottleTotal == 0 && floorTotal == 0 && !isQuick)
            _breakupRow("Base Price", "₹${totalP.toStringAsFixed(0)}", Colors.black87),

          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Divider(height: 1, color: Colors.blue.shade100),
          ),
          const SizedBox(height: 4),

          /// Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1A2C56),
                ),
              ),
              Text(
                "₹${totalP.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1976D2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Single breakup row
  Widget _breakupRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor),
        ),
      ],
    );
  }

  /// Small badge chip for Quick Delivery / Scheduled
  Widget _badgeChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}