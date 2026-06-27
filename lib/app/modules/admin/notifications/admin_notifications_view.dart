import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_notifications_controller.dart';

class AdminNotificationsView extends GetView<AdminNotificationsController> {
  const AdminNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: Stack(
        children: [
          // Background decorative shapes matching admin dashboard
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff62B5F8),
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
                // Top Custom Header
                _buildHeader(context),
                
                // Content container with curved top border
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Notifications list
                        Expanded(
                          child: Obx(() {
                            final list = controller.notifications;
                            if (list.isEmpty) {
                              return _buildEmptyState();
                            }
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 20,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final item = list[index];
                                return _buildNotificationItem(context, item);
                              },
                            );
                          }),
                        ),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.notifications.isEmpty) return const SizedBox.shrink();
            return PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 26,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onSelected: (value) {
                if (value == 'read_all') {
                  controller.markAllAsRead();
                  Get.snackbar(
                    'Success',
                    'All notifications marked as read',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xff6B67F6),
                    colorText: Colors.white,
                  );
                } else if (value == 'clear_all') {
                  controller.clearAll();
                  Get.snackbar(
                    'Cleared',
                    'All notifications cleared',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.grey.shade800,
                    colorText: Colors.white,
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'read_all',
                  child: Row(
                    children: const [
                      Icon(Icons.mark_email_read_outlined, size: 20, color: Color(0xff6B67F6)),
                      SizedBox(width: 8),
                      Text("Mark all as read"),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'clear_all',
                  child: Row(
                    children: const [
                      Icon(Icons.delete_sweep_outlined, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Clear all"),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, AdminNotification item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.red.shade700,
          size: 28,
        ),
      ),
      onDismissed: (direction) {
        controller.deleteNotification(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                controller.notifications.add(item);
                // Sort by ID to preserve mock order roughly
                controller.notifications.sort((a, b) => a.id.compareTo(b.id));
              },
            ),
          ),
        );
      },
      child: Obx(() {
        final isRead = item.isRead.value;
        return InkWell(
          onTap: () {
            controller.markAsRead(item.id);
            if (item.targetId != null) {
              // Optionally perform navigation (e.g. go to order details)
              Get.snackbar(
                item.title,
                "Navigating to details for ${item.targetId}",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isRead ? Colors.white : const Color(0xffF4F7FC).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRead ? Colors.grey.shade100 : const Color(0xff6B67F6).withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconBadge(item.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            item.timeAgo,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: isRead ? Colors.grey.shade600 : Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xff6B67F6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildIconBadge(NotificationType type) {
    IconData iconData;
    Color color;
    Color bgColor;

    switch (type) {
      case NotificationType.order:
        iconData = Icons.shopping_bag_outlined;
        color = const Color(0xff62B5F8);
        bgColor = const Color(0xff62B5F8).withOpacity(0.15);
        break;
      case NotificationType.alert:
        iconData = Icons.warning_amber_rounded;
        color = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.15);
        break;
      case NotificationType.delivery:
        iconData = Icons.local_shipping_outlined;
        color = Colors.green;
        bgColor = Colors.green.withOpacity(0.15);
        break;
      case NotificationType.payment:
        iconData = Icons.payment_outlined;
        color = Colors.teal;
        bgColor = Colors.teal.withOpacity(0.15);
        break;
      case NotificationType.feedback:
        iconData = Icons.star_outline_rounded;
        color = Colors.amber.shade800;
        bgColor = Colors.amber.withOpacity(0.15);
        break;
      case NotificationType.system:
        iconData = Icons.info_outline_rounded;
        color = Colors.grey.shade700;
        bgColor = Colors.grey.withOpacity(0.15);
        break;
    }

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xffF4F7FC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "All Caught Up!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You have no notifications in this category.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
