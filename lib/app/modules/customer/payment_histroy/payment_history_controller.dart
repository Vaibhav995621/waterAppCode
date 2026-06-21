import 'package:get/get.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/payment_history_model/payment_histroy_model.dart';

class PaymentHistoryController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  RxBool isLoading = false.obs;
  RxList<PaymentHistoryData> paymentList = <PaymentHistoryData>[].obs;

  @override
  void onInit() {
    super.onInit();
    paymentHistoryList();
  }


  Future<bool> paymentHistoryList() async {
    try {
      isLoading.value = true;

      final data = await _repo.getPaymentHistory();

      /// ❌ API Error
      if (data.statusCode == "201") {
        AppSnackbar.error(data.message);
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        paymentList.assignAll(data.data);
      }

      return true;
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

}