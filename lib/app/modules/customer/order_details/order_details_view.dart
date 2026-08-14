import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zourney/utlis/app_config.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import '../../../widgets/full_screen_image_viewer.dart';
import 'order_detail_controller.dart';

/// Resolves a potentially relative image path to an absolute URL.
String _resolveImageUrl(String rawPath) {
  final trimmed = rawPath.trim();
  if (trimmed.isEmpty || trimmed == 'null') return '';
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  final serverRoot = AppConfig.config.baseUrl
      .replaceAll('/api/apps/', '')
      .replaceAll('/api/apps', '');
  final cleanPath = trimmed.startsWith('/') ? trimmed : '/$trimmed';
  return '$serverRoot$cleanPath';
}

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
                                getPaymentStatusText(order.paymentstatus),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// Quick Delivery / Scheduled badges
                        if (order.quickDelivery == 1 || order.isSchedule == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0) ...[
                          const SizedBox(height: 8),
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
                          displayValue(order.waterbottleName),
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

                        if (order.quickDelivery == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0)
                          _detailRow(
                            "Delivery Type",
                            "⚡ Quick Delivery",
                          ),

                        if ((double.tryParse(order.quickdeliverycharge) ?? 0) > 0 || order.quickDelivery == 1)
                          _detailRow(
                            "Quick Delivery Charge",
                            "₹${(double.tryParse(order.quickdeliverycharge) ?? 0).toStringAsFixed(0)}",
                          ),

                        if (order.isSchedule == 1)
                          _detailRow(
                            "Delivery Schedule",
                            "🗓 Scheduled",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Full address summary at the top
                        _buildFullAddressSummary(order),

                        const Divider(height: 24, thickness: 0.5),

                        _detailRow(
                          "Flat No / House No.",
                          _buildFlatHouseValue(order),
                        ),
                        _detailRow(
                          "Gali / Society / Block",
                          _buildGaliSocietyValue(order),
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
                            final rawPath = order.customerDetails.address.photo.isNotEmpty
                                ? order.customerDetails.address.photo
                                : order.customerDetails.address.imagepath;
                            final addressPhoto = _resolveImageUrl(rawPath);
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
                  ),

                  const SizedBox(height: 16),

                  /// ORDER SUMMARY
                  _sectionTitle("Order Summary"),
                  _priceBreakup(order),

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

  /// Helper: combine flat number and house number
  String _buildFlatHouseValue(Order order) {
    final flat = displayValue(order.customerDetails.address.houseFlatFloorNo);
    if (flat != 'N/A') return flat;
    if (flat != 'N/A') return flat;
    return 'N/A';
  }

  /// Helper: combine gali number and society name
  String _buildGaliSocietyValue(Order order) {
    final gali = displayValue(order.customerDetails.address.societyGaliBlockNo.toString());
    if (gali != 'N/A') return gali;
    if (gali != 'N/A') return gali;
    return 'N/A';
  }

  /// Full address summary widget shown at the top of the Delivery Address card
  Widget _buildFullAddressSummary(Order order) {
    final addr = order.customerDetails.address;
    final parts = <String>[];

    final flatHouse = _buildFlatHouseValue(order);
    if (flatHouse != 'N/A') parts.add(flatHouse);

    final galiSociety = _buildGaliSocietyValue(order);
    if (galiSociety != 'N/A') parts.add(galiSociety);

    final sector = displayValue(addr.sectornumber.toString());
    if (sector != 'N/A') parts.add('Sector $sector');

    final landmark = displayValue(addr.landmark);
    if (landmark != 'N/A') parts.add(landmark);

    final city = displayValue(addr.city);
    final state = displayValue(addr.state);
    final pincode = displayValue(addr.pincode);

    final cityStateParts = <String>[];
    if (city != 'N/A') cityStateParts.add(city);
    if (state != 'N/A') cityStateParts.add(state);
    if (pincode != 'N/A') cityStateParts.add(pincode);
    if (cityStateParts.isNotEmpty) parts.add(cityStateParts.join(', '));

    final fullText = parts.join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffEEF4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_rounded, color: Color(0xff1976D2), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fullText.isEmpty ? 'N/A' : fullText,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xff1A2C56),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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

  /// 💰 Price Breakup — same style as order list
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

  /// Single breakup row
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

  String getPaymentStatusText(String status) {
    switch (status.trim()) {
      case '0':
        return 'COD';
      case '1':
        return 'online';
      case '2':
        return 'subscribe';
      case '3':
        return 'wallet';
      default:
        return status;
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

  /// 🖼️ Address Image — 300 px tall rectangle with Hero → full-screen on tap
  Widget _buildAddressImageRectangle(BuildContext context, String imageUrl) {
    const heroTag = 'customer_order_address_photo';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label row ───────────────────────────────────────────────────────
        const Row(
          children: [
            Icon(Icons.photo_library_outlined, size: 14, color: Color(0xff1976D2)),
            SizedBox(width: 6),
            Text(
              'Address Photo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xff1976D2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ── 300-height rectangle card ────────────────────────────────────────
        GestureDetector(
          onTap: () => FullScreenImageViewer.open(
            context,
            imageUrl: imageUrl,
            title: 'Address Photo',
            tag: heroTag,
          ),
          child: Hero(
            tag: heroTag,
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
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
                    // ── Network image ──────────────────────────────────────
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        final total = progress.expectedTotalBytes;
                        final loaded = progress.cumulativeBytesLoaded;
                        return Center(
                          child: CircularProgressIndicator(
                            value: total != null ? loaded / total : null,
                            color: const Color(0xff1976D2),
                            strokeWidth: 2.5,
                          ),
                        );
                      },
                      errorBuilder: (ctx, error, _) => Container(
                        color: Colors.grey.shade100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Failed to load address image',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── "Tap for Full View" badge ──────────────────────────
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.70),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.zoom_out_map_rounded, size: 13, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'Tap for Full View',
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
        ),
      ],
    );
  }
}
