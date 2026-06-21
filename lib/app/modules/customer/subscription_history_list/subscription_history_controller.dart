import 'package:get/get.dart';
import 'package:zourney/app/models/subcription_model/subscription_history_model.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';

class SubscriptionHistoryController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  var isLoading = true.obs;
  var subscriptionList = <SubscriptionData>[].obs;

  @override
  void onInit() {
    fetchSubscriptions();
    super.onInit();
  }



  Future<bool> fetchSubscriptions() async {
    try {
      isLoading(true);

      final response =
      await _repo.getSubscriptionHistoryList();
      isLoading.value = false;

      if (response.statusCode == "201") {
        AppSnackbar.error(response.message ?? "Something went wrong");
        return false;
      }

      if (response.statusCode == "200") {
        isLoading.value = false;
        if (response.data != null) {
          subscriptionList.assignAll(response.data!);
        }
      }

      return true;

    } catch (e) {
      isLoading.value = false;

      AppSnackbar.error(
        e.toString().replaceAll(
          "Exception: ",
          "",
        ),
      );
      return false;

    } finally {
      isLoading.value = false;
    }
  }

}


