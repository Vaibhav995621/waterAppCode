import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'assign_delivery_boy_controller.dart';

class AssignDeliveryBoyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignDeliveryBoyController>(
          () => AssignDeliveryBoyController(),
    );
  }
}