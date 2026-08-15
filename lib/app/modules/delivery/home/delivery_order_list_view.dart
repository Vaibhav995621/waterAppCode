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
          const SizedBox(height: 8),

          /// Order Count Badge
          Obx(() {
            final orders = controller.isActiveSelected.value
                ? controller.activeOrders
                : controller.historyOrders;
            final count = orders.length;
            if (count == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xff3949AB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$count order${count == 1 ? '' : 's'}",
                      style: const TextStyle(
                        color: Color(0xff3949AB),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

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
                child: Builder(
                  builder: (_) {
                    final grouped = controller.groupOrdersByDate(orders);
                    final dateKeys = grouped.keys.toList();

                    return ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                      addSemanticIndexes: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      itemCount: dateKeys.length,
                      itemBuilder: (context, groupIndex) {
                        final dateKey = dateKeys[groupIndex];
                        final groupOrders = grouped[dateKey]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDateHeader(dateKey, groupOrders.length, const Color(0xff3949AB)),
                            ...groupOrders.map((order) => _orderCard(context, order)),
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
        ],
      ),
    );
  }

  Widget _buildDateHeader(String date, int count, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded, size: 14, color: accentColor),
          const SizedBox(width: 6),
          Text(
            date,
            style: TextStyle(
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
              style: TextStyle(
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  Widget _buildPaymentModeChip(dynamic modeOrOrder) {
    if (modeOrOrder is Order) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: modeOrOrder.paymentModeBgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: modeOrOrder.paymentModeColor.withValues(alpha: 0.25), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(modeOrOrder.paymentModeIcon, size: 11, color: modeOrOrder.paymentModeColor),
            const SizedBox(width: 4),
            Text(
              modeOrOrder.formattedPaymentMode,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: modeOrOrder.paymentModeColor,
              ),
            ),
          ],
        ),
      );
    }
    final str = modeOrOrder.toString().toLowerCase();
    Color fg = const Color(0xff1565C0);
    Color bg = const Color(0xffE3F2FD);
    String label = modeOrOrder.toString();
    if (str == '0' || str == 'cod' || str == 'cash') {
      label = 'COD';
      fg = const Color(0xffE65100);
      bg = const Color(0xffFFF3E0);
    } else if (str == '1' || str == 'online') {
      label = 'Online';
      fg = const Color(0xff1565C0);
      bg = const Color(0xffE3F2FD);
    } else if (str == '2' || str == 'card' || str == 'subscribed' || str == 'subscribe') {
      label = 'Card';
      fg = const Color(0xff00838F);
      bg = const Color(0xffE0F7FA);
    } else if (str == '3' || str == 'wallet') {
      label = 'Wallet';
      fg = const Color(0xff6A1B9A);
      bg = const Color(0xffF3E5F5);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
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

  Widget _badgeChip(String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.shade200, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color.shade800,
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
            /// Header: Order ID + Payment Mode & Payment Status
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

            /// Bottle Info Row (if bottle name exists)
            if (order.waterbottleName.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.water_drop_outlined, size: 14, color: Color(0xff3949AB)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${safeValue(order.waterbottleName)}${order.bottleWeight.isNotEmpty ? " • ${safeValue(order.bottleWeight)} liter" : ""}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff3A3A5C),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

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

            const SizedBox(height: 8),

            /// Price Breakup
            _priceBreakup(order),

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

            /// Address Box (very clean and compact with Sector badge)
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
                      order.customerDetails.address.fulladdress.isNotEmpty
                          ? order.customerDetails.address.fulladdress
                          : "Address not available",
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  if (order.customerDetails.address.sectornumber.isNotEmpty &&
                      order.customerDetails.address.sectornumber != '0')
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xff3949AB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Sec ${order.customerDetails.address.sectornumber}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff3949AB),
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

          if (bottleTotal > 0 || perBottlePrice > 0)
            _breakupRow(
              "Bottle Price (${perBottlePrice > 0 ? "₹${perBottlePrice.toStringAsFixed(0)} × " : ""}$qty)",
              "₹${bottleTotal.toStringAsFixed(0)}",
              Colors.black87,
            ),

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

          if (isQuick) ...[
            const SizedBox(height: 3),
            _breakupRow(
              "Quick Delivery Charge",
              quickP > 0 ? "+ ₹${quickP.toStringAsFixed(0)}" : "+ ₹0",
              Colors.deepOrange.shade600,
            ),
          ],

          if (bottleTotal == 0 && floorTotal == 0 && !isQuick)
            _breakupRow("Base Price", "₹${totalP.toStringAsFixed(0)}", Colors.black87),

          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Divider(height: 1, color: Colors.blue.shade100),
          ),
          const SizedBox(height: 4),

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

  Widget _breakupRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
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

class _PaymentModeInfo {
  final String label;
  final Color fg;
  final Color bg;

  const _PaymentModeInfo(this.label, this.fg, this.bg);
}