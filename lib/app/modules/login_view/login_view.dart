import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/modules/login_view/login_controller.dart';
import 'package:zourney/routes/app_routes.dart';

import '../../../utlis/progress_hud/app_progress_hud.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProgressHUD(
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FC),
        body: Stack(
          children: [
      
            /// Top left circle
            Positioned(
              top: -90,
              left: -90,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF62A9E8),
                ),
              ),
            ),
      
            /// Top right circle
            Positioned(
              top: -100,
              right: -120,
              child: Container(
                width: 320,
                height: 320,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6A6CF6),
                ),
              ),
            ),
      
            /// Bottom curved background
            Positioned(
              bottom: -40,
              left: -20,
              right: -20,
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  color: const Color(0xFF47A4F3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
      
                            const SizedBox(height: 200),
      
                            const Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold,
                                color:
                                Color(0xFF1A2C56),
                              ),
                            ),
      
                            const SizedBox(height: 6),
      
                            const Text(
                              "Login to Continue",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
      
                            const SizedBox(height: 30),
      
                            const Text(
                              "Mobile Number",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
      
                            const SizedBox(height: 8),
      
                            _buildTextField(
                              hint: "9876543210",
                              isPassword: false,
                              controller: controller.phoneController,
                              focusNode: controller.phoneFocus,
                            ),
      
                            const SizedBox(height: 20),
      
                            const Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
      
                            const SizedBox(height: 8),
      
                            /// only password rebuilds
                            Obx(
                                  () => _buildTextField(
                                hint: "••••••••",
                                isPassword: true,
                                controller: controller.passwordController,
                                focusNode: controller.passwordFocus,
                              ),
                            ),
      
                            const SizedBox(height: 10),
      
                            Align(
                              alignment:
                              Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.forgotPassword,
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(
                                        0xFF2F6BFF),
                                  ),
                                ),
                              ),
                            ),
      
                            const SizedBox(height: 10),
      
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.login(context);
                                },
                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFF6A6CF6),
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
      
                            const SizedBox(height: 20),
      
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style:
                                  TextStyle(fontSize: 13),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                        AppRoutes.register);
                                  },
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(
                                          0xFF2F6BFF),
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
      
      
                            const SizedBox(height: 300),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTextField({
    required String hint,
    required bool isPassword,
    TextEditingController? controller,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
  }) {
    final loginController =
    Get.find<LoginController>();

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,

      obscureText: isPassword
          ? loginController
          .isPasswordHidden.value
          : false,

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        filled: true,
        fillColor: Colors.white,

        suffixIcon: isPassword
            ? IconButton(
          onPressed: () {
            loginController
                .togglePassword();
          },
          icon: Icon(
            loginController
                .isPasswordHidden
                .value
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.grey,
          ),
        )
            : null,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color:
            Color(0xFFE5E7EB),
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
          borderSide:
          const BorderSide(
            color:
            Color(0xFF2F6BFF),
          ),
        ),
      ),
    );
  }
}