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

  /// Parsed DateTime object for sorting and date formatting
  DateTime? get parsedDate {
    if (date.isEmpty) return null;
    final iso = DateTime.tryParse(date);
    if (iso != null) return iso;
    for (final pattern in [
      'dd-MM-yyyy',
      'dd/MM/yyyy',
      'yyyy-MM-dd',
      'yyyy/MM/dd',
      'MM-dd-yyyy',
      'MM/dd/yyyy',
      'dd MMM yyyy',
      'd MMM yyyy',
    ]) {
      try {
        return DateFormat(pattern).parseStrict(date);
      } catch (_) {}
    }
    return null;
  }

  /// Formatted date e.g. "06 Sep 2026"
  String get formattedDate {
    if (date.isEmpty) return "N/A";
    final parsed = parsedDate;
    if (parsed != null) {
      return DateFormat('dd MMM yyyy').format(parsed);
    }
    return date;
  }

  /// Formatted day name e.g. "Sunday"
  String get dayName {
    if (date.isEmpty) return "";
    final parsed = parsedDate;
    if (parsed != null) {
      return DateFormat('EEEE').format(parsed);
    }
    return "";
  }

  /// Net for the day (Admin to Delivery - Delivery to Admin)
  num get netAmount => totalAmountAdminToDelivery - totalAmountDeliveryToAdmin;

  /// Absolute net difference to be settled
  num get netSettlementAmount =>
      (totalAmountDeliveryToAdmin - totalAmountAdminToDelivery).abs();

  /// Settlement direction: 'delivery_to_admin' | 'admin_to_delivery' | 'settled'
  String get settlementDirection {
    if (totalAmountDeliveryToAdmin > totalAmountAdminToDelivery) {
      return 'delivery_to_admin';
    } else if (totalAmountAdminToDelivery > totalAmountDeliveryToAdmin) {
      return 'admin_to_delivery';
    }
    return 'settled';
  }

  /// Descriptive label of who gives to whom
  String get settlementLabel {
    if (totalAmountDeliveryToAdmin > totalAmountAdminToDelivery) {
      return "Delivery Partner gives to Admin";
    } else if (totalAmountAdminToDelivery > totalAmountDeliveryToAdmin) {
      return "Admin gives to Delivery Partner";
    }
    return "Settled";
  }

  /// Short tag label
  String get settlementShortLabel {
    if (totalAmountDeliveryToAdmin > totalAmountAdminToDelivery) {
      return "Delivery to Admin";
    } else if (totalAmountAdminToDelivery > totalAmountDeliveryToAdmin) {
      return "Admin to Delivery";
    }
    return "Settled";
  }
}
