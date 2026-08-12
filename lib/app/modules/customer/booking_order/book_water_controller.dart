import 'package:get/get.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/bottel_model/botle_model.dart';
import '../select_address/select_address_controller.dart';

class BookWaterController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final SelectAddressController addressController =
      Get.put(SelectAddressController());

  final RxList<BottleData> bottleList = <BottleData>[].obs;
  late BottleData bottle;
  final RxBool isLoading = false.obs;
  final selectedBottle = 0.obs;
  final quantity = 1.obs;
  final selectedDate = DateTime.now().obs;
  final selectedTime = "6:00 AM - 10:00 AM".obs;

  /// Fast Delivery toggle
  final RxBool fastDelivery = false.obs;

  void toggleFastDelivery() => fastDelivery.value = !fastDelivery.value;

  /// Floor charge per floor from selected bottle (BottleModel)
  int get floorCharges {
    if (bottleList.isEmpty) return 0;
    final b = bottleList.firstWhereOrNull(
      (e) => e.id == selectedBottle.value,
    );
    return b?.floorChanges ?? 0;
  }

  /// Floor number from selected address (AddressData)
  int get floor {
    final selectedAddr = addressController.selectedAddress.value;
    return selectedAddr?.floornumber ?? 0;
  }

  /// Returns true if lift is available for the selected address (isLiftAvailable == 1)
  bool get isLiftAvailable {
    final selectedAddr = addressController.selectedAddress.value;
    return (selectedAddr?.isLiftAvailable ?? 0) == 1;
  }

  int get price {
    if (bottleList.isEmpty) return 0;
    bottle = bottleList.firstWhereOrNull(
      (e) => e.id == selectedBottle.value,
    )!;
    return int.tryParse(bottle.discountprice) ?? 0;
  }

  int get bottleSubtotal => price * quantity.value;

  int get floorTotal {
    if (isLiftAvailable) {
      return 0;
    }
    // Multiply floor charges by quantity to reflect per-bottle floor fees
    return floor * floorCharges * quantity.value;
  }

  /// Quick delivery charge from selected bottle
  int get quickDeliveryCharges {
    if (bottleList.isEmpty) return 0;
    final b = bottleList.firstWhereOrNull(
      (e) => e.id == selectedBottle.value,
    );
    return b?.quickDeliveryCharges ?? 0;
  }

  BottleData? get currentBottle {
    if (bottleList.isEmpty) return null;
    return bottleList.firstWhereOrNull((e) => e.id == selectedBottle.value);
  }

  int get quickDeliveryTotal {
    if (!fastDelivery.value) return 0;
    return quickDeliveryCharges;
  }

  int get total => bottleSubtotal + floorTotal + quickDeliveryTotal;

  @override
  void onInit() {
    super.onInit();
    getBottleList();
  }

  void selectBottle(int type) {
    selectedBottle.value = type;
  }

  void incrementQty() {
    quantity.value++;
  }

  void decrementQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setTime(String time) {
    selectedTime.value = time;
  }

  Future<bool> getBottleList() async {
    try {
      isLoading.value = true;
      final response = await _repo.getBottleList();
      /// ERROR
      if (response.statusCode == "201") {
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Something went wrong",
        );
        return false;
      }
      /// SUCCESS
      if (response.statusCode == "200") {
        bottleList.assignAll(response.data);
        /// DEFAULT SELECT FIRST BOTTLE
        if (bottleList.isNotEmpty) {
          selectedBottle.value = bottleList.first.id;
        }
        return true;
      }
      AppSnackbar.error(
        response.message.isNotEmpty ? response.message : "Failed to load bottles",
      );
      return false;
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}