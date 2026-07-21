import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'order_detail_controller.dart';

class DeliveryOrderDetailView extends GetView<DeliveryOrderDetailController> {
  const DeliveryOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.order;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),

      bottomNavigationBar: GetBuilder<DeliveryOrderDetailController>(
        id: 'status',
        builder: (_) {
          final isCompleted = order.status == 3 || order.status == 4 || order.status == 5;
          if (isCompleted) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 55,
                child: Obx(
                  () => ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6B67F6),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.markAsDelivered('4'),
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(
                      controller.isLoading.value
                          ? 'Updating...'
                          : 'Mark as Delivered',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ORDER INFO
            _sectionCard(
              title: 'Order Information',
              children: [
                _row('Order Number', order.ordernumber),
                _row('Quantity', '${order.quantity}'),
                _row('Price', '₹${order.price}'),
              ],
            ),

            const SizedBox(height: 16),

            /// CUSTOMER
            _sectionCard(
              title: 'Customer Details',
              children: [
                _row('Name', order.customerDetails.fullname),
                _rowWithAction(
                  'Mobile',
                  order.customerDetails.mobile,
                  icon: const Icon(Icons.call, color: Color(0xff6E6AF8), size: 18),
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: order.customerDetails.mobile,
                    );
                    if (await canLaunchUrl(launchUri)) {
                      await launchUrl(launchUri);
                    } else {
                      Get.snackbar("Error", "Could not launch call dialer");
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// PRODUCT
            _sectionCard(
              title: 'Bottle Details',
              children: [
                _row('Bottle', displayValue(order.waterbottleName)),
                _row('Weight', displayValue(order.bottleWeight)),
                _row('Description', displayValue(order.bottleDescription)),
              ],
            ),

            const SizedBox(height: 16),

            /// ADDRESS
            _sectionCard(
              title: 'Delivery Address',
              children: [
                _detailRow(
                  "Address",
                  order.customerDetails.address.fulladdress,
                ),

                _detailRow(
                  "Flat No / House No.",
                  displayValue(order.customerDetails.address.houseFlatFloorNo.toString()),
                ),
                _detailRow(
                  "Gali / Society / Block",
                  displayValue(order.customerDetails.address.societyGaliBlockNo.toString()),
                ),
                _detailRow(
                  "Sector",
                  displayValue(order.customerDetails.address.sectornumber.toString()),
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

            const SizedBox(height: 16),

            /// DELIVERY PARTNER
            if (order.deliveryDetails.deliveryPartnerName.trim().isNotEmpty)
              _sectionCard(
                title: 'Delivery Partner',
                children: [
                  _row('Name', order.deliveryDetails.deliveryPartnerName),
                  _row('Mobile', order.deliveryDetails.mobileNo),
                ],
              ),

            // Bottom status delivered container has been removed
          ],
        ),
      ),
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

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
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

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowWithAction(String title, String value, {required Widget icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    color: Color(0xff6E6AF8),
                  ),
                ),
                const SizedBox(width: 6),
                icon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
