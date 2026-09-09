import 'package:intl/intl.dart';

class DeliveryDailyDataResponse {
  final String statusCode;
  final String message;
  final List<DailyEarningItem> data;

  DeliveryDailyDataResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DeliveryDailyDataResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryDailyDataResponse(
      statusCode: json["status_code"]?.toString() ?? "",
      message: json["message"]?.toString() ?? "",
      data: json["data"] != null && json["data"] is List
          ? (json["data"] as List)
              .map((e) => DailyEarningItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class DailyEarningItem {
  final int srNo;
  final String date;
  final num totalAmountAdminToDelivery;
  final num totalAmountDeliveryToAdmin;

  DailyEarningItem({
    required this.srNo,
    required this.date,
    required this.totalAmountAdminToDelivery,
    required this.totalAmountDeliveryToAdmin,
  });

  factory DailyEarningItem.fromJson(Map<String, dynamic> json) {
    return DailyEarningItem(
      srNo: int.tryParse(json["sr_no"]?.toString() ?? "") ?? 0,
      date: json["date"]?.toString() ?? "",
      totalAmountAdminToDelivery:
          num.tryParse(json["totalamountadminttodelivery"]?.toString() ?? "") ?? 0,
      totalAmountDeliveryToAdmin:
          num.tryParse(json["totalamountdeliverytoadmin"]?.toString() ?? "") ?? 0,
    );
  }

  /// Formatted date e.g. "06 Sep 2026"
  String get formattedDate {
    if (date.isEmpty) return "N/A";
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return date;
    }
  }

  /// Formatted day name e.g. "Sunday"
  String get dayName {
    if (date.isEmpty) return "";
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('EEEE').format(parsed);
    } catch (_) {
      return "";
    }
  }

  /// Net for the day
  num get netAmount => totalAmountAdminToDelivery - totalAmountDeliveryToAdmin;
}
