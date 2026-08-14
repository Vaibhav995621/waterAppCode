import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'payment_success_controller.dart';

class PaymentSuccessView extends GetView<PaymentSuccessController> {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FD),
      body: Stack(
        children: [
          /// Top Left circle
          Positioned(
            top: -90,
            left: -50,
            child: Container(
              height: 220,
              width: 220,
              decoration: const BoxDecoration(
                color: Color(0xff57B4FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          /// Top Right circle
          Positioned(
            top: -70,
            right: -80,
            child: Container(
              height: 240,
              width: 240,
              decoration: const BoxDecoration(
                color: Color(0xff6C63FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _AnimatedSuccessContent(controller: controller),
              ),
            ),
          ),

          /// Bottom Left circle
          Positioned(
            bottom: -60,
            left: -50,
            child: Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                color: Color(0xff6C63FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          /// Bottom Right circle
          Positioned(
            bottom: -70,
            right: -40,
            child: Container(
              height: 180,
              width: 180,
              decoration: const BoxDecoration(
                color: Color(0xff57B4FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main animated content
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedSuccessContent extends StatefulWidget {
  final PaymentSuccessController controller;
  const _AnimatedSuccessContent({required this.controller});

  @override
  State<_AnimatedSuccessContent> createState() =>
      _AnimatedSuccessContentState();
}

class _AnimatedSuccessContentState extends State<_AnimatedSuccessContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Icon animations
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;

  // Ring burst
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;

  // Confetti
  late Animation<double> _confettiProgress;

  // Staggered slide-ups
  late Animation<double> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<double> _descSlide;
  late Animation<double> _descOpacity;
  late Animation<double> _cardSlide;
  late Animation<double> _cardOpacity;
  late Animation<double> _btnSlide;
  late Animation<double> _btnOpacity;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // ── Icon ─────────────────────────────────────────────
    _iconScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
    );
    _iconOpacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
    );

    // ── Ring burst ───────────────────────────────────────
    _ringScale = Tween<double>(begin: 0.6, end: 1.6).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.05, 0.5, curve: Curves.easeOut),
      ),
    );
    _ringOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.05, 0.5, curve: Curves.easeOut),
      ),
    );

    // ── Confetti ─────────────────────────────────────────
    _confettiProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
      ),
    );

    // ── Title ────────────────────────────────────────────
    _titleSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.35, 0.6, curve: Curves.easeOut),
      ),
    );
    _titleOpacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.35, 0.6, curve: Curves.easeIn),
    );

    // ── Description ──────────────────────────────────────
    _descSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.45, 0.68, curve: Curves.easeOut),
      ),
    );
    _descOpacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 0.68, curve: Curves.easeIn),
    );

    // ── Amount card ───────────────────────────────────────
    _cardSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.55, 0.78, curve: Curves.easeOut),
      ),
    );
    _cardOpacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.55, 0.78, curve: Curves.easeIn),
    );

    // ── Button ────────────────────────────────────────────
    _btnSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.68, 0.90, curve: Curves.easeOut),
      ),
    );
    _btnOpacity = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.68, 0.90, curve: Curves.easeIn),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────
  _IconConfig _iconConfig() {
    final type = widget.controller.type.value;
    if (type == "cod") {
      return _IconConfig(Icons.local_shipping_outlined,
          [const Color(0xff4CAF50), const Color(0xff81C784)]);
    } else if (type == "subscription") {
      return _IconConfig(Icons.star_rounded,
          [const Color(0xffFF9F1C), const Color(0xffFFBF69)]);
    } else if (type == "subscription_purchase") {
      return _IconConfig(Icons.card_membership_rounded,
          [const Color(0xff6C63FF), const Color(0xff57B4FF)]);
    } else if (type == "wallet" || type == "wallet_recharge") {
      return _IconConfig(Icons.account_balance_wallet_rounded,
          [const Color(0xffFF9F1C), const Color(0xffFFD000)]);
    }
    return _IconConfig(
        Icons.check, [const Color(0xff57B4FF), const Color(0xff6C63FF)]);
  }

  String _title() {
    switch (widget.controller.type.value) {
      case "cod":
        return "Order Placed!";
      case "subscription":
        return "Order Confirmed!";
      case "subscription_purchase":
        return "Subscription Active!";
      case "wallet":
        return "Order Confirmed!";
      case "wallet_recharge":
        return "Wallet Recharged!";
      default:
        return "Payment Successful";
    }
  }

  String _desc() {
    switch (widget.controller.type.value) {
      case "cod":
        return "Your order has been placed successfully.\nPlease pay cash upon delivery.";
      case "subscription":
        return "Your order has been confirmed using\nyour active subscription plan.";
      case "subscription_purchase":
        return "Your subscription plan has been\nactivated successfully.";
      case "wallet":
        return "Your order has been confirmed.\nAmount deducted from your wallet.";
      case "wallet_recharge":
        return "Your recharge has been confirmed.\nAmount added to your wallet.";
      default:
        return "Your payment has been completed\nsuccessfully.";
    }
  }

  String _cardTitle() {
    switch (widget.controller.type.value) {
      case "cod":
        return "Amount to Pay";
      case "subscription":
        return "Payment Method";
      case "subscription_purchase":
        return "Plan Amount";
      case "wallet":
        return "Paid via Wallet";
      default:
        return "Amount Paid";
    }
  }

  String _cardValue() {
    if (widget.controller.type.value == "subscription") {
      return "Subscription Plan";
    }
    return widget.controller.amount.value;
  }

  // ── build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cfg = _iconConfig();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Animated icon with ring + confetti ──────────────────────────
          SizedBox(
            height: 180,
            width: 180,
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Confetti burst
                    CustomPaint(
                      size: const Size(180, 180),
                      painter: _ConfettiPainter(
                        progress: _confettiProgress.value,
                        colors: cfg.gradientColors,
                      ),
                    ),

                    // Ring pulse
                    Opacity(
                      opacity: _ringOpacity.value,
                      child: Transform.scale(
                        scale: _ringScale.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cfg.gradientColors[0],
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Icon
                    FadeTransition(
                      opacity: _iconOpacity,
                      child: ScaleTransition(
                        scale: _iconScale,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: cfg.gradientColors,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: cfg.gradientColors[0].withOpacity(0.35),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            cfg.icon,
                            color: Colors.white,
                            size: 62,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // ── Title ─────────────────────────────────────────────────────────
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Opacity(
              opacity: _titleOpacity.value,
              child: Transform.translate(
                offset: Offset(0, _titleSlide.value),
                child: Text(
                  _title(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4A4A4A),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Description ───────────────────────────────────────────────────
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Opacity(
              opacity: _descOpacity.value,
              child: Transform.translate(
                offset: Offset(0, _descSlide.value),
                child: Text(
                  _desc(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // ── Amount / Info card ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Opacity(
              opacity: _cardOpacity.value,
              child: Transform.translate(
                offset: Offset(0, _cardSlide.value),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _cardTitle(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff4A4A4A),
                        ),
                      ),
                      Text(
                        _cardValue(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6C63FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 50),

          // ── Back to Home button ───────────────────────────────────────────
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Opacity(
              opacity: _btnOpacity.value,
              child: Transform.translate(
                offset: Offset(0, _btnSlide.value),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xff57B4FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: widget.controller.goToHome,
                    child: const Text(
                      "Back To Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Icon config helper
// ─────────────────────────────────────────────────────────────────────────────
class _IconConfig {
  final IconData icon;
  final List<Color> gradientColors;
  const _IconConfig(this.icon, this.gradientColors);
}

// ─────────────────────────────────────────────────────────────────────────────
// Confetti burst painter
// ─────────────────────────────────────────────────────────────────────────────
class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  static const int _particleCount = 16;
  static final List<double> _angles = List.generate(
    _particleCount,
    (i) => (2 * pi / _particleCount) * i,
  );
  static final List<double> _sizes = [5, 7, 5, 6, 7, 5, 6, 7, 5, 6, 5, 7, 6, 5, 7, 6];
  static final List<bool> _isRect = [
    true, false, false, true, false, true, false, false,
    true, false, true, false, false, true, false, true
  ];

  const _ConfettiPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.52;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (int i = 0; i < _particleCount; i++) {
      final angle = _angles[i];
      final r = maxRadius * progress;
      final dx = center.dx + r * cos(angle);
      final dy = center.dy + r * sin(angle);

      final color = colors[i % colors.length].withOpacity(opacity);
      final paint = Paint()..color = color;
      final sz = _sizes[i] * (1.0 - progress * 0.3);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle + progress * pi);

      if (_isRect[i]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: sz, height: sz * 1.5),
            const Radius.circular(1.5),
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, sz / 2, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}