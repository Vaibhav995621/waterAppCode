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
      statusCode: json['status_code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<Order>.from(
        json['data'].map((x) => Order.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}
