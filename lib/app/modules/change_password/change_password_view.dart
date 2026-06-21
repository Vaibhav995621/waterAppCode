import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      body: Stack(
        children: [
          /// TOP CIRCLES
          Positioned(
            top: -60,
            left: -60,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 180,
                width: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff62B5F8),
                ),

                child: Stack(
                  children: [
                    Positioned(
                      bottom: 30,
                      right: 60,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -120,
            right: -100,
            child: Container(
              height: 280,
              width: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6B67F6),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.all(20),

                  child: Row(
                    children: [

                      const Expanded(
                        child: Center(
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                              color: Color(0xff1A2C56), // theme dark navy
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),

                    decoration: const BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                    ),

                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          Container(
                            height: 100,
                            width: 100,

                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff4F8EF7), Color(0xff6C63FF)],
                              ),

                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.lock,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 35),

                          _field(
                            "Current Password",
                            controller.oldPasswordController,

                            controller.hideOld,

                            controller.toggleOld,
                          ),

                          const SizedBox(height: 18),

                          _field(
                            "New Password",
                            controller.newPasswordController,

                            controller.hideNew,

                            controller.toggleNew,
                          ),

                          const SizedBox(height: 18),

                          _field(
                            "Confirm Password",
                            controller.confirmPasswordController,

                            controller.hideConfirm,

                            controller.toggleConfirm,
                          ),

                          const SizedBox(height: 35),

                          SizedBox(
                            width: double.infinity,
                            height: 58,

                            child: ElevatedButton(
                              onPressed: controller.changePassword,

                              style: ElevatedButton.styleFrom(
                                elevation: 0,

                                backgroundColor: Colors.transparent,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),

                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),

                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff4F8EF7),
                                      Color(0xff6C63FF),
                                    ],
                                  ),
                                ),

                                child: const Center(
                                  child: Text(
                                    "Update Password",

                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String hint,
    TextEditingController controllerText,
    RxBool hidden,
    VoidCallback onTap,
  ) {
    return Obx(
      () => TextField(
        controller: controllerText,

        obscureText: hidden.value,

        decoration: InputDecoration(
          hintText: hint,

          filled: true,
          fillColor: const Color(0xffF7F9FC),

          prefixIcon: const Icon(Icons.lock_outline),

          suffixIcon: IconButton(
            onPressed: onTap,

            icon: Icon(hidden.value ? Icons.visibility_off : Icons.visibility),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
