import 'package:get/get.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/delivery_daily_data_model/delivery_daily_data_model.dart';

class DailyEarnController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  RxBool isLoading = false.obs;
  RxList<DailyEarningItem> dailyList = <DailyEarningItem>[].obs;

  /// Computed total online/admin to delivery earnings
  num get totalAdminToDelivery =>
      dailyList.fold<num>(0, (sum, item) => sum + item.totalAmountAdminToDelivery);

  /// Computed total offline cash/delivery to admin
  num get totalDeliveryToAdmin =>
      dailyList.fold<num>(0, (sum, item) => sum + item.totalAmountDeliveryToAdmin);

  /// Net balance (Admin to Delivery - Delivery to Admin)
  num get netBalance => totalAdminToDelivery - totalDeliveryToAdmin;

  /// Absolute net difference across all days
  num get totalNetSettlementAmount =>
      (totalDeliveryToAdmin - totalAdminToDelivery).abs();

  /// Total settlement direction: 'delivery_to_admin' | 'admin_to_delivery' | 'settled'
  String get totalSettlementDirection {
    if (totalDeliveryToAdmin > totalAdminToDelivery) {
      return 'delivery_to_admin';
    } else if (totalAdminToDelivery > totalDeliveryToAdmin) {
      return 'admin_to_delivery';
    }
    return 'settled';
  }

  /// User friendly total settlement label
  String get totalSettlementLabel {
    if (totalDeliveryToAdmin > totalAdminToDelivery) {
      return "Delivery Partner gives to Admin";
    } else if (totalAdminToDelivery > totalDeliveryToAdmin) {
      return "Admin gives to Delivery Partner";
    }
    return "All Settled";
  }

  @override
  void onInit() {
    super.onInit();
    fetchDailyEarnings();
  }

  Future<void> fetchDailyEarnings() async {
    try {
      isLoading.value = true;
      final response = await _repo.getDeliveryDailyData(
        deliveryPartnerId:
            AppSession.userId.isNotEmpty ? AppSession.userId : "1",
      );

      if (response.statusCode == '200') {
        final sortedList = List<DailyEarningItem>.from(response.data);
        sortedList.sort((a, b) {
          final dateA = a.parsedDate;
          final dateB = b.parsedDate;
          if (dateA != null && dateB != null) {
            return dateB.compareTo(dateA);
          }
          if (dateA != null) return -1;
          if (dateB != null) return 1;
          return b.srNo.compareTo(a.srNo);
        });
        dailyList.assignAll(sortedList);
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
