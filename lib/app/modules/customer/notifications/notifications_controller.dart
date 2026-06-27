import 'package:get/get.dart';
import '../../../app_session/app_session.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/notification_model.dart';

class NotificationsController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  var isLoading = false.obs;
  var notifications = <NotificationData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final customerId = AppSession.userId;
      if (customerId.isEmpty) {
        return;
      }

      final response = await _repo.getNotifications(customerId: customerId);

      if (response.statusCode == '200') {
        notifications.assignAll(response.data);
      } else {
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Failed to load notifications",
        );
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }
}
