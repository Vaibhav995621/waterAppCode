import 'package:zourney/app/models/Admin/admin_order_list/admin_order_model.dart';

class OrderList {
  String statusCode;
  String message;
  List<Order> data;

  OrderList({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) {
    return OrderList(
      statusCode: json['status_code']?.toString() ?? json['statusCode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is List
          ? List<Order>.from(
              (json['data'] as List)
                  .where((x) => x is Map<String, dynamic>)
                  .map((x) => Order.fromJson(x as Map<String, dynamic>)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}
