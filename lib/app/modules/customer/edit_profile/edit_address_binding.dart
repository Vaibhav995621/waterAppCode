/// binding.dart

import 'package:get/get.dart';
import 'edit_address_controller.dart';

class EditAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditAddressController>(
          () => EditAddressController(),
    );
  }
}