import '../admin_order_list/admin_order_model.dart';

class AdminDashboardModel {
  String statusCode;
  String message;
  Data data;

  AdminDashboardModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: Data.fromJson(json['data'] is Map<String, dynamic> ? json['data'] : {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  int totalOrders;
  int totalActiveOrders;
  int totalCompletedOrders;
  int totalCancelledOrders;
  int totalEarning;
  int onlineAdminToDelivery;
  int offlineDeliveryToAdmin;
  List<Order> recentOrder;

  Data({
    required this.totalOrders,
    required this.totalActiveOrders,
    required this.totalCompletedOrders,
    required this.totalCancelledOrders,
    required this.totalEarning,
    this.onlineAdminToDelivery = 0,
    this.offlineDeliveryToAdmin = 0,
    required this.recentOrder,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      totalOrders: int.tryParse(json['total_orders']?.toString() ?? '0') ?? 0,
      totalActiveOrders:
          int.tryParse(json['total_active_orders']?.toString() ?? '0') ?? 0,
      totalCompletedOrders:
          int.tryParse(json['total_completed_orders']?.toString() ?? '0') ?? 0,
      totalCancelledOrders:
          int.tryParse(json['total_cancelled_orders']?.toString() ?? '0') ?? 0,
      totalEarning: int.tryParse(json['total_earning']?.toString() ?? '0') ?? 0,
      onlineAdminToDelivery: int.tryParse(
              (json['online_admintodelivery'] ?? json['online_admin_to_delivery'] ?? '0').toString()) ??
          0,
      offlineDeliveryToAdmin: int.tryParse(
              (json['offline_deliverytoadmin'] ?? json['offline_delivery_to_admin'] ?? '0').toString()) ??
          0,
      recentOrder: (json['Recent_order'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'total_active_orders': totalActiveOrders,
      'total_completed_orders': totalCompletedOrders,
      'total_cancelled_orders': totalCancelledOrders,
      'total_earning': totalEarning,
      'online_admintodelivery': onlineAdminToDelivery,
      'offline_deliverytoadmin': offlineDeliveryToAdmin,
      'Recent_order': recentOrder.map((e) => e.toJson()).toList(),
    };
  }
}

