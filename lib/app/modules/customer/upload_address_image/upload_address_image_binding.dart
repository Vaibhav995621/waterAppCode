import 'package:get/get.dart';
import 'upload_address_image_controller.dart';

class UploadAddressImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadAddressImageController>(
      () => UploadAddressImageController(),
    );
  }
}
