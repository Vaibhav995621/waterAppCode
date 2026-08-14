import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/full_screen_image_viewer.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
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
                if (order.quickDelivery == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0)
                  _row('Delivery Type', '⚡ Quick Delivery'),
                if ((double.tryParse(order.quickdeliverycharge) ?? 0) > 0 || order.quickDelivery == 1)
                  _row('Quick Delivery Charge', '₹${(double.tryParse(order.quickdeliverycharge) ?? 0).toStringAsFixed(0)}'),
                if (order.isSchedule == 1)
                  _row('Delivery Schedule', '🗓 Scheduled'),
              ],
            ),

            const SizedBox(height: 16),

            /// PRICE BREAKUP
            _priceBreakup(order),

            const SizedBox(height: 16),

            /// CUSTOMER
            if (order.customerDetails.id > 0) ...[
              _sectionCard(
                title: 'Customer Details',
                children: [
                  // Photo
                  if (order.customerDetails.photo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => FullScreenImageViewer.open(
                            context,
                            imageUrl: order.customerDetails.photo,
                            title: "${order.customerDetails.fullname}'s Photo",
                            isCircle: true,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor: const Color(0xffEDE7F6),
                                backgroundImage: NetworkImage(
                                  order.customerDetails.photo,
                                ),
                                onBackgroundImageError: (_, _) {},
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xff6B67F6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.zoom_in_rounded, size: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                  _row('Email', order.customerDetails.email),
                  _row('Plan Bottles',
                      order.customerDetails.planbottlequantity.toString()),
                ],
              ),

              const SizedBox(height: 16),

              /// ADDRESS
              _sectionCard(
                title: 'Delivery Address',
                children: [
                  _detailRow(
                    "Address",
                    displayValue(order.customerDetails.address.fulladdress),
                  ),

                  _detailRow(
                    "Flat No / House No.",
                    displayValue(
                        order.customerDetails.address.houseFlatFloorNo.toString()),
                  ),
                  _detailRow(
                    "Gali / Society / Block",
                    displayValue(
                        order.customerDetails.address.societyGaliBlockNo.toString()),
                  ),
                  _detailRow(
                    "Sector",
                    displayValue(order.customerDetails.address.sectornumber.toString()),
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

                  /// 🖼️ Address Image in 300-height Rectangle View
                  Builder(
                    builder: (context) {
                      final addressPhoto = order.customerDetails.address.photo.isNotEmpty
                          ? order.customerDetails.address.photo
                          : order.customerDetails.address.imagepath;
                      if (addressPhoto.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: _buildAddressImageRectangle(context, addressPhoto),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCE0FF), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined, size: 14, color: Color(0xff1976D2)),
              const SizedBox(width: 6),
              const Text(
                "Price Breakup",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (bottleTotal > 0 || perBottlePrice > 0)
            _breakupRow(
              "Bottle Price (${perBottlePrice > 0 ? "₹${perBottlePrice.toStringAsFixed(0)} × " : ""}$qty)",
              "₹${bottleTotal.toStringAsFixed(0)}",
              Colors.black87,
            ),

          if (floorTotal > 0) ...[
            const SizedBox(height: 4),
            _breakupRow(
              "Floor Charges (₹${floorRate.toStringAsFixed(0)} × $floorNo floor × $qty)",
              "+ ₹${floorTotal.toStringAsFixed(0)}",
              Colors.orange.shade800,
            ),
          ] else if (isLift && floorNo > 0) ...[
            const SizedBox(height: 4),
            _breakupRow(
              "Floor Charges (Floor $floorNo)",
              "Free (Lift Available)",
              Colors.green.shade700,
            ),
          ],

          if (isQuick) ...[
            const SizedBox(height: 4),
            _breakupRow(
              "Quick Delivery Charge",
              quickP > 0 ? "+ ₹${quickP.toStringAsFixed(0)}" : "+ ₹0",
              Colors.deepOrange.shade600,
            ),
          ],

          if (bottleTotal == 0 && floorTotal == 0 && !isQuick)
            _breakupRow("Base Price", "₹${totalP.toStringAsFixed(0)}", Colors.black87),

          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: Divider(height: 1, color: Colors.blue.shade100),
          ),

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
                  fontSize: 14,
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

  /// 🖼️ Address Image in Rectangle View (300 Height) with Full View on Tap
  Widget _buildAddressImageRectangle(BuildContext context, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.photo_library_outlined, size: 14, color: Color(0xff6B67F6)),
            SizedBox(width: 6),
            Text(
              "Address Photo",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xff6B67F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => FullScreenImageViewer.open(
            context,
            imageUrl: imageUrl,
            title: "Address Photo",
          ),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xff6B67F6)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade100,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            "Failed to load address image",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_out_map_rounded, size: 13, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            "Tap for Full View",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
