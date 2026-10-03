import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'help_support_controller.dart';

class HelpSupportView extends GetView<HelpSupportController> {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5FB),
      body: Column(
        children: [
          /// Top Header with back button & gradient
          _buildHeader(),

          /// Content Body
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              children: [
                /// Hero Contact Card
                _buildHeroBanner(),

                const SizedBox(height: 20),

                /// Section: Quick Contact Options
                const Text(
                  "Get in Touch",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1A2C56),
                  ),
                ),
                const SizedBox(height: 12),

                /// Phone Support Card
                _buildContactCard(
                  icon: Icons.phone_in_talk_rounded,
                  iconBgColor: const Color(0xffE8F5E9),
                  iconColor: const Color(0xff2E7D32),
                  title: "Phone Support",
                  subtitle: HelpSupportController.formattedPhone,
                  badgeText: "Tap to Call",
                  badgeColor: const Color(0xff2E7D32),
                  onTap: () => controller.callSupport(),
                  onCopy: () => controller.copyToClipboard(
                    HelpSupportController.supportPhone,
                    "Phone number",
                  ),
                ),

                const SizedBox(height: 12),

                /// WhatsApp Support Card
                _buildContactCard(
                  icon: Icons.chat_rounded,
                  iconBgColor: const Color(0xffE0F2F1),
                  iconColor: const Color(0xff00897B),
                  title: "WhatsApp Chat",
                  subtitle: "Chat with support directly",
                  badgeText: "Fast Reply",
                  badgeColor: const Color(0xff00897B),
                  onTap: () => controller.openWhatsApp(),
                  onCopy: () => controller.copyToClipboard(
                    HelpSupportController.supportPhone,
                    "WhatsApp number",
                  ),
                ),

                const SizedBox(height: 12),

                /// Email Support Card
                _buildContactCard(
                  icon: Icons.mail_outline_rounded,
                  iconBgColor: const Color(0xffEDE7F6),
                  iconColor: const Color(0xff5E35B1),
                  title: "Email Support",
                  subtitle: HelpSupportController.supportEmail,
                  badgeText: "Send Mail",
                  badgeColor: const Color(0xff5E35B1),
                  onTap: () => controller.sendEmail(),
                  onCopy: () => controller.copyToClipboard(
                    HelpSupportController.supportEmail,
                    "Email address",
                  ),
                ),

                const SizedBox(height: 20),

                /// Operational Hours Card
                _buildHoursCard(),

                const SizedBox(height: 24),

                /// Section: Frequently Asked Questions
                const Text(
                  "Frequently Asked Questions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1A2C56),
                  ),
                ),
                const SizedBox(height: 12),

                /// FAQ Items
                ...List.generate(
                  controller.faqs.length,
                  (index) => _buildFaqItem(index),
                ),

                const SizedBox(height: 30),
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
                  "Help & Support",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "We're here to assist you anytime",
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
      padding: const EdgeInsets.all(20),
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
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How can we help you?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Reach out to us via call, WhatsApp, or email for prompt support.",
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

  /// Individual Contact Method Card
  Widget _buildContactCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required VoidCallback onTap,
    required VoidCallback onCopy,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1A2C56),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: Colors.grey.shade500,
                  ),
                  tooltip: "Copy",
                  onPressed: onCopy,
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Working Hours & Guarantee Card
  Widget _buildHoursCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffFFE082),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xffFFA000),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_filled_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Support Working Hours",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff5D4037),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Monday – Sunday: 6:00 AM – 10:00 PM",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff795548),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Interactive FAQ Item
  Widget _buildFaqItem(int index) {
    final faq = controller.faqs[index];
    return Obx(() {
      final isExpanded = controller.expandedFaqIndex.value == index;
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExpanded
                ? const Color(0xff5E35B1).withOpacity(0.35)
                : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: () => controller.toggleFaq(index),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          faq["question"] ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isExpanded ? FontWeight.bold : FontWeight.w600,
                            color: isExpanded
                                ? const Color(0xff5E35B1)
                                : const Color(0xff1A2C56),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: isExpanded ? 0.5 : 0.0,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isExpanded
                              ? const Color(0xff5E35B1)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: Color(0xffF0F0F0)),
                    const SizedBox(height: 10),
                    Text(
                      faq["answer"] ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
