import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'admin_order_detail_controller.dart';

class AdminOrderDetailsView extends GetView<AdminOrderDetailsController> {
  const AdminOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: Obx(() {
        final order = controller.order.value;

        if (order == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    /// ORDER HEADER
                    _buildCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.ordernumber,
                                  style: const TextStyle(
                                    fontSize: 18,
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
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order.statusText,
                                  style: TextStyle(
                                    color: Colors.green.shade800,
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

                    /// ORDER DETAILS
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
                            DateFormat(
                              'dd MMM yyyy',
                            ).format(order.deliverydate),
                          ),

                          _detailRow("Delivery Time", order.deliverytime),

                          _detailRow(
                            "Bottle ID",
                            order.waterbottleid.toString(),
                          ),

                          _detailRow(
                            "Payment Status",
                            order.paymentstatus == 1 ? "Paid" : "Pending",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// CUSTOMER DETAILS
                    _sectionTitle("Customer Information"),

                    _buildCard(
                      child: Column(
                        children: [
                          _detailRow("Name", order.customerDetails.fullname),

                          _detailRow(
                            "Mobile",
                            order.customerDetails.mobile,
                            onCallTap: () => makePhoneCall(order.customerDetails.mobile),
                          ),

                          _detailRow("Email", order.customerDetails.email),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ADDRESS
                    _sectionTitle("Delivery Address"),

                    _buildCard(
                      child: Column(
                        children: [
                          _detailRow(
                            "Address",
                            order.customerDetails.address.fulladdress,
                          ),

                          _detailRow(
                            "Landmark",
                            order.customerDetails.address.landmark,
                          ),

                          _detailRow(
                            "City",
                            order.customerDetails.address.city,
                          ),

                          _detailRow(
                            "State",
                            order.customerDetails.address.state,
                          ),

                          _detailRow(
                            "Pincode",
                            order.customerDetails.address.pincode,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// DELIVERY PARTNER
                    ///
                    if (order.deliveryPartnerId  > 0 )
                      _sectionTitle("Delivery Partner"),
                    if (order.deliveryPartnerId > 0)
                      _buildCard(
                      child: Column(
                        children: [
                           _detailRow(
                            "Name",
                            order.deliveryDetails.deliveryPartnerName,
                          ),

                          _detailRow(
                            "Mobile",
                            order.deliveryDetails.mobileNo,
                            onCallTap: () => makePhoneCall(order.deliveryDetails.mobileNo),
                          ),

                          _detailRow("Email", order.deliveryDetails.email),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (order.assignedto == 0)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: controller.assignDeliveryBoy,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff5B2BCB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Assign Delivery Boy",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8),
        ],
      ),
      child: child,
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            child: Text(title, style: TextStyle(color: Colors.grey.shade600)),
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
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                if (onCallTap != null && value.isNotEmpty && value != "N/A") ...[
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
    if (phoneNumber.isEmpty || phoneNumber == "N/A") return;

    final Uri uri = Uri.parse('tel:$phoneNumber');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Unable to call: $e");
    }
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
}
