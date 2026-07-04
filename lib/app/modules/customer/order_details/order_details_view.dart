import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import 'order_detail_controller.dart';

class OrderDetailsScreen extends GetView<OrderDetailsController> {
  OrderDetailsScreen({super.key});

  @override
  final OrderDetailsController controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    final order = controller.orderData;

    if (order == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Order data is not available.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final statusColor = controller.orderData != null
        ? getStatusColor(controller.orderData!.status)
        : Colors.grey;

    final partnerName = order.deliveryDetails.deliveryPartnerName.trim().isNotEmpty
        ? order.deliveryDetails.deliveryPartnerName
        : order.deliveryPartnerName;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Column(
        children: [
          buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// ORDER HEADER CARD
                  _buildCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "#${order.ordernumber}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1A2C56),
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                getStatusText(order.status),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: _infoTile("Amount", "₹${order.price}"),
                            ),
                            Expanded(
                              child: _infoTile(
                                "Quantity",
                                order.quantity.toString(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ORDER INFORMATION
                  _sectionTitle("Order Information"),
                  _buildCard(
                    child: Column(
                      children: [
                        _detailRow(
                          "Order Date",
                          DateFormat('dd MMM yyyy').format(order.cdate),
                        ),

                        _detailRow(
                          "Delivery Date",
                          DateFormat('dd MMM yyyy').format(order.deliverydate),
                        ),

                        _detailRow("Delivery Time", order.deliverytime),

                        _detailRow(
                          "Bottle ID",
                          order.waterbottleid.toString(),
                        ),

                        _detailRow(
                          "Water Bottle Name",
                          displayValue(order.waterbottle_name),
                        ),

                        _detailRow(
                          "Bottle Weight",
                          displayValue(order.bottleWeight),
                        ),

                        _detailRow(
                          "Bottle Description",
                          displayValue(order.bottleDescription),
                        ),

                        _detailRow(
                          "Payment Status",
                          order.paymentstatus,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// DELIVERY PARTNER INFORMATION (Only if assigned)
                  if (partnerName.isNotEmpty &&
                      partnerName != "N/A" &&
                      partnerName != "null") ...[
                    _sectionTitle("Delivery Partner Information"),
                    _buildCard(
                      child: Column(
                        children: [
                          _detailRow(
                            "Name",
                            partnerName,
                          ),
                          if (order.deliveryDetails.mobileNo.isNotEmpty &&
                              order.deliveryDetails.mobileNo != "N/A" &&
                              order.deliveryDetails.mobileNo != "null")
                            _detailRow(
                              "Mobile",
                              order.deliveryDetails.mobileNo,
                              onCallTap: () => makePhoneCall(order.deliveryDetails.mobileNo),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  /// DELIVERY ADDRESS
                  _sectionTitle("Delivery Address"),
                  _buildCard(
                    child: Column(
                      children: [
                        _detailRow(
                          "House No.",
                          displayValue(order.customerDetails.address.housenumber),
                        ),
                        _detailRow(
                          "Flat No.",
                          displayValue(order.customerDetails.address.flatnumber),
                        ),
                        _detailRow(
                          "Society Name",
                          displayValue(order.customerDetails.address.societyname),
                        ),
                        _detailRow(
                          "Gali / Lane",
                          displayValue(order.customerDetails.address.galinumber),
                        ),
                        _detailRow(
                          "Landmark",
                          displayValue(order.customerDetails.address.landmark),
                        ),
                        _detailRow(
                          "City",
                          displayValue(order.customerDetails.address.city),
                        ),
                        _detailRow(
                          "State",
                          displayValue(order.customerDetails.address.state),
                        ),
                        _detailRow(
                          "Pincode",
                          displayValue(order.customerDetails.address.pincode),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ORDER SUMMARY
                  _sectionTitle("Order Summary"),
                  _buildCard(
                    child: Column(
                      children: [
                        _detailRow("Price (Per Bottle)", "₹${order.price}"),
                        _detailRow("Total Quantity", "${order.quantity}"),
                        const Divider(height: 24, thickness: 0.5),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1A2C56),
                                ),
                              ),
                              Text(
                                "₹${controller.totalAmount}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1976D2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: 110,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4527A0), Color(0xff5E35B1)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              const Center(
                child: Text(
                  "Order Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff1A2C56),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }

  String displayValue(String? value) {
    if (value == null) return "N/A";
    final clean = value.trim().toLowerCase();
    if (clean.isEmpty || clean == "null" || clean == "n/a" || clean == "na") {
      return "N/A";
    }
    return value;
  }

  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xff1A2C56),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String title, String value, {VoidCallback? onCallTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (onCallTap != null && value.isNotEmpty && value != "N/A" && value != "null") ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: onCallTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.call,
                        color: Colors.green,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty || phoneNumber == "N/A" || phoneNumber == "null") return;
    final Uri uri = Uri.parse('tel:$phoneNumber');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Unable to call: $e");
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Assigned';
      case 2:
        return 'Delivered';
      case 3:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
