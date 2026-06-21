import 'package:get/get.dart';
import 'book_water_controller.dart';

class BookWaterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookWaterController());
  }
}