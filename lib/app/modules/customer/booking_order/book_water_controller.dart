import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/bottel_model/botle_model.dart';

class BookWaterController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final RxList<BottleData> bottleList = <BottleData>[].obs;
  late BottleData bottle;
  final RxBool isLoading = false.obs;
  final selectedBottle = 0.obs;
  final quantity = 1.obs;
  final selectedDate = DateTime.now().obs;
  final selectedTime = "10:00 AM - 12:00 PM".obs;



  int get price {
    if (bottleList.isEmpty) return 0;
     bottle = bottleList.firstWhereOrNull(
          (e) => e.id == selectedBottle.value,
    )!;
    return int.tryParse(
      bottle.discountprice ?? "0",
    ) ??
        0;
  }

  int get total => price * quantity.value;

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
          response.message ?? "Something went wrong",
        );
        return false;
      }
      /// SUCCESS
      if (response.statusCode == "200") {
        bottleList.assignAll(response.data);
        /// DEFAULT SELECT FIRST BOTTLE
        if (bottleList.isNotEmpty) {
          selectedBottle.value =
              bottleList.first.id;
        }
        return true;
      }
      AppSnackbar.error(
        response.message ?? "Failed to load bottles",
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