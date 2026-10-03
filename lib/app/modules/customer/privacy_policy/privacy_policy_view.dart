import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5FB),
      body: Column(
        children: [
          /// Top App Bar Header
          _buildHeader(),

          /// Content
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              children: [
                /// Top Privacy Shield Banner
                _buildHeroBanner(),

                const SizedBox(height: 18),

                /// Section: About Our App
                _buildCardSection(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xff1E88E5),
                  iconBgColor: const Color(0xffE3F2FD),
                  title: "About Our App",
                  child: const Text(
                    "Our app is designed to help you drink enough water throughout the day. It lets you track your daily water intake and sends reminders when it may be time to drink water.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff4B5563),
                      height: 1.55,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Section: Your Privacy Matters
                _buildCardSection(
                  icon: Icons.security_rounded,
                  iconColor: const Color(0xff2E7D32),
                  iconBgColor: const Color(0xffE8F5E9),
                  title: "Your Privacy Matters",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "We respect your privacy and are committed to keeping your information secure.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1A2C56),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildBulletPoint(
                        "We collect only the information needed to provide hydration tracking and reminders.",
                      ),
                      _buildBulletPoint(
                        "Your water-intake data is used to display your progress and personalize your experience.",
                      ),
                      _buildBulletPoint(
                        "We do not sell your personal information to third parties.",
                      ),
                      _buildBulletPoint(
                        "You can manage notification and app permissions at any time.",
                      ),
                      _buildBulletPoint(
                        "We use reasonable security measures to protect your information.",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Section: Important Notice
                _buildNoticeCard(),

                const SizedBox(height: 16),

                /// Agreement Footer Card
                _buildAgreementCard(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Top App Bar Header
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 44, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4527A0), Color(0xff5E35B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Transparency & data security",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Hero Banner
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff3949AB), Color(0xff1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff3949AB).withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Privacy Matters",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Learn how we collect, use, and protect your information responsibly.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card Section Wrapper
  Widget _buildCardSection({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1A2C56),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  /// Bullet Point Item
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Color(0xffE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 12,
              color: Color(0xff2E7D32),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xff4B5563),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Important Notice Card
  Widget _buildNoticeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffFFF8E1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffFFE082),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xffFFA000),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.priority_high_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Important Notice",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "This app is intended for general hydration tracking and reminders. It is not a medical device and does not provide medical diagnosis or treatment.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xff6D4C41),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Agreement Card
  Widget _buildAgreementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffEDE7F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffD1C4E9),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.gavel_rounded,
            color: Color(0xff5E35B1),
            size: 20,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "By using the app, you agree to our Privacy Policy and Terms of Use.",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff4527A0),
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
