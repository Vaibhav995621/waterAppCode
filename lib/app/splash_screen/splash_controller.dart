import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../app_session/app_session.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startNavigationDelay();
  }

  void _startNavigationDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (AppSession.userId.isNotEmpty) {
        Get.offAllNamed(AppRoutes.mainNavigation);
      } else {
        Get.offAllNamed(AppRoutes.welcomeScreen);
      }
    });
  }
}
