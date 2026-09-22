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

  /// Net balance
  num get netBalance => totalAdminToDelivery - totalDeliveryToAdmin;

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
