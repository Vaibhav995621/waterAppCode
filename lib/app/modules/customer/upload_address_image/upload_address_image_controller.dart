import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zourney/app/app_session/app_session.dart';
import 'package:zourney/app/models/address_model/addresss_model.dart';
import 'package:zourney/app/models/address_model/add_edit_address_model.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';

class UploadAddressImageController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  
  RxBool isLoading = false.obs;
  Rxn<File> selectedImage = Rxn<File>();
  dynamic addressData;
  String addressId = "";
  String? existingPhoto;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      addressData = Get.arguments;
      if (addressData is AddressData || addressData is AddEditAddressData) {
        addressId = addressData.id.toString();
        existingPhoto = addressData.photo ?? addressData.imagepath;
      } else {
        addressId = addressData.toString();
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackbar.error("Address data is missing");
        Get.back();
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      AppSnackbar.error("Failed to pick image: $e");
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage.value == null) {
      AppSnackbar.error("Please select an image first.");
      return;
    }

    try {
      isLoading.value = true;
      await _repo.uploadAddressPhoto(
        addressId: addressId,
        customerId: AppSession.userId,
        image: selectedImage.value!,
      );
      Get.back(result: true); // Return success so previous screen can refresh
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
    } finally {
      isLoading.value = false;
    }
  }
}
