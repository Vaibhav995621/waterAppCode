import 'package:get/get.dart';
import 'package:zourney/app/app_session/app_session.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/address_model/addresss_model.dart';

class AddressController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  /// SELECTED CARD INDEX
  RxInt selectedIndex = 0.obs;
  RxList<AddressData> addressList = <AddressData>[].obs;
 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAddressList();
  }
  void refreshAddress() async {
    await getAddressList();
    addressList.refresh();
  }


  /// SELECT ADDRESS
  void selectAddress(int index) {
    setAsDefaultAddress(index);
  }

  /// DELETE ADDRESS
  Future<void> deleteAddress(int index) async {
    try {
      final id = addressList[index].id;

      final data = await _repo.deleteAddress(
        customerId: AppSession.userId.toString(),
        addressId: id.toString(),
      );

      if (data.statusCode == "200") {
        addressList.removeWhere(
              (e) => e.id == id,
        );

        if (selectedIndex.value >= addressList.length) {
          selectedIndex.value =
          addressList.isEmpty
              ? 0
              : addressList.length - 1;
        }

        addressList.refresh();
        AppSnackbar.success(data.message);

      } else {
        AppSnackbar.error(data.message);
      }
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
    }
  }
  Future<bool> getAddressList() async {
    try {
      // isLoading.value = true;

      final data = await _repo.getAddressList( customerId: AppSession.userId);

      /// ❌ API Error
      if (data.statusCode == "201") {
        AppSnackbar.error(data.message);
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        addressList.assignAll(data.data);
      }

      return true;
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
      return false;
    } finally {
      //isLoading.value = false;
    }
  }

  Future<bool> setAsDefaultAddress(int index) async {
    final id = addressList[index].id;

    try {
      // isLoading.value = true;

      final data = await _repo.setAsDefaultAddress( customerId: AppSession.userId, addressId: id.toString());

      /// ❌ API Error
      if (data.statusCode == "201") {
        AppSnackbar.error(data.message);
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        for (var item in addressList) {
          item.isDefault = 0;
        }

        /// SET NEW DEFAULT
        addressList[index].isDefault = 1;

        /// UPDATE SELECTED INDEX
        selectedIndex.value = index;

        /// REFRESH RX LIST
        addressList.refresh();
      }

      return true;
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
      return false;
    } finally {
      //isLoading.value = false;
    }
  }




}