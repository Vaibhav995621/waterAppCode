import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/schedule_model/schedule_list_model.dart';
import 'schedule_orders_list_controller.dart';

class ScheduleOrdersListView extends GetView<ScheduleOrdersListController> {
  const ScheduleOrdersListView({super.key});

  static const Color _primaryPurple = Color(0xFF6B67F6);
  static const Color _secondaryBlue = Color(0xFF62B5F8);
  static const Color _bgLight = Color(0xFFF4F7FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.isAdmin ? "Admin - Schedule Orders" : "My Schedule Orders",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryPurple, _secondaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // _buildTopSearchBar(context),
          // _buildFilterTabs(),
          // _buildSummaryCard(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerList();
              }

              if (controller.filteredScheduleList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => controller.fetchScheduleOrders(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: _primaryPurple.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  size: 54,
                                  color: _primaryPurple.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No Schedule Orders Found",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Pull down to refresh or try another search",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
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
                onRefresh: () => controller.fetchScheduleOrders(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: controller.filteredScheduleList.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredScheduleList[index];
                    return _buildScheduleCard(context, item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget _buildTopSearchBar(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
  //     child: TextField(
  //       onChanged: controller.onSearchChanged,
  //       decoration: InputDecoration(
  //         hintText: controller.isAdmin
  //             ? "Search Customer, Mobile, Bottle, Address..."
  //             : "Search Bottle, Date, Address...",
  //         hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
  //         prefixIcon: const Icon(Icons.search_rounded, size: 22, color: _primaryPurple),
  //         suffixIcon: Obx(() {
  //           if (controller.searchQuery.value.isNotEmpty) {
  //             return IconButton(
  //               icon: const Icon(Icons.clear_rounded, size: 18),
  //               onPressed: () {
  //                 controller.onSearchChanged('');
  //               },
  //             );
  //           }
  //           return const SizedBox.shrink();
  //         }),
  //         filled: true,
  //         fillColor: Colors.white,
  //         contentPadding: const EdgeInsets.symmetric(vertical: 12),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           borderSide: BorderSide.none,
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           borderSide: BorderSide(color: Colors.grey.shade200),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           borderSide: const BorderSide(color: _primaryPurple, width: 1.5),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildFilterTabs() {
  //   final tabs = ['All', 'Active', 'Completed', 'Pending'];
  //   return SizedBox(
  //     height: 38,
  //     child: Obx(() {
  //       final current = controller.selectedTab.value;
  //       return ListView.builder(
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         scrollDirection: Axis.horizontal,
  //         itemCount: tabs.length,
  //         itemBuilder: (context, index) {
  //           final tab = tabs[index];
  //           final isSelected = current == tab;
  //           return GestureDetector(
  //             onTap: () => controller.changeTab(tab),
  //             child: Container(
  //               margin: const EdgeInsets.only(right: 8),
  //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //               decoration: BoxDecoration(
  //                 color: isSelected ? _primaryPurple : Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //                 border: Border.all(
  //                   color: isSelected ? _primaryPurple : Colors.grey.shade300,
  //                 ),
  //                 boxShadow: isSelected
  //                     ? [
  //                         BoxShadow(
  //                           color: _primaryPurple.withValues(alpha: 0.3),
  //                           blurRadius: 6,
  //                           offset: const Offset(0, 3),
  //                         )
  //                       ]
  //                     : null,
  //               ),
  //               child: Text(
  //                 tab,
  //                 style: TextStyle(
  //                   color: isSelected ? Colors.white : Colors.grey.shade700,
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 12.5,
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     }),
  //   );
  // }
  //
  // Widget _buildSummaryCard() {
  //   return Obx(() {
  //     final total = controller.scheduleList.length;
  //     final active = controller.scheduleList.where((e) => e.status == 1).length;
  //     final completed = controller.scheduleList.where((e) => e.status == 2).length;
  //
  //     if (total == 0) return const SizedBox.shrink();
  //
  //     return Container(
  //       margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withValues(alpha: 0.04),
  //             blurRadius: 8,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           _buildStatItem("Total", "$total", _primaryPurple, Icons.receipt_long_rounded),
  //           Container(width: 1, height: 28, color: Colors.grey.shade200),
  //           _buildStatItem("Active", "$active", Colors.green, Icons.check_circle_outline_rounded),
  //           Container(width: 1, height: 28, color: Colors.grey.shade200),
  //           _buildStatItem("Completed", "$completed", Colors.blue, Icons.task_alt_rounded),
  //         ],
  //       ),
  //     );
  //   });
  // }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleCard(BuildContext context, ScheduleData item) {
    final bottle = item.waterbottleDetails;
    final customer = item.customer;
    final address = item.address;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Line: Schedule ID & Status Badges
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _primaryPurple.withValues(alpha: 0.06),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade100),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "#SCHEDULE-${item.id}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _primaryPurple,
                    ),
                  ),
                  const Spacer(),
                  _buildBadge(
                    item.subscriptionTypeLabel,
                    Colors.purple.shade700,
                    Colors.purple.shade50,
                  ),
                  const SizedBox(width: 6),
                  _buildBadge(
                    item.statusLabel,
                    item.status == 1
                        ? Colors.green.shade700
                        : (item.status == 2 ? Colors.blue.shade700 : Colors.orange.shade700),
                    item.status == 1
                        ? Colors.green.shade50
                        : (item.status == 2 ? Colors.blue.shade50 : Colors.orange.shade50),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bottle info & Pricing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bottle Image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: bottle?.photo != null && bottle!.photo!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.network(
                                  bottle.photo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.water_drop_rounded,
                                    color: _secondaryBlue,
                                    size: 32,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.water_drop_rounded,
                                color: _secondaryBlue,
                                size: 32,
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bottle?.bottlename ?? "Water Can",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Qty per delivery: ${item.orderquantity} bottle${item.orderquantity > 1 ? 's' : ''}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Total Quantity: ${item.totalquantity} bottles",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Amount
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${item.totalamount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          Text(
                            "₹${item.unitprice.toStringAsFixed(0)} / bottle",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildBadge(
                            "${item.paymentModeLabel} • ${item.paymentStatusLabel}",
                            item.paymentstatus == 1 ? Colors.teal.shade800 : Colors.deepOrange.shade800,
                            item.paymentstatus == 1 ? Colors.teal.shade50 : Colors.deepOrange.shade50,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 0.8),
                  const SizedBox(height: 12),

                  // Dates & Duration
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoTile(
                          Icons.calendar_today_rounded,
                          "Start Date",
                          item.startdate ?? "N/A",
                          _primaryPurple,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoTile(
                          Icons.event_available_rounded,
                          "End Date",
                          item.enddate ?? "N/A",
                          _secondaryBlue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoTile(
                          Icons.timelapse_rounded,
                          "Duration",
                          "${item.subscriptionduration} Days",
                          Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),

                  // Custom selected dates if applicable
                  if (item.substypevalue != null && item.substypevalue!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range_rounded, size: 16, color: Colors.purple.shade700),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Scheduled Delivery Dates:",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.substypevalue!,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.purple.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Customer & Address Info (Crucial for Admin)
                  if (controller.isAdmin || customer != null || address != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer row
                          Row(
                            children: [
                              const Icon(Icons.person_rounded, size: 16, color: _primaryPurple),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  customer?.fullname ?? "Customer #${item.customerid}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                              if (customer?.mobile != null && customer!.mobile!.isNotEmpty) ...[
                                InkWell(
                                  onTap: () => _makePhoneCall(customer.mobile!),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.green.shade200),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.phone_rounded, size: 13, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Text(
                                          customer.mobile!,
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Address row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_rounded, size: 16, color: Colors.redAccent),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  address?.fulladdress != null && address!.fulladdress!.isNotEmpty
                                      ? address.fulladdress!
                                      : (customer?.fulladdress ?? "Address not provided"),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              if (address?.sectornumber != null && address!.sectornumber!.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _primaryPurple.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Sec ${address.sectornumber}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _primaryPurple,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (item.createdAt != null && item.createdAt!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Created: ${item.createdAt}",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Unable to call: $e");
    }
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Line
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  height: 44,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bottle info & Pricing
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(width: double.infinity, height: 16, color: Colors.white),
                                const SizedBox(height: 8),
                                Container(width: 120, height: 12, color: Colors.white),
                                const SizedBox(height: 8),
                                Container(width: 140, height: 12, color: Colors.white),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(width: 60, height: 18, color: Colors.white),
                              const SizedBox(height: 8),
                              Container(width: 80, height: 12, color: Colors.white),
                              const SizedBox(height: 8),
                              Container(width: 50, height: 16, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, thickness: 0.8),
                      const SizedBox(height: 12),
                      // Dates & Duration
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
