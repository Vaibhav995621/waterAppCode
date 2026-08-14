import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final GlobalKey boundaryKey = GlobalKey();

  var isLoading = false.obs;

  /// Profile data
  Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);

  String get userName => profile.value?.data.fullname ?? "No Name";

  String get phone => profile.value?.data.mobile ?? "";

  String get image => profile.value?.data.photo ?? "";

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      showImagePreviewDialog(File(image.path));
    }
  }

  void showImagePicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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

  void showImagePreviewDialog(File imageFile) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Adjust & Preview Picture",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff6B67F6),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                children: [
                  RepaintBoundary(
                    key: boundaryKey,
                    child: Container(
                      width: 180,
                      height: 180,
                      color: Colors.black,
                      child: ClipRect(
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 5.0,
                          boundaryMargin: const EdgeInsets.all(90),
                          child: Image.file(imageFile, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    child: CustomPaint(
                      size: const Size(180, 180),
                      painter: CropOverlayPainter(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Drag to pan • Pinch to zoom",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Do you want to set this image as your profile picture?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6B67F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final croppedFile = await _cropImage();
                    Get.back();
                    if (croppedFile != null) {
                      selectedImage.value = croppedFile;
                      await updateProfile();
                    } else {
                      AppSnackbar.error("Failed to process image adjustment");
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<File?> _cropImage() async {
    try {
      final boundary =
          boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final rawImage = await boundary.toImage(pixelRatio: 3.0);
      final int width = rawImage.width;
      final int height = rawImage.height;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final path = Path()
        ..addOval(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
      canvas.clipPath(path);

      canvas.drawImage(rawImage, Offset.zero, Paint());

      final picture = recorder.endRecording();
      final circularImage = await picture.toImage(width, height);

      final byteData = await circularImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return null;
      final pngBytes = byteData.buffer.asUint8List();

      final tempDir = Directory.systemTemp;
      final file = File(
        '${tempDir.path}/profile_crop_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);
      return file;
    } catch (e) {
      print("Error cropping image: $e");
      return null;
    }
  }

  Future<bool> getProfile() async {
    selectedImage.value = null;
    try {
      isLoading.value = true;
      var custId = AppSession.userId;
      final user = await _repo.getUserProfile(custId);

      if (user.statusCode == '201') {
        AppSnackbar.error(user.message);
        return false;
      }

      if (user.statusCode == '200') {
        profile.value = user;
        AppSession.saveUser(
          userId: AppSession.userId,
          token: AppSession.fcmToken,
          image: user.data.photo,
          name: user.data.fullname ?? '',
          role: user.data.role,
          planType: user.data.plandetail.id,
          usertype: user.data.usertype,
          mobileNo: user.data.mobile
        );
      }
      update();

      return true;
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
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
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();
        await getProfile();

        AppSnackbar.success(user.message ?? "Profile updated");
      }

      return true;
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfileName(String newName) async {
    try {
      isLoading.value = true;
      var custId = AppSession.userId;

      final user = await _repo.updateCustomerProfileName(
        custId: custId,
        fullName: newName,
      );

      if (user.statusCode == '201') {
        AppSnackbar.error(user.message);
        return false;
      }

      if (user.statusCode == '200') {
        // Refresh the profile details to make sure everything is fully populated
        await getProfile();
        AppSnackbar.success(user.message ?? "Profile updated successfully");
      }

      return true;
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void logout() {
    print("Logout");
    AppSession.saveUser(
      userId: '',
      token: '',
      image: '',
      name: '',
      role: -1,
      planType: -1,
      usertype: -1,
      mobileNo: "",
    );

    Get.offAllNamed(AppRoutes.login);
  }
}

class CropOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Outer rectangle path covering the preview container
    final outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Inner circle cutout in the center
    final innerPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
      );

    // Combine outer and inner path to create transparent circle cutout overlay
    final path = Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(path, paint);

    // Circle border outline showing the crop boundary
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
