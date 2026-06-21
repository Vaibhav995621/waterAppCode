import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/bottel_model/botle_model.dart';

class OrderDetailsController extends GetxController {
  final orderData = Get.arguments;

  String get orderNumber =>
      orderData?.ordernumber ?? 'N/A';

  String get customerName =>
      orderData?.customername ?? 'N/A';

  String get customerMobile =>
      orderData?.customermobile ?? 'N/A';

  String get houseNumber =>
      orderData?.housenumber ?? 'N/A';

  String get flatNumber =>
      orderData?.flatnumber ?? 'N/A';

  String get societyName =>
      orderData?.societyname ?? 'N/A';

  String get galiNumber =>
      orderData?.galinumber ?? 'N/A';

  String get landmark =>
      orderData?.landmark ?? 'N/A';

  String get city =>
      orderData?.city ?? 'N/A';

  String get state =>
      orderData?.state ?? 'N/A';

  String get pincode =>
      orderData?.pincode ?? 'N/A ';

  String get deliveryDate {
    final date = orderData?.deliverydate;

    if (date is DateTime) {
      return DateFormat('dd MMM yyyy').format(date);
    }

    return date?.toString() ?? 'N/A';
  }

  String get deliveryTime =>
      orderData?.deliverytime?.toString() ?? 'N/A';

  String get price =>
      orderData?.discountprice?.toString() ?? 'N/A';

  String get quantity =>
      orderData?.quantity?.toString() ?? 'N/A     ';

  String get totalAmount =>
      ((double.tryParse(price) ?? 0) *
          (int.tryParse(quantity) ?? 1))
          .toStringAsFixed(2);


}