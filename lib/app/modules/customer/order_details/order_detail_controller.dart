import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_session/app_session.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class OrderDetailsController extends GetxController {
  final Order? orderData = Get.arguments is Order ? Get.arguments as Order : null;

  String get orderNumber {
    final val = orderData?.ordernumber;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get customerName {
    final name = orderData?.customerName;
    if (name != null && name.trim().isNotEmpty) {
      return name;
    }
    final fullName = orderData?.customerDetails.fullname;
    if (fullName != null && fullName.trim().isNotEmpty) {
      return fullName;
    }
    final sessionName = AppSession.name;
    if (sessionName.trim().isNotEmpty) {
      return sessionName;
    }
    return 'N/A';
  }

  String get customerMobile {
    final val = orderData?.customerDetails.mobile;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get houseNumber {
    final val = orderData?.customerDetails.address.housenumber;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get flatNumber {
    final val = orderData?.customerDetails.address.flatnumber;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get societyName {
    final val = orderData?.customerDetails.address.societyname;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get galiNumber {
    final val = orderData?.customerDetails.address.galinumber;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get landmark {
    final val = orderData?.customerDetails.address.landmark;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get city {
    final val = orderData?.customerDetails.address.city;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get state {
    final val = orderData?.customerDetails.address.state;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get pincode {
    final val = orderData?.customerDetails.address.pincode;
    if (val != null && val.trim().isNotEmpty) return val.trim();
    return 'N/A';
  }

  String get deliveryDate {
    final date = orderData?.deliverydate;
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  String get deliveryTime {
    final val = orderData?.deliverytime;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get price {
    final val = orderData?.price;
    if (val != null && val.trim().isNotEmpty) return val;
    return 'N/A';
  }

  String get quantity {
    final val = orderData?.quantity;
    if (val != null) return val.toString();
    return 'N/A';
  }

  String get totalAmount =>
      ((double.tryParse(price) ?? 0) *
          (int.tryParse(quantity) ?? 1))
          .toStringAsFixed(2);
}