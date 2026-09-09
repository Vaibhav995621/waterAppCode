import 'package:get/get.dart';
import 'daily_earn_controller.dart';

class DailyEarnBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyEarnController>(() => DailyEarnController());
  }
}
