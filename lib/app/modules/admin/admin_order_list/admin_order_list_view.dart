import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_routes.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import 'admin_order_list_controller.dart';

class AdminOrderListView extends StatelessWidget {
  AdminOrderListView({super.key});

  final AdminOrderListController controller =
  Get.put(AdminOrderListController());

  final List<String> tabs = const [
    'Pending',
    'Assigned',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          buildHeader(),

          /// Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      controller.orderSearchQuery.value = val;
                      controller.filterOrders();
                    },
                    decoration: InputDecoration(
                      hintText: "Search Order Number...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() {
                  final isFilterActive =
                      controller.selectedSector.value.isNotEmpty;
                  return InkWell(
                    onTap: () {
                      _showSectorFilterBottomSheet(context);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: isFilterActive
                            ? const Color(0xff5E35B1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
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

          /// Tabs
          SizedBox(
            height: 45,
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
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xff5E35B1)
                            : Colors.white,
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
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 12),

          /// Order List
          Expanded(
            child: Obx(() {
              final isLoading = controller.isLoading.value;
              List<Order> orders = controller.orders.toList();
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (orders.isEmpty) {
                return const Center(
                  child: Text(
                    "No Orders Found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: orders.length,
                key: PageStorageKey(controller.activeTab.value),
                physics: const ClampingScrollPhysics(),
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
                addSemanticIndexes: false,
                cacheExtent: 1000,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.adminOrderDetail,
                        arguments: order,
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "#${order.ordernumber}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(order.statusText),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                order.statusText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        /// ORDER DETAILS
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Order Details",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              buildInfoRow(
                                Icons.calendar_month,
                                "Date",
                                formatDate(order.deliverydate),
                              ),

                              buildInfoRow(
                                Icons.access_time,
                                "Time",
                                order.deliverytime,
                              ),

                              buildInfoRow(
                                Icons.inventory_2_outlined,
                                "Quantity",
                                order.quantity.toString(),
                              ),

                              buildInfoRow(
                                Icons.currency_rupee,
                                "Amount",
                                "₹${order.price}",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// CUSTOMER DETAILS
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Customer Details",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              buildInfoRow(
                                Icons.person_outline,
                                "Name",
                                order.customerDetails.fullname,
                              ),

                              buildInfoRow(
                                Icons.phone_outlined,
                                "Mobile",
                                order.customerDetails.mobile,
                              ),

                              buildInfoRow(
                                Icons.email_outlined,
                                "Email",
                                order.customerDetails.email,
                              ),

                              buildInfoRow(
                                Icons.location_on_outlined,
                                "Address",
                                order.customerDetails.address.fulladdress,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// PAYMENT STATUS
                        Row(
                          children: [
                            const Text(
                              "Payment Status",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: order.paymentstatus == 1
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                order.paymentstatus == 1
                                    ? "Paid"
                                    : "Unpaid",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: order.paymentstatus == 1
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // if (order.deliveryDetails.deliveryPartnerId > 0) ...[
                        //   const SizedBox(height: 12),
                        //
                        //   /// DELIVERY PARTNER DETAILS
                        //   Container(
                        //     padding: const EdgeInsets.all(12),
                        //     decoration: BoxDecoration(
                        //       color: Colors.green.shade50,
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Text(
                        //           "Delivery Partner",
                        //           style: TextStyle(
                        //             fontSize: 15,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         const SizedBox(height: 10),
                        //
                        //         buildInfoRow(
                        //           Icons.local_shipping_outlined,
                        //           "Name",
                        //           order.deliveryDetails.deliveryPartnerName,
                        //         ),
                        //
                        //         buildInfoRow(
                        //           Icons.phone_outlined,
                        //           "Mobile",
                        //           order.deliveryDetails.mobileNo,
                        //         ),
                        //
                        //         buildInfoRow(
                        //           Icons.email_outlined,
                        //           "Email",
                        //           order.deliveryDetails.email,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ],
                      ],
                    ),
                    ),
                  );
                },
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
      padding: const EdgeInsets.only(
        top: 50,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff4527A0),
            Color(0xff5E35B1),
          ],
        ),
      ),
      child: const Center(
        child: Text(
          "Order List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade100;

      case 'assigned':
        return Colors.blue.shade100;

      case 'out for delivery':
        return Colors.purple.shade100;

      case 'delivered':
        return Colors.green.shade100;

      default:
        return Colors.grey.shade200;
    }
  }
  Widget buildInfoRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),

          SizedBox(
            width: 75,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Text(": "),

          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
            ),
          ),
        ],
      ),
    );
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

              /// Local Search Sector TextField
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xff5E35B1),
                          ),
                        ),
                      ),
                    );
                  }

                  // Local filter of sector names
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
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.shade100,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final sector = filtered[index];
                      final isSelected =
                          controller.selectedSector.value == sector;

                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(
                          "Sector $sector",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xff5E35B1)
                                : Colors.black87,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xff5E35B1),
                              )
                            : null,
                        onTap: () {
                          controller.selectedSector.value = sector;
                          controller.filterOrders();
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
}