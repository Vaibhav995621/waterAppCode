import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../routes/app_routes.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import 'admin_order_list_controller.dart';

class AdminOrderListView extends StatelessWidget {
  AdminOrderListView({super.key});

  final AdminOrderListController controller = Get.put(
    AdminOrderListController(),
  );

  final List<String> tabs = const ['Pending', 'Assigned', 'Delivered'];

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
                      hintText: "Search Name, Phone, Address, Sector...",
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
                          color: isSelected ? Colors.white : Colors.black87,
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
                return const Center(child: CircularProgressIndicator());
              }

              if (orders.isEmpty) {
                return const Center(
                  child: Text(
                    "No Orders Found",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                  return Obx(() {
                    final isSelected = controller.isSelected(order);
                    final isPending = controller.activeTab.value == 'Pending';
                    return InkWell(
                      onTap: () {
                        if (isPending && controller.isSelectionMode.value) {
                          controller.toggleSelection(order);
                        } else {
                          Get.toNamed(AppRoutes.adminOrderDetail, arguments: order);
                        }
                      },
                      onLongPress: () {
                        if (isPending) {
                          controller.toggleSelection(order);
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Header
                                Row(
                                  children: [
                                    if (isPending) ...[
                                      GestureDetector(
                                        onTap: () => controller.toggleSelection(order),
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 12),
                                          child: Icon(
                                            isSelected
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: isSelected
                                                ? Colors.blue
                                                : Colors.grey.shade400,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                    Expanded(
                                      child: Text(
                                        "#${safeValue(order.ordernumber)}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    buildStatusChip(order.statusText),
                                  ],
                                ),

                              const SizedBox(height: 6),

                              /// Order Details
                              buildSectionTitle("Order Details"),

                              Row(
                                children: [
                                  Expanded(
                                    child: buildInfoTile(
                                      Icons.currency_rupee,
                                      "Price",
                                      "₹${safeValue(order.price)}",
                                    ),
                                  ),
                                  Expanded(
                                    child: buildInfoTile(
                                      Icons.inventory_2_outlined,
                                      "Qty",
                                      safeValue(order.quantity),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: buildInfoTile(
                                      Icons.calendar_today,
                                      "Date",
                                      formatDate(order.deliverydate),
                                    ),
                                  ),
                                  Expanded(
                                    child: buildInfoTile(
                                      Icons.access_time,
                                      "Time",
                                      safeValue(order.deliverytime),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              /// Customer
                              buildSectionTitle("Customer"),

                              buildContactCard(
                                name: safeValue(order.customerDetails.fullname),
                                mobile: safeValue(order.customerDetails.mobile),
                                imageUrl: safeValue(order.customerDetails.photo),
                              ),


                              const SizedBox(height: 16),

                              /// Delivery Partner
                              buildSectionTitle("Delivery Partner"),

                              buildContactCard(
                                name: safeValue(
                                  order.deliveryDetails.deliveryPartnerName,
                                ),
                                mobile: safeValue(order.deliveryDetails.mobileNo),
                                imageUrl: safeValue(order.deliveryDetails.photo),
                              ),

                              const SizedBox(height: 12),

                              /// Address
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        getCompleteAddress(
                                          order.customerDetails.address,
                                        ),
                                        style: const TextStyle(
                                          height: 1.5,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32,)
                      ],
                    ),
                  );
                  });
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if (controller.isSelectionMode.value && controller.selectedOrders.isNotEmpty) {
          return FloatingActionButton.extended(
            onPressed: () {
              Get.toNamed(
                AppRoutes.adminAssignDelivery,
                arguments: controller.selectedOrders.toList(),
              );
            },
            backgroundColor: const Color(0xff5E35B1),
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text(
              "Assign Delivery Boy",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget buildHeader() {
    return Obx(() {
      final isSelection = controller.isSelectionMode.value;
      final selectedCount = controller.selectedOrders.length;

      return Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff4527A0), Color(0xff5E35B1)],
          ),
        ),
        child: Row(
          children: [
            if (isSelection) ...[
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => controller.clearSelection(),
              ),
              const SizedBox(width: 8),
              Text(
                "$selectedCount Selected",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  if (selectedCount == controller.orders.length) {
                    controller.clearSelection();
                  } else {
                    controller.selectAll();
                  }
                },
                child: Text(
                  selectedCount == controller.orders.length ? "Deselect All" : "Select All",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
              const Text(
                "Order List",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
            ],
          ],
        ),
      );
    });
  }
  

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Widget buildContactCard({
    required String name,
    required String mobile,
    required String imageUrl,
  }) {

    final displayName =
    (name.trim().isNotEmpty) ? name: "N/A";

    final displayMobile =
    (mobile.trim().isNotEmpty) ? mobile: "N/A";
    return (displayName != 'N/A'|| displayMobile != 'N/A') ? Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.network(
              imageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return CircleAvatar(
                  radius: 22,
                  child: const Icon(Icons.person),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(mobile),
              ],
            ),
          ),

          InkWell(
            onTap: () => makePhoneCall(mobile),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.call, color: Colors.green),
            ),
          ),
        ],
      ),
    ): SizedBox.shrink();
  }

  Widget buildInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height:90,
        child: Column(
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
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

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
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
                      final isSelected =
                          controller.selectedSector.value == sector;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
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
}
