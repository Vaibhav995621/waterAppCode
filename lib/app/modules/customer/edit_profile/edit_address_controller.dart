import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:zourney/app/app_session/app_session.dart';
import 'package:zourney/app/models/address_model/addresss_model.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/profile_model/profile_model.dart';

class EditAddressController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final AuthRepository _repo = AuthRepository();

  final addressController = TextEditingController();
  final houseNoController = TextEditingController();
  final flatNoController = TextEditingController();
  final streetNameController = TextEditingController();
  final societyNameController = TextEditingController();
  final galiNumberController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();

  RxBool isLoading = false.obs;

  late AddressData? addressData;

  @override
  void onInit() {
    super.onInit();
    addressData = Get.arguments as AddressData?;
     if(addressData != null){
       setData();
    }
  }

  void setData() {
    /// adjust field names according to your model

    addressController.text =
        addressData?.fullAddress ?? "";

    houseNoController.text =
        addressData?.housenumber ?? "";

    flatNoController.text =
        addressData?.flatnumber ?? "";

    streetNameController.text =
        addressData?.galinumber ?? "";

    societyNameController.text =
        addressData?.societyname ?? "";

    galiNumberController.text =
        addressData?.galinumber ?? "";

    landmarkController.text =
        addressData?.landmark ?? "";

    cityController.text =
        addressData?.city ?? "";

    stateController.text =
        addressData?.state ?? "";

    pinCodeController.text =
        addressData?.pincode ?? "";
  }

  Future<void> addAddress() async {
    if (!formKey.currentState!.validate()) return;
    Map<String, dynamic> profileData = {
      "customerid": AppSession.userId,
      "fulladdress": addressController.text,
      "housenumber": houseNoController.text,
      "flatnumber": flatNoController.text,
      "societyname": societyNameController.text,
      "galinumber": galiNumberController.text,
      "landmark": landmarkController.text,
      "city": cityController.text,
      "state": stateController.text,
      "pincode": pinCodeController.text,
      "status": "active",
    };

    try {
      isLoading.value = true;

      final user = await _repo.addAddress(body: profileData);

      /// ✅ Handle API-level failure
      if (user.statusCode == '201') {
        AppSnackbar.error(user.message ?? 'Something went wrong');
      }
      /// ✅ Navigation
      if (user.statusCode == "200") {
        Get.back(result: true);
      } else {
      }
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    houseNoController.dispose();
    flatNoController.dispose();
    streetNameController.dispose();
    societyNameController.dispose();
    galiNumberController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();

    super.onClose();
  }



}