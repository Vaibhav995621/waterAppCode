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
      statusCode: json['status_code'] ?? '',
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
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
  List<Order> recentOrder;

  Data({
    required this.totalOrders,
    required this.totalActiveOrders,
    required this.totalCompletedOrders,
    required this.totalCancelledOrders,
    required this.totalEarning,
    required this.recentOrder,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      totalOrders: json['total_orders'] ?? 0,
      totalActiveOrders: json['total_active_orders'] ?? 0,
      totalCompletedOrders: json['total_completed_orders'] ?? 0,
      totalCancelledOrders: json['total_cancelled_orders'] ?? 0,
      totalEarning: json['total_earning'] ?? 0,
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
      'Recent_order': recentOrder.map((e) => e.toJson()).toList(),
    };
  }
}

