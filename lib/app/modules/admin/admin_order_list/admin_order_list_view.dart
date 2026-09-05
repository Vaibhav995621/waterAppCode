import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../routes/app_routes.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import 'admin_order_list_controller.dart';

class AdminOrderListView extends StatelessWidget {
  AdminOrderListView({super.key});

  final AdminOrderListController controller = Get.put(
    AdminOrderListController(),
  );

  final List<String> tabs = const [
    'Pending',
    'Assigned',
    'Delivered',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      body: Column(
        children: [
          buildHeader(),

          /// Search + Filter Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      controller.orderSearchQuery.value = val;
                      controller.filterOrders();
                    },
                    decoration: InputDecoration(
                      hintText: "Search Name, Phone, Address, Sector...",
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() {
                  final isFilterActive = controller.selectedSector.value.isNotEmpty;
                  return InkWell(
                    onTap: () => _showSectorFilterBottomSheet(context),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: isFilterActive ? const Color(0xff5E35B1) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: isFilterActive ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// Tabs
          SizedBox(
            height: 40,
            child: Obx(() {
              final selectedTab = controller.activeTab.value;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  final tab = tabs[index];
                  final isSelected = selectedTab == tab;

                  return GestureDetector(
                    onTap: () => controller.changeTab(tab),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xff5E35B1) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xff5E35B1)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 10),

          /// Order Count Badge
          Obx(() {
            final count = controller.orders.length;
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xff5E35B1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$count order${count == 1 ? '' : 's'}",
                      style: const TextStyle(
                        color: Color(0xff5E35B1),
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
              final List<Order> orders = controller.orders.toList();

              if (isLoading) {
                return _buildShimmerLoading();
              }

              if (orders.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => controller.getOrdersApi(controller.selectedSector.value),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text(
                                "No Orders Found",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Pull down to refresh",
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.getOrdersApi(controller.selectedSector.value),
                child: Builder(
                  builder: (_) {
                    final grouped = controller.groupOrdersByDate(orders);
                    final dateKeys = grouped.keys.toList();

                    return ListView.builder(
                      key: PageStorageKey(controller.activeTab.value),
                      physics: const ClampingScrollPhysics(),
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: true,
                      addSemanticIndexes: false,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      itemCount: dateKeys.length,
                      itemBuilder: (context, groupIndex) {
                        final dateKey = dateKeys[groupIndex];
                        final groupOrders = grouped[dateKey]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDateHeader(dateKey, groupOrders.length, const Color(0xff5E35B1)),
                            ...groupOrders.map((order) => _buildOrderCard(context, order)),
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

  Widget _buildOrderCard(BuildContext context, Order order) {
    final customerName = (order.customerDetails.fullname.trim().isNotEmpty && order.customerDetails.fullname != "null")
        ? order.customerDetails.fullname.trim()
        : ((order.customerName.trim().isNotEmpty && order.customerName != "null")
            ? order.customerName.trim()
            : "N/A");
    final customerMobile = safeValue(order.customerDetails.mobile);

    final deliveryName = (order.deliveryDetails.deliveryPartnerName.trim().isNotEmpty && order.deliveryDetails.deliveryPartnerName != "null")
        ? order.deliveryDetails.deliveryPartnerName.trim()
        : ((order.deliveryPartnerName.trim().isNotEmpty && order.deliveryPartnerName != "null")
            ? order.deliveryPartnerName.trim()
            : "N/A");
    final deliveryMobile = (order.deliveryDetails.mobileNo.trim().isNotEmpty && order.deliveryDetails.mobileNo != "null")
        ? order.deliveryDetails.mobileNo.trim()
        : "N/A";

    return InkWell(
      onTap: () async {
        final result = await Get.toNamed(
          AppRoutes.adminOrderDetail,
          arguments: order,
        );
        if (result == true) {
          controller.getOrdersApi(controller.selectedSector.value);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── Top Header ── Order number + Payment Mode & Payment Status chips
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "#${safeValue(order.ordernumber)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1A2C56),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  _buildOrderStatusChip(order.displayStatusText),
                  const SizedBox(width: 6),
                  _buildPaymentModeChip(order),
                  const SizedBox(width: 6),
                  _buildPaymentStatusChip(order),
                ],
              ),
            ),

            /// Quick Delivery / Scheduled badges
            if (order.quickDelivery == 1 || order.isSchedule == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0) ...[
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 6),
                child: Row(
                  children: [
                    if (order.quickDelivery == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0)
                      _badgeChip("⚡ Quick Delivery", Colors.orange),
                    if ((order.quickDelivery == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0) && order.isSchedule == 1)
                      const SizedBox(width: 6),
                    if (order.isSchedule == 1)
                      _badgeChip("🗓 Scheduled", Colors.purple),
                  ],
                ),
              ),
            ],

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(height: 14, thickness: 0.5),
            ),

            /// ── Bottle Info Row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.water_drop_outlined, size: 14, color: Color(0xff5E35B1)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${safeValue(order.waterbottleName)}  •  ${safeValue(order.bottleWeight)} liter",
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
            ),

            const SizedBox(height: 8),

            /// ── Price / Qty / Date row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price + Payment mode
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      Text(
                        safeValue("Price: "),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xff2E7D32),
                        ),
                      ),
                      Text(
                        "₹${safeValue(order.price)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xff2E7D32),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Qty
                      Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined, size: 14, color: Colors.blueGrey),
                          const SizedBox(width: 4),
                          Text(
                            "Qty: ${safeValue(order.quantity)}",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// ── Price Breakup ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _priceBreakup(order),
            ),

            const SizedBox(height: 10),

            /// ── Contacts Block ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Customer
                  Expanded(
                    child: GestureDetector(
                      onTap: (customerMobile != "N/A" && customerMobile.isNotEmpty)
                          ? () => makePhoneCall(customerMobile)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffF4F0FF),
                          borderRadius: BorderRadius.circular(10),
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
                                  fontSize: 13,
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
                              const Icon(Icons.phone_in_talk_outlined, size: 13, color: Colors.green),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: deliveryName != "N/A"
                                      ? ((deliveryMobile != "N/A" && deliveryMobile.isNotEmpty)
                                          ? Colors.blue.shade700
                                          : Colors.black87)
                                      : Colors.grey.shade400,
                                  decoration: (deliveryMobile != "N/A" && deliveryMobile.isNotEmpty)
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                            if (deliveryMobile != "N/A" && deliveryMobile.isNotEmpty)
                              const Icon(Icons.phone_in_talk_outlined, size: 13, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// ── Address ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xffF4F7FC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.redAccent, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.customerDetails.address.fulladdress.isNotEmpty
                            ? order.customerDetails.address.fulladdress
                            : "Address not available",
                        style: TextStyle(
                          height: 1.3,
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (order.customerDetails.address.sectornumber.isNotEmpty &&
                        order.customerDetails.address.sectornumber != '0')
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xff5E35B1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Sec ${order.customerDetails.address.sectornumber}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff5E35B1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
              color: accentColor.withValues(alpha: 0.1),
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
              color: accentColor.withValues(alpha: 0.2),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff4527A0), Color(0xff7B1FA2)],
        ),
      ),
      child: Obx(() {
        final data = controller.orderResponse.value?.data;
        final totalAll = data?.allOrders.length ?? 0;
        final totalPending = data?.pendingOrders.length ?? 0;
        final totalAssigned = data?.assignedOrders.length ?? 0;
        final totalDelivered = data?.deliveredOrders.length ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                SizedBox(height: 30,),
                Text(
                  "Order List",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderStat(String label, int count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$count",
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MMM-yyyy hh:mm a').format(date);
  }

  /// Payment mode chip: Online, COD, Card, Wallet, UPI, etc.
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

  /// Payment status chip: Paid, Pending, Failed, etc.
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

          /// Bottle price row
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

          /// Quick delivery charge row
          if (isQuick) ...[
            const SizedBox(height: 3),
            _breakupRow(
              "Quick Delivery Charge",
              quickP > 0 ? "+ ₹${quickP.toStringAsFixed(0)}" : "+ ₹0",
              Colors.deepOrange.shade600,
            ),
          ],

          /// Fallback
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
    return Row(
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
    );
  }

  /// Order status_text chip
  Widget _buildOrderStatusChip(String statusText) {
    Color bgColor;
    Color textColor;

    switch (statusText.toLowerCase()) {
      case 'pending':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        break;
      case 'assigned & pickup':
      case 'assigned':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'out for delivery':
        bgColor = Colors.purple.shade50;
        textColor = Colors.purple.shade700;
        break;
      case 'delivered':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'cancelled':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText.isEmpty ? 'N/A' : statusText,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
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

  void _showSectorFilterBottomSheet(BuildContext context) {
    if (controller.sectors.isEmpty) {
      controller.getSectorsApi();
    }

    final localSearchQuery = ''.obs;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Sector",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Obx(() {
                    if (controller.selectedSector.value.isNotEmpty) {
                      return TextButton(
                        onPressed: () {
                          controller.selectedSector.value = '';
                          controller.filterOrders();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Clear Filter",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
              const SizedBox(height: 15),

              /// Search
              TextField(
                onChanged: (val) => localSearchQuery.value = val,
                decoration: InputDecoration(
                  hintText: "Search Sector...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              /// Sectors List
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Obx(() {
                  if (controller.isSectorsLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff5E35B1)),
                        ),
                      ),
                    );
                  }

                  final query = localSearchQuery.value.trim().toLowerCase();
                  final filtered = controller.sectors
                      .where((s) => s.toLowerCase().contains(query))
                      .toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "No sectors found",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade100, height: 1),
                    itemBuilder: (context, index) {
                      final sector = filtered[index];
                      final isSelected = controller.selectedSector.value == sector;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(
                          "Sector $sector",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xff5E35B1) : Colors.black87,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Color(0xff5E35B1))
                            : null,
                        onTap: () {
                          controller.selectedSector.value = sector;
                          controller.getOrdersApi(sector);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Order ID & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerBox(90, 16),
                  _shimmerBox(80, 22, radius: 20),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 12, thickness: 0.5),

              /// Bottle info
              _shimmerBox(140, 13),
              const SizedBox(height: 10),

              /// Price / Qty / Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerBox(60, 14),
                  _shimmerBox(50, 14),
                  _shimmerBox(80, 14),
                ],
              ),
              const SizedBox(height: 12),

              /// Contacts
              Row(
                children: [
                  Expanded(child: _shimmerBox(double.infinity, 38, radius: 10)),
                  const SizedBox(width: 8),
                  Expanded(child: _shimmerBox(double.infinity, 38, radius: 10)),
                ],
              ),
              const SizedBox(height: 10),

              /// Address
              _shimmerBox(double.infinity, 30, radius: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(double width, double height, {double radius = 4}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class _PaymentModeInfo {
  final String label;
  final Color fg;
  final Color bg;
  const _PaymentModeInfo(this.label, this.fg, this.bg);
}
