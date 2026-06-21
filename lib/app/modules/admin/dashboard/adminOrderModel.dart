import 'dart:ui';

class OrderModel {
  final String orderId;
  final String customerName;
  final String status;
  final Color statusColor;
  final Color bgColor;
  String? date;
  Color? statusBg;



  OrderModel({
    required this.orderId,
    required this.customerName,
    required this.status,
    required this.statusColor,
    required this.bgColor,
    this.statusBg,
    this.date

  });
}