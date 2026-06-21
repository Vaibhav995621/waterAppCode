import 'package:get/get.dart';
import 'package:zourney/app/modules/customer/select_address/select_address_controller.dart';

class SelectAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectAddressController>(() => SelectAddressController());
  }
}