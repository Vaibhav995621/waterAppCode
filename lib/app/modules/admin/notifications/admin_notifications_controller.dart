import 'package:get/get.dart';

enum NotificationType {
  order,
  alert,
  delivery,
  payment,
  feedback,
  system,
}

class AdminNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String timeAgo;
  final RxBool isRead;
  final String? targetId; // e.g., order ID, delivery boy ID

  AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timeAgo,
    bool isRead = false,
    this.targetId,
  }) : isRead = isRead.obs;
}

class AdminNotificationsController extends GetxController {
  final RxList<AdminNotification> notifications = <AdminNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    notifications.assignAll([
      AdminNotification(
        id: '1',
        title: 'New Order Placed',
        message: 'Order #ORD-2098 has been placed by Amit Sharma. Please assign a delivery boy.',
        type: NotificationType.order,
        timeAgo: '2 mins ago',
        isRead: false,
        targetId: 'ORD-2098',
      ),
      AdminNotification(
        id: '2',
        title: 'Low Stock Alert',
        message: '20-Liter Water Bottles stock is below the minimum threshold. Only 12 bottles remaining.',
        type: NotificationType.alert,
        timeAgo: '15 mins ago',
        isRead: false,
      ),
      AdminNotification(
        id: '3',
        title: 'Delivery Boy Registered',
        message: 'Rohan Gupta has completed his registration as a delivery partner and is awaiting admin approval.',
        type: NotificationType.delivery,
        timeAgo: '1 hour ago',
        isRead: false,
      ),
      AdminNotification(
        id: '4',
        title: 'Order Cancelled',
        message: 'Order #ORD-2081 has been cancelled by customer Sunita Devi.',
        type: NotificationType.order,
        timeAgo: '2 hours ago',
        isRead: true,
        targetId: 'ORD-2081',
      ),
      AdminNotification(
        id: '5',
        title: 'Payment Confirmed',
        message: 'Payment of ₹450 received from customer Priya Rai for order #ORD-2065.',
        type: NotificationType.payment,
        timeAgo: '3 hours ago',
        isRead: true,
        targetId: 'ORD-2065',
      ),
      AdminNotification(
        id: '6',
        title: 'New Review Received',
        message: 'Customer Rajesh Kumar rated the delivery service 5 stars: "On time delivery and very polite driver."',
        type: NotificationType.feedback,
        timeAgo: '5 hours ago',
        isRead: true,
      ),
      AdminNotification(
        id: '7',
        title: 'System Update',
        message: 'Scheduled database maintenance will occur tonight from 12:00 AM to 02:00 AM. System might experience minor downtime.',
        type: NotificationType.system,
        timeAgo: '1 day ago',
        isRead: true,
      ),
    ]);
  }

  int get unreadCount => notifications.where((n) => !n.isRead.value).length;

  void markAsRead(String id) {
    final notification = notifications.firstWhereOrNull((n) => n.id == id);
    if (notification != null) {
      notification.isRead.value = true;
    }
  }

  void toggleReadStatus(String id) {
    final notification = notifications.firstWhereOrNull((n) => n.id == id);
    if (notification != null) {
      notification.isRead.value = !notification.isRead.value;
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead.value = true;
    }
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }

  void clearAll() {
    notifications.clear();
  }
}
