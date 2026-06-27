import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifications_controller.dart';
import '../../../models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: Stack(
        children: [
          // Background decorative circles
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
                  color: Color(0xff62B5F8),
                ),
                child: Stack(
                  children: const [
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
            top: -120,
            right: -100,
            child: Container(
              height: 280,
              width: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6B67F6),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Notifications",
                            style: TextStyle(
                              color: Color(0xff1A2C56),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),

                // Content Panel
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                    ),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff6B67F6),
                          ),
                        );
                      }

                      if (controller.notifications.isEmpty) {
                        return _buildEmptyState();
                      }

                      return RefreshIndicator(
                        color: const Color(0xff6B67F6),
                        onRefresh: () => controller.fetchNotifications(),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          itemCount: controller.notifications.length,
                          itemBuilder: (context, index) {
                            final notification = controller.notifications[index];
                            return _buildNotificationCard(notification);
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xffF4F7FC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 70,
                color: Color(0xff6B67F6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Notifications Yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff1A2C56),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "We'll notify you when something important happens regarding your orders or subscription.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationData notification) {
    IconData getIcon(String title) {
      final t = title.toLowerCase();
      if (t.contains("placed") || t.contains("order")) {
        return Icons.shopping_bag_outlined;
      } else if (t.contains("delivery") || t.contains("partner") || t.contains("assign")) {
        return Icons.local_shipping_outlined;
      }
      return Icons.notifications_none_outlined;
    }

    Color getIconBgColor(String title) {
      final t = title.toLowerCase();
      if (t.contains("placed") || t.contains("order")) {
        return const Color(0xffEAF6FF);
      } else if (t.contains("delivery") || t.contains("partner") || t.contains("assign")) {
        return const Color(0xffE8F5E9);
      }
      return const Color(0xffEDE7F6);
    }

    Color getIconColor(String title) {
      final t = title.toLowerCase();
      if (t.contains("placed") || t.contains("order")) {
        return const Color(0xff2196F3);
      } else if (t.contains("delivery") || t.contains("partner") || t.contains("assign")) {
        return const Color(0xff4CAF50);
      }
      return const Color(0xff673AB7);
    }

    String formatDateTime(String dateStr) {
      try {
        final dateTime = DateTime.parse(dateStr);
        return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
      } catch (_) {
        return dateStr;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0a000000),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xffF4F7FC),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: getIconBgColor(notification.title),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getIcon(notification.title),
              color: getIconColor(notification.title),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Message & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1A2C56),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff555555),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  formatDateTime(notification.cdate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
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
}
