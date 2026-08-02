import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/payment_history_model/payment_histroy_model.dart';
import 'payment_history_controller.dart';

class PaymentHistoryScreen extends StatelessWidget {
  PaymentHistoryScreen({super.key});

  final controller = Get.find<PaymentHistoryController>();

  // ─── Design Tokens ─────────────────────────────────────────────────────────
  static const Color _blue = Color(0xFF54A3F5);
  static const Color _purple = Color(0xFF6C63FF);
  static const Color _teal = Color(0xFF06B6A2);
  static const Color _bg = Color(0xFFF5F8FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Decorative circles ───────────────────────────────────────────
          Positioned(
            top: -60,
            left: -60,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: 180,
                width: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF62B5F8),
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      bottom: 30,
                      right: 60,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -80,
            child: Container(
              height: 220,
              width: 220,
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ── Main Content ─────────────────────────────────────────────────
          Column(
            children: [
              const SizedBox(height: 80),

              // ── Header icon + title ──────────────────────────────────────
              const CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFF58B6FF),
                child: Icon(Icons.payment, color: Colors.white, size: 35),
              ),
              const SizedBox(height: 12),
              const Text(
                "Payment History",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(height: 20),

              // ── List ─────────────────────────────────────────────────────
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return _buildShimmerLoading();
                  }

                  if (controller.paymentList.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return _buildList(context);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.paymentHistoryList(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _purple.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    size: 52,
                    color: _purple.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "No Payments Yet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your payment history will appear here.",
                  style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Full List ────────────────────────────────────────────────────────────
  Widget _buildList(BuildContext context) {
    final subscriptionCount =
        controller.paymentList.where((e) => e.isSubscription).length;
    final walletCount =
        controller.paymentList.where((e) => e.isWalletTopUp).length;
    final orderCount =
        controller.paymentList.where((e) => e.isOrder).length;
    final totalSpent = controller.paymentList.fold<double>(
      0,
      (sum, e) => sum + (double.tryParse(e.totalamount) ?? 0),
    );

    return RefreshIndicator(
      onRefresh: () => controller.paymentHistoryList(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        itemCount: controller.paymentList.length + 1, // +1 for summary card
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSummaryCard(
              subscriptionCount: subscriptionCount,
              walletCount: walletCount,
              orderCount: orderCount,
              totalSpent: totalSpent,
            );
          }
          final item = controller.paymentList[index - 1];
          if (item.isWalletTopUp) {
            return _buildWalletCard(item);
          } else if (item.isOrder) {
            return _buildOrderCard(item);
          } else {
            return _buildSubscriptionCard(item);
          }
        },
      ),
    );
  }

  // ─── Summary Card ─────────────────────────────────────────────────────────
  Widget _buildSummaryCard({
    required int subscriptionCount,
    required int walletCount,
    required int orderCount,
    required double totalSpent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purple, _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryStatCol(
                  icon: Icons.card_membership_rounded,
                  label: 'Subscriptions',
                  value: '$subscriptionCount',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _summaryStatCol(
                  icon: Icons.shopping_bag_rounded,
                  label: 'Orders',
                  value: '$orderCount',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _summaryStatCol(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Wallet Top-ups',
                  value: '$walletCount',
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              color: Colors.white24,
              height: 1,
              thickness: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.currency_rupee_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 4),
              Text(
                'Total Spent: ₹${totalSpent.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryStatCol({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ─── Order Card ────────────────────────────────────────────────────────────
  Widget _buildOrderCard(PaymentHistoryData item) {
    final order = item.orderDetails;

    // Resolve order status label & color
    Color _orderStatusColor(int s) {
      switch (s) {
        case 1: return Colors.blue;
        case 2: return Colors.green;
        case 3: return Colors.red;
        default: return Colors.orange;
      }
    }
    String _orderStatusLabel(int s) {
      switch (s) {
        case 1: return 'Assigned';
        case 2: return 'Delivered';
        case 3: return 'Cancelled';
        default: return 'Pending';
      }
    }

    final statusColor = _orderStatusColor(order?.status ?? 0);
    final statusLabel = _orderStatusLabel(order?.status ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _blue.withValues(alpha: 0.11),
                    _purple.withValues(alpha: 0.05)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: _blue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: _blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order != null && order.ordernumber.isNotEmpty
                              ? '#${order.ordernumber}'
                              : 'Order Payment',
                          style: const TextStyle(
                            color: _blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Text(
                          'Water Bottle Purchase',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Order delivery status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        Text(statusLabel,
                          style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Row 1: Paid amount + Total Bottles ─────────────────
                  Row(
                    children: [
                      _infoChip(
                        icon: Icons.currency_rupee_rounded,
                        iconColor: _teal,
                        label: 'Paid',
                        value: '₹${order?.totalprice.isNotEmpty == true ? order!.totalprice : item.totalamount}',
                        valueColor: _teal,
                        bold: true,
                      ),
                      const SizedBox(width: 10),
                      _infoChip(
                        icon: Icons.water_drop_rounded,
                        iconColor: _blue,
                        label: 'Total Bottles',
                        value: '${order?.totalbottle ?? 0} Bottle(s)',
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ── Row 2: Delivered + Empty returned ──────────────────
                  if (order != null) Row(
                    children: [
                      _infoChip(
                        icon: Icons.check_circle_rounded,
                        iconColor: Colors.green,
                        label: 'Delivered',
                        value: '${order.deliveredbottle} Bottle(s)',
                        valueColor: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _infoChip(
                        icon: Icons.swap_horiz_rounded,
                        iconColor: Colors.orange,
                        label: 'Empty Returned',
                        value: '${order.emptybottle} Bottle(s)',
                        valueColor: Colors.orange,
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 0.8, color: Color(0xFFF3F4F6)),
                  ),

                  // ── Detail rows ────────────────────────────────────────
                  if (order?.orderdate != null)
                    _detailRow(
                      icon: Icons.event_rounded,
                      label: 'Order Date',
                      value: DateFormat('dd MMM yyyy').format(order!.orderdate!),
                    ),
                  if (order?.orderdate != null) const SizedBox(height: 8),

                  if (order != null && order.deliverydate.isNotEmpty)
                    _detailRow(
                      icon: Icons.local_shipping_rounded,
                      label: 'Delivery Date',
                      value: order.deliverydate,
                    ),
                  if (order != null && order.deliverydate.isNotEmpty) const SizedBox(height: 8),

                  if (order != null && order.paymentstatusStr.isNotEmpty)
                    _detailRow(
                      icon: Icons.payment_rounded,
                      label: 'Payment Mode',
                      value: order.paymentstatusStr,
                    ),
                  if (order != null && order.paymentstatusStr.isNotEmpty) const SizedBox(height: 8),

                  if (order != null && order.paymenttype.isNotEmpty)
                    _detailRow(
                      icon: Icons.credit_card_rounded,
                      label: 'Payment Type',
                      value: order.paymenttype,
                    ),
                  if (order != null && order.paymenttype.isNotEmpty) const SizedBox(height: 8),

                  _detailRow(
                    icon: Icons.tag_rounded,
                    label: 'Transaction ID',
                    value: item.transId.isEmpty ? 'N/A' : item.transId,
                    mono: true,
                  ),
                  const SizedBox(height: 8),
                  _detailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date & Time',
                    value: DateFormat('dd MMM yyyy  •  hh:mm a').format(item.transDate),
                  ),
                  // ── Customer Details (Admin API only) ──────────────────
                  if (item.customerDetails != null) ...[
                    const SizedBox(height: 12),
                    _buildCustomerSection(item.customerDetails!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Subscription Plan Card ───────────────────────────────────────────────
  Widget _buildSubscriptionCard(PaymentHistoryData item) {
    final plan = item.planDetails;

    // Resolved display name: prefer planname (Customer API), fall back to name (Admin API)
    final planName = (plan?.planname.isNotEmpty == true)
        ? plan!.planname
        : (plan?.name.isNotEmpty == true ? plan!.name : 'Subscription Plan');

    // Resolved description: prefer plandetails, fall back to description
    final planDesc = (plan?.plandetails.isNotEmpty == true)
        ? plan!.plandetails
        : (plan?.description.isNotEmpty == true ? plan!.description : '');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _purple.withValues(alpha: 0.11),
                    _blue.withValues(alpha: 0.05)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.card_membership_rounded,
                      color: _purple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planName,
                          style: const TextStyle(
                            color: _purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (planDesc.isNotEmpty)
                          Text(
                            planDesc,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _statusBadge(item.orderid, item.subscriptionid, activeColor: _purple),
                ],
              ),
            ),

            // ── Body ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Row 1: Paid + Bottles ──────────────────────────────
                  Row(
                    children: [
                      _infoChip(
                        icon: Icons.currency_rupee_rounded,
                        iconColor: _teal,
                        label: 'Plan Price',
                        value: '₹${plan?.price.isNotEmpty == true ? plan!.price : item.totalamount}',
                        valueColor: _teal,
                        bold: true,
                      ),
                      const SizedBox(width: 10),
                      _infoChip(
                        icon: Icons.water_drop_rounded,
                        iconColor: _blue,
                        label: 'Bottles',
                        value: plan?.bottlequantity != null && plan!.bottlequantity > 0
                            ? '${plan.bottlequantity} Bottles'
                            : planDesc.isNotEmpty ? planDesc : 'N/A',
                      ),
                    ],
                  ),

                  // ── Discount row ────────────────────────────────────────
                  if (plan != null && plan.hasDiscount) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _infoChip(
                          icon: Icons.local_offer_rounded,
                          iconColor: Colors.orange,
                          label: 'You Saved',
                          value: '₹${plan.discountAmount.toStringAsFixed(0)}',
                          valueColor: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.sell_rounded, size: 13, color: Color(0xFF9CA3AF)),
                                const SizedBox(width: 4),
                                const Text('MRP: ', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                                Text(
                                  '₹${plan.originalprice}',
                                  style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF9CA3AF),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 0.8, color: Color(0xFFF3F4F6)),
                  ),

                  // ── Detail rows ────────────────────────────────────────
                  if (plan != null && plan.validity.isNotEmpty)
                    _detailRow(
                      icon: Icons.timer_outlined,
                      label: 'Validity',
                      value: plan.validity,
                    ),
                  if (plan != null && plan.validity.isNotEmpty) const SizedBox(height: 8),

                  _detailRow(
                    icon: Icons.tag_rounded,
                    label: 'Transaction ID',
                    value: item.transId.isEmpty ? 'N/A' : item.transId,
                    mono: true,
                  ),
                  const SizedBox(height: 8),
                  _detailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date & Time',
                    value: DateFormat('dd MMM yyyy  •  hh:mm a').format(item.transDate),
                  ),
                  if (plan != null) ...[
                    const SizedBox(height: 8),
                    _detailRow(
                      icon: Icons.event_available_rounded,
                      label: 'Plan Created',
                      value: DateFormat('dd MMM yyyy').format(plan.cdate),
                    ),
                  ],
                  // ── Customer Details (Admin API only) ──────────────────
                  if (item.customerDetails != null) ...[
                    const SizedBox(height: 12),
                    _buildCustomerSection(item.customerDetails!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Wallet Top-up Card ───────────────────────────────────────────────────
  Widget _buildWalletCard(PaymentHistoryData item) {
    final wallet = item.walletDetails;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _teal.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _teal.withValues(alpha: 0.11),
                    _blue.withValues(alpha: 0.05)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: _teal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: _teal,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet Top-up',
                          style: TextStyle(
                            color: _teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Added to wallet balance',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(item.orderid, item.subscriptionid, activeColor: _teal),
                ],
              ),
            ),

            // ── Body ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Row 1: Amount Added + Wallet Balance ───────────────
                  Row(
                    children: [
                      _infoChip(
                        icon: Icons.add_circle_rounded,
                        iconColor: _teal,
                        label: 'Amount Added',
                        value: '₹${wallet?.totalamount ?? item.totalamount}',
                        valueColor: _teal,
                        bold: true,
                      ),
                      if (wallet != null) ...[
                        const SizedBox(width: 10),
                        _infoChip(
                          icon: Icons.account_balance_wallet_rounded,
                          iconColor: _blue,
                          label: 'New Balance',
                          value: '₹${wallet.newamount}',
                          valueColor: _blue,
                          bold: true,
                        ),
                      ],
                    ],
                  ),

                  // ── Row 2: Order deduction row (if any) ────────────────
                  if (wallet != null && wallet.orderamount > 0) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _infoChip(
                          icon: Icons.remove_circle_rounded,
                          iconColor: Colors.red,
                          label: 'Order Deducted',
                          value: '₹${wallet.orderamount}',
                          valueColor: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        // Previous balance = totalamount + orderamount
                        _infoChip(
                          icon: Icons.history_rounded,
                          iconColor: Colors.grey,
                          label: 'Prev. Balance',
                          value: '₹${wallet.totalamount}',
                          valueColor: const Color(0xFF6B7280),
                        ),
                      ],
                    ),
                  ],

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 0.8, color: Color(0xFFF3F4F6)),
                  ),

                  // ── Balance breakdown visual bar ───────────────────────
                  if (wallet != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.bar_chart_rounded, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 6),
                        const Text('Balance: ', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                        Text('₹${wallet.totalamount}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
                        const Text(' → ', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                        Text('₹${wallet.newamount}',
                          style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold,
                            color: wallet.newamount >= wallet.totalamount ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  _detailRow(
                    icon: Icons.tag_rounded,
                    label: 'Transaction ID',
                    value: item.transId.isEmpty ? 'N/A' : item.transId,
                    mono: true,
                  ),
                  const SizedBox(height: 8),
                  _detailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date & Time',
                    value: DateFormat('dd MMM yyyy  •  hh:mm a').format(item.transDate),
                  ),
                  // ── Customer Details (Admin API only) ──────────────────
                  if (item.customerDetails != null) ...[
                    const SizedBox(height: 12),
                    _buildCustomerSection(item.customerDetails!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared Widgets ───────────────────────────────────────────────────────

  // ─── Customer Details Section ─────────────────────────────────────────────
  Widget _buildCustomerSection(CustomerDetails customer) {
    final addr = customer.address;

    // Build a clean full-address string
    final addrParts = <String>[];
    final flatHouse = addr?.houseFlatFloorNo.trim() ?? '';
    final society  = addr?.societyGaliBlockNo.trim() ?? '';
    final sector   = addr?.sectornumber.trim() ?? '';
    final landmark = addr?.landmark.trim() ?? '';
    final city     = addr?.city.trim() ?? '';
    final state    = addr?.state.trim() ?? '';
    final pincode  = addr?.pincode.trim() ?? '';

    if (flatHouse.isNotEmpty) addrParts.add(flatHouse);
    if (society.isNotEmpty)   addrParts.add(society);
    if (sector.isNotEmpty)    addrParts.add('Sector $sector');
    if (landmark.isNotEmpty)  addrParts.add(landmark);

    final cityLine = [city, state, pincode].where((s) => s.isNotEmpty).join(', ');
    if (cityLine.isNotEmpty) addrParts.add(cityLine);

    final fullAddr = addrParts.isNotEmpty
        ? addrParts.join(', ')
        : (addr?.fulladdress.trim().isNotEmpty == true ? addr!.fulladdress : 'N/A');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _purple.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ───────────────────────────────────────────
          Row(
            children: [
              Icon(Icons.person_rounded, size: 14, color: _purple.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Text(
                'Customer Details',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _purple.withValues(alpha: 0.8),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Avatar + name + mobile + email ───────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photo / Avatar
              CircleAvatar(
                radius: 26,
                backgroundColor: _purple.withValues(alpha: 0.15),
                backgroundImage: customer.photo.isNotEmpty
                    ? NetworkImage(customer.photo)
                    : null,
                onBackgroundImageError: customer.photo.isNotEmpty
                    ? (_, __) {}
                    : null,
                child: customer.photo.isEmpty
                    ? Icon(Icons.person, color: _purple, size: 26)
                    : null,
              ),
              const SizedBox(width: 12),

              // Name + email column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.fullname.isNotEmpty ? customer.fullname : 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    if (customer.email.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.email_rounded, size: 11, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              customer.email,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Mobile call button
              if (customer.mobile.isNotEmpty)
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse('tel:${customer.mobile}');
                    try {
                      await launchUrlScheme(uri);
                    } catch (_) {}
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.call_rounded, size: 13, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        Text(
                          customer.mobile,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 0.6, color: Color(0xFFDDE3F0)),
          const SizedBox(height: 10),

          // ── Plan bottles ─────────────────────────────────────────────
          if (customer.planbottlequantity > 0) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.water_drop_rounded, size: 13, color: _blue),
                ),
                const SizedBox(width: 8),
                Text(
                  'Plan Bottle Qty: ',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
                Text(
                  '${customer.planbottlequantity} Bottles',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          // ── Address ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_rounded, size: 15, color: _purple.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    fullAddr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF374151),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Phone launch helper ──────────────────────────────────────────────────
  Future<void> launchUrlScheme(Uri uri) async {
    // ignore: import_of_legacy_library_into_null_safe
    // Use url_launcher if available; graceful no-op otherwise
    try {
      // Attempt dynamic launch; import handled at top of file via url_launcher
      // ignore: deprecated_member_use
      if (!await canLaunchUrl(uri)) return;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Widget _statusBadge(int orderId, int subscriptionId, {required Color activeColor}) {
    Color color;
    String text;
    if (subscriptionId > 0) {
      color = _purple;
      text = 'Subscribed';
    } else if (orderId == 0 && subscriptionId == 0) {
      color = _teal;
      text = 'Wallet';
    } else if (orderId != 0) {
      color = activeColor;
      text = 'Online';
    } else if (orderId == 2) {
      color = Colors.red.shade600;
      text = 'Failed';
    } else {
      color = Colors.grey;
      text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
    bool bold = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: iconColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9CA3AF)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? const Color(0xFF1F2937),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    bool mono = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
              fontFamily: mono ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Shimmer Loading ──────────────────────────────────────────────────────
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header shimmer
              Row(
                children: [
                  _shimmerBox(width: 42, height: 42, radius: 12),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(width: 120, height: 16, radius: 4),
                        const SizedBox(height: 6),
                        _shimmerBox(width: 80, height: 12, radius: 4),
                      ],
                    ),
                  ),
                  _shimmerBox(width: 56, height: 24, radius: 20),
                ],
              ),

              const Divider(height: 24, thickness: 0.8, color: Color(0xFFF3F4F6)),

              // Info chips shimmer
              Row(
                children: [
                  Expanded(child: _shimmerBox(height: 56, radius: 12)),
                  const SizedBox(width: 10),
                  Expanded(child: _shimmerBox(height: 56, radius: 12)),
                ],
              ),

              const Divider(height: 20, thickness: 0.8, color: Color(0xFFF3F4F6)),

              _shimmerBox(width: double.infinity, height: 13, radius: 4),
              const SizedBox(height: 8),
              _shimmerBox(width: 180, height: 13, radius: 4),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox({
    double? width,
    required double height,
    required double radius,
  }) {
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