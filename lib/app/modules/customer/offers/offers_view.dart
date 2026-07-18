import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // HEADER
              const Center(
                child: Text(
                  "Offers & Vouchers",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff0A1D5E),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // VOUCHER CARD 1: WALLET CASHBACK
              _buildOfferCard(
                title: "5% WALLET CASHBACK",
                subtitle: "Add money to wallet & get 5% instant cashback",
                code: "WATER5",
                gradient: const [Color(0xff4A3AFF), Color(0xffE255FF)],
                icon: Icons.wallet_giftcard_rounded,
                onTap: () {
                  Get.snackbar(
                    "Code Copied",
                    "Use code WATER5 on your next wallet recharge!",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),

              const SizedBox(height: 15),

              // VOUCHER CARD 2: PREMIUM PACKAGE
              _buildOfferCard(
                title: "SAVE ₹50 ON PREMIUM",
                subtitle: "Upgrade to Premium Water Package (15 Bottles)",
                code: "PREMIUM50",
                gradient: const [Color(0xff00D84A), Color(0xff00B83E)],
                icon: Icons.savings_rounded,
                onTap: () {
                  Get.toNamed(AppRoutes.subscription);
                },
              ),

              const SizedBox(height: 15),

              // VOUCHER CARD 3: FIRST BOOKING
              _buildOfferCard(
                title: "FREE DELIVERY",
                subtitle: "Enjoy free shipping on order of 3+ bottles",
                code: "FREESHIP",
                gradient: const [Color(0xffFF8C00), Color(0xffFF3D00)],
                icon: Icons.local_shipping_rounded,
                onTap: () {
                  Get.toNamed(AppRoutes.bookingWaterScreen);
                },
              ),

              const SizedBox(height: 30),

              // PROMOTION BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.celebration_rounded,
                      color: Color(0xff6B67F6),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Refer & Earn ₹100",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0A1D5E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Invite your friends to Zourney and earn ₹100 cash in your wallet when they buy their first subscription!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          "Referral Link",
                          "Referral link copied to clipboard!",
                          backgroundColor: const Color(0xff6B67F6),
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6B67F6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Share Code"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String subtitle,
    required String code,
    required List<Color> gradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              icon,
              size: 100,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "CODE: $code",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: gradient[0],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Redeem",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
