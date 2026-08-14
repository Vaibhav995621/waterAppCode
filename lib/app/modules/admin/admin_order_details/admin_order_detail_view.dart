import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zourney/utlis/app_config.dart';
import 'package:zourney/utlis/constants/app_colors.dart';

import '../../../models/Admin/admin_order_list/admin_order_model.dart';
import '../../../widgets/full_screen_image_viewer.dart';
import 'admin_order_detail_controller.dart';

/// Resolves a potentially relative image path to an absolute URL.
/// If the path is already a full http/https URL, it's returned as-is.
/// Otherwise, the server base (without /api/apps/) is prepended.
String _resolveImageUrl(String rawPath) {
  final trimmed = rawPath.trim();
  if (trimmed.isEmpty || trimmed == 'null') return '';
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  // Strip the api/apps/ suffix to get the server root
  final serverRoot = AppConfig.config.baseUrl
      .replaceAll('/api/apps/', '')
      .replaceAll('/api/apps', '');
  final cleanPath = trimmed.startsWith('/') ? trimmed : '/$trimmed';
  return '$serverRoot$cleanPath';
}

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
                              _buildPaymentModeChip(order.paymentmode),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: 12,
                              //     vertical: 6,
                              //   ),
                              //   decoration: BoxDecoration(
                              //     color: Colors.green.shade100,
                              //     borderRadius: BorderRadius.circular(20),
                              //   ),
                              //   child: Text(
                              //     getPaymentStatusText(order.paymentstatus),
                              //     style: TextStyle(
                              //       color: Colors.green.shade800,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
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
                            getPaymentStatusText(order.paymentstatus),
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

                    /// CUSTOMER DETAILS — only show when we have real data
                    if (order.customerDetails.id > 0) ...
                      [
                        const SizedBox(height: 16),

                        _sectionTitle("Customer Information"),

                        _buildCard(
                          child: Column(
                            children: [
                              // Photo
                              if (order.customerDetails.photo.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () => FullScreenImageViewer.open(
                                        context,
                                        imageUrl: order.customerDetails.photo,
                                        title: "${order.customerDetails.fullname}'s Photo",
                                      ),
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          CircleAvatar(
                                            radius: 36,
                                            backgroundColor: const Color(0xffEDE7F6),
                                            backgroundImage: NetworkImage(
                                              order.customerDetails.photo,
                                            ),
                                            onBackgroundImageError: (_, _) {},
                                            child: order.customerDetails.photo.isEmpty
                                                ? const Icon(
                                                    Icons.person,
                                                    size: 36,
                                                    color: Color(0xff5E35B1),
                                                  )
                                                : null,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Color(0xff5E35B1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.zoom_in_rounded, size: 12, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              _detailRow("Name", order.customerDetails.fullname),

                              _detailRow(
                                "Mobile",
                                order.customerDetails.mobile,
                                onCallTap: () =>
                                    makePhoneCall(order.customerDetails.mobile),
                              ),

                              _detailRow("Email", order.customerDetails.email),

                              _detailRow(
                                "Plan Bottles",
                                order.customerDetails.planbottlequantity.toString(),
                              ),
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
                                displayValue(order.customerDetails.address.fulladdress),
                              ),

                              _detailRow(
                                "Flat No / House No.",
                                displayValue(
                                    order.customerDetails.address.houseFlatFloorNo),
                              ),
                              _detailRow(
                                "Gali / Society / Block",
                                displayValue(
                                    order.customerDetails.address.societyGaliBlockNo),
                              ),
                              _detailRow(
                                "Sector",
                                displayValue(
                                    order.customerDetails.address.sectornumber),
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
                                  // Pick photo or imagepath, then resolve to absolute URL
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
                      ],

                    const SizedBox(height: 16),

                    /// ORDER SUMMARY (Price Breakup)
                    _sectionTitle("Order Summary"),
                    _priceBreakup(order),

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

                    if (order.status == 0)
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
                    if (order.status == 0)
                      SizedBox(height: 10,),
                    if (order.status == 0 || order.status == 2)
                      SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.updateOrderStatus('5'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Order Cancel",
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

  String displayValue(String? value) {
    if (value == null) return "N/A";
    final clean = value.trim().toLowerCase();
    if (clean.isEmpty || clean == "null" || clean == "n/a" || clean == "na") {
      return "N/A";
    }
    return value;
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

  Widget _buildPaymentModeChip
      (int mode) {
    final Map<int, _PaymentModeInfo> modeMap = {
      0: _PaymentModeInfo('COD', const Color(0xffE65100), const Color(0xffFFF3E0)),
      1: _PaymentModeInfo('Online', const Color(0xff2E7D32), const Color(0xffE8F5E9)),
      2: _PaymentModeInfo('Subscribed', const Color(0xffC62828), const Color(0xffFFEBEE)),
      3: _PaymentModeInfo('Wallet', const Color(0xff6A1B9A), const Color(0xffF3E5F5)),
    };
    final info = modeMap[mode] ?? _PaymentModeInfo('N/A', Colors.grey.shade600, Colors.grey.shade100);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: info.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        info.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: info.fg,
        ),
      ),
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

  /// 🖼️ Address Image — 300 px tall rectangle with Hero → full-screen on tap
  Widget _buildAddressImageRectangle(BuildContext context, String imageUrl) {
    const heroTag = 'admin_order_address_photo';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label row ───────────────────────────────────────────────────────
        const Row(
          children: [
            Icon(Icons.photo_library_outlined, size: 14, color: Color(0xff5E35B1)),
            SizedBox(width: 6),
            Text(
              'Address Photo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xff5E35B1),
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
                            color: const Color(0xff5E35B1),
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
class _PaymentModeInfo {
  final String label;
  final Color fg;
  final Color bg;
  const _PaymentModeInfo(this.label, this.fg, this.bg);
}