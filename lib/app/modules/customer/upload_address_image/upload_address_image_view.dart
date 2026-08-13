import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'upload_address_image_controller.dart';

class UploadAddressImageView extends GetView<UploadAddressImageController> {
  const UploadAddressImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xff1A2C56)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Upload Address Image",
          style: TextStyle(
            color: Color(0xff1A2C56),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: const Color(0xffF4F4F4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.uploadImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xff6C63FF).withOpacity(0.4),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Upload Image",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: TextButton(
                  onPressed: () => Get.back(result: true), // Skip returns true to trigger refresh if needed
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Skip for now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                const Text(
                  "Add a photo of your house or building to help the delivery boy find your address easily.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    final selectedImage = controller.selectedImage.value;
                    final existingPhoto = controller.existingPhoto;
                    final hasExistingPhoto = existingPhoto != null && existingPhoto.isNotEmpty;

                    return Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: selectedImage != null
                            ? Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              )
                            : hasExistingPhoto
                                ? Image.network(
                                    existingPhoto,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.home_work_rounded,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.add_a_photo_rounded, size: 48, color: Color(0xff6C63FF)),
                                      SizedBox(height: 8),
                                      Text(
                                        "Tap to Upload",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
