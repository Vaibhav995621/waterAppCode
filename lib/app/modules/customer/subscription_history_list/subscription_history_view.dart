import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zourney/app/modules/customer/subscription_history_list/subscription_history_controller.dart';
import 'package:zourney/app/models/subcription_model/subscription_history_model.dart';

class SubscriptionHistoryView extends GetView<SubscriptionHistoryController> {
  const SubscriptionHistoryView({super.key});

  // ─── Design Tokens ────────────────────────────────────────────────────────
  static const Color _blue = Color(0xFF54A3F5);
  static const Color _purple = Color(0xFF7C83FD);
  static const Color _teal = Color(0xFF06B6A2);
  static const Color _bgLight = Color(0xFFF3F8FF);
  static const Color _cardBg = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoader();
        }
        if (controller.subscriptionList.isEmpty) {
          return _buildEmptyState();
        }
        return _buildList();
      }),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Transaction History',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_purple, _blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  // ─── Loading ──────────────────────────────────────────────────────────────
  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(
        color: _purple,
        strokeWidth: 3,
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _purple.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long_rounded, size: 56, color: _purple.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Transactions Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your transaction history will\nappear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  // ─── Transaction List ─────────────────────────────────────────────────────
  Widget _buildList() {
    // Group stats
    final totalSubscriptions = controller.subscriptionList
        .where((e) => e.isSubscription)
        .length;
    final totalWalletTopUps = controller.subscriptionList
        .where((e) => e.isWalletTopUp)
        .length;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: controller.subscriptionList.length + 1, // +1 for summary header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSummaryHeader(totalSubscriptions, totalWalletTopUps);
        }
        final item = controller.subscriptionList[index - 1];
        return item.isWalletTopUp
            ? _buildWalletTopUpCard(item)
            : _buildSubscriptionCard(item);
      },
    );
  }

  // ─── Summary Header ───────────────────────────────────────────────────────
  Widget _buildSummaryHeader(int subscriptions, int walletTopUps) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purple, _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryStat(
              icon: Icons.card_membership_rounded,
              label: 'Subscriptions',
              value: '$subscriptions',
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildSummaryStat(
              icon: Icons.account_balance_wallet_rounded,
              label: 'Wallet Top-ups',
              value: '$walletTopUps',
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildSummaryStat(
              icon: Icons.receipt_rounded,
              label: 'Total',
              value: '${controller.subscriptionList.length}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat({
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
            fontSize: 22,
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

  // ─── Subscription Plan Card ───────────────────────────────────────────────
  Widget _buildSubscriptionCard(SubscriptionData item) {
    final details = item.subscriptionDetails;
    final discountAmount = details != null
        ? (double.tryParse(details.originalprice) ?? 0) -
            (double.tryParse(details.price) ?? 0)
        : 0.0;
    final hasDiscount = discountAmount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
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
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // ── Gradient Header ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_purple.withValues(alpha: 0.12), _blue.withValues(alpha: 0.06)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _purple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
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
                          details?.planname ?? 'Subscription Plan',
                          style: const TextStyle(
                            color: _purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (details?.plandetails != null &&
                            details!.plandetails.isNotEmpty)
                          Text(
                            details.plandetails,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(item.status),
                ],
              ),
            ),

            // ── Card Body ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price & Quantity row
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.water_drop_rounded,
                        iconColor: _blue,
                        label: 'Quantity',
                        value: '${details?.bottlequantity ?? 0} Bottles',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.currency_rupee_rounded,
                        iconColor: _teal,
                        label: 'Paid',
                        value: '₹${item.totalamount}',
                        valueColor: _teal,
                        isBold: true,
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 12),
                        _buildInfoChip(
                          icon: Icons.local_offer_rounded,
                          iconColor: Colors.orange,
                          label: 'Saved',
                          value: '₹${discountAmount.toStringAsFixed(0)}',
                          valueColor: Colors.orange,
                        ),
                      ],
                    ],
                  ),

                  if (hasDiscount && details != null) ...[
                    const SizedBox(height: 10),
                    // Original price strikethrough
                    Row(
                      children: [
                        const Icon(Icons.sell_rounded,
                            size: 13, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          'Original Price: ',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        Text(
                          '₹${details.originalprice}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 0.8, color: Color(0xFFF3F4F6)),
                  ),

                  // Transaction details
                  _buildDetailRow(
                    icon: Icons.tag_rounded,
                    label: 'Transaction ID',
                    value: item.transId,
                    valueStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date & Time',
                    value: DateFormat('dd MMM yyyy  •  hh:mm a').format(item.transDate),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Wallet Top-up Card ───────────────────────────────────────────────────
  Widget _buildWalletTopUpCard(SubscriptionData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
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
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // ── Gradient Header ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_teal.withValues(alpha: 0.12), _blue.withValues(alpha: 0.06)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _teal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
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
                  _buildStatusBadge(item.status, color: _teal),
                ],
              ),
            ),

            // ── Card Body ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount highlighted
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.add_circle_rounded,
                        iconColor: _teal,
                        label: 'Amount Added',
                        value: '₹${item.totalamount}',
                        valueColor: _teal,
                        isBold: true,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.account_balance_wallet_rounded,
                        iconColor: _blue,
                        label: 'Payment Mode',
                        value: 'Wallet',
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 0.8, color: Color(0xFFF3F4F6)),
                  ),

                  // Transaction details
                  _buildDetailRow(
                    icon: Icons.tag_rounded,
                    label: 'Transaction ID',
                    value: item.transId,
                    valueStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date & Time',
                    value: DateFormat('dd MMM yyyy  •  hh:mm a').format(item.transDate),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared Widgets ───────────────────────────────────────────────────────

  Widget _buildStatusBadge(int status, {Color? color}) {
    final isActive = status == 1;
    final badgeColor = color ?? (isActive ? _blue : Colors.amber[700]!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            isActive ? 'Success' : 'Pending',
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 13, color: iconColor),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
          ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: valueStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
          ),
        ),
      ],
    );
  }
}