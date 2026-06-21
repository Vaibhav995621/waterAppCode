import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/profile_model/profile_model.dart';

class ProfileController extends GetxController {
  late TabController tabController;

  Rx<File?> selectedImage = Rx<File?>(null);

  final ImagePicker picker = ImagePicker();
  final AuthRepository _repo = AuthRepository();

  var isLoading = false.obs;

  /// Profile data
  Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);

  String get userName =>
      profile.value?.data.fullname ?? "No Name";

  String get phone =>
      profile.value?.data.mobile ?? "";

  String get image =>
      profile.value?.data.photo ?? "";

  @override
  void onInit() {
    // getProfile();
    super.onInit();

  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
      updateProfile();
    }
  }

  void showImagePicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getProfile() async {
    selectedImage.value = null;
    try {
      isLoading.value = true;
      var custId = AppSession.userId;
      final user =
      await _repo.getUserProfile(custId);

      if (user.statusCode == '201') {
        AppSnackbar.error(user.message);
        return false;
      }

      if (user.statusCode == '200') {
        profile.value = user;
        AppSession.saveUser(
          userId: AppSession.userId,
          token: '',
          image: user.data.photo,
          name: user.data.fullname ?? '',
          role: user.data.role,
          planType: user.data.plandetail.id
        );
      }
      update();

      return true;
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }



  Future<bool> updateProfile() async {
    try {
      isLoading.value = true;

      var custId = AppSession.userId;

      final user = await _repo.updateProfile(
        custId: custId,
        image: selectedImage.value,
      );

      if (user.statusCode == '201') {
        AppSnackbar.error(user.message);
        return false;
      }

      if (user.statusCode == '200') {
        profile.value = user;

        AppSnackbar.success(
          user.message ?? "Profile updated",
        );
      }

      return true;
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    print("Logout");
    AppSession.saveUser(
        userId: '',
        token: '',
        image: '',
        name:  '',
        role: -1,
        planType: -1,
    );

    Get.offAllNamed(AppRoutes. login);

  }
}