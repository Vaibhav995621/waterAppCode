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
  final floorNoController = TextEditingController();
  final sectorController = TextEditingController();

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

    floorNoController.text =
        addressData?.floornumber.toString() ?? "";

    sectorController.text =
        addressData?.sector ?? "";

    pinCodeController.text =
        addressData?.pincode ?? "";
  }

  Future<void> addAddress() async {
    if (!formKey.currentState!.validate()) return;
    Map<String, dynamic> profileData = {
      "customerid": AppSession.userId,
      "fulladdress": addressController.text,
      "floornumber": floorNoController.text,
      "housenumber": houseNoController.text,
      "flatnumber": flatNoController.text,
      "societyname": societyNameController.text,
      "galinumber": galiNumberController.text,
      "sector": sectorController.text,
      "landmark": landmarkController.text,
      "city": cityController.text,
      "state": stateController.text,
      "pincode": pinCodeController.text,
      "status": "active",
    };

    try {
      isLoading.value = true;

      final res = await _repo.addAddress(body: profileData);

      /// ✅ Handle API-level failure
      if (res.statusCode == '201') {
        AppSnackbar.error(res.message);
      }
      /// ✅ Navigation
      if (res.statusCode == "200") {
        Get.back(result: true);
      }
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress() async {
    if (!formKey.currentState!.validate()) return;
    
    Map<String, dynamic> updateData = {
      "id": addressData?.id.toString() ?? "",
      "userid": addressData?.userid.toString() ?? AppSession.userId,
      "fulladdress": addressController.text,
      "floornumber": floorNoController.text,
      "housenumber": houseNoController.text,
      "flatnumber": flatNoController.text,
      "societyname": societyNameController.text,
      "galinumber": galiNumberController.text,
      "sector": sectorController.text,
      "landmark": landmarkController.text,
      "city": cityController.text,
      "state": stateController.text,
      "pincode": pinCodeController.text,
      "status": "active",
      "is_default_address": addressData?.isDefault.toString() ?? "0",
    };

    try {
      isLoading.value = true;

      final res = await _repo.updateAddress(body: updateData);

      /// ✅ Handle API-level failure
      if (res.statusCode == '201') {
        AppSnackbar.error(res.message);
      }
      /// ✅ Navigation
      if (res.statusCode == "200") {
        Get.back(result: true);
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

    floorNoController.dispose();
    sectorController.dispose();
    super.onClose();
  }



}