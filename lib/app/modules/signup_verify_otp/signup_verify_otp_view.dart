import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_verify_otp_controller.dart';

class SignupVerifyOtpView extends GetView<SignupVerifyOtpController> {
  const SignupVerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: Stack(
        children: [
          /// TOP LEFT CIRCLE
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              height: 220,
              width: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff62B5F8),
              ),
            ),
          ),

          /// TOP RIGHT CIRCLE
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              height: 280,
              width: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6C63FF),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => Get.back(),
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Verification",
                            style: TextStyle(
                              color: Color(0xff1A2C56),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    child: Obx(() => IgnorePointer(
                      ignoring: controller.isLoading.value || controller.isResending.value,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),

                            /// Security Lock visual
                            Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff4F8EF7),
                                    Color(0xff6C63FF),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.security,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              "Verify OTP",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A2C56),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              controller.email.isNotEmpty
                                  ? "Enter the 4-digit code sent to your registered email: ${controller.email}"
                                  : "Enter the 4-digit code sent to your registered email",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// 4-Digit OTP Fields
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _otpBox(context, controller.otp1Controller, controller.otp1Focus, controller.otp2Focus, null),
                                _otpBox(context, controller.otp2Controller, controller.otp2Focus, controller.otp3Focus, controller.otp1Focus),
                                _otpBox(context, controller.otp3Controller, controller.otp3Focus, controller.otp4Focus, controller.otp2Focus),
                                _otpBox(context, controller.otp4Controller, controller.otp4Focus, null, controller.otp3Focus),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// Resend OTP Button
                            Obx(() {
                              final isResending = controller.isResending.value;
                              return Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: isResending ? null : () => controller.resendOtp(),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: isResending
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6C63FF)),
                                          ),
                                        )
                                      : const Text(
                                          "Resend OTP",
                                          style: TextStyle(
                                            color: Color(0xff6C63FF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                ),
                              );
                            }),

                            const SizedBox(height: 35),

                            /// Verify & Proceed Button
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff4F8EF7),
                                    Color(0xff6C63FF),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff6C63FF).withOpacity(.35),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () {
                                    if (!controller.isLoading.value) {
                                      controller.verifyOtp();
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    child: Obx(() {
                                      if (controller.isLoading.value) {
                                        return const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        );
                                      }
                                      return const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.verified_user_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Verify & Proceed",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ))),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _otpBox(
    BuildContext context,
    TextEditingController textController,
    FocusNode currentFocus,
    FocusNode? nextFocus,
    FocusNode? previousFocus,
  ) {
    return Container(
      height: 55,
      width: 50,
      decoration: BoxDecoration(
        color: const Color(0xffF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: TextField(
        controller: textController,
        focusNode: currentFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff1A2C56)),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: "",
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (nextFocus != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (currentFocus.hasFocus) {
                  FocusScope.of(context).requestFocus(nextFocus);
                }
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                currentFocus.unfocus();
              });
            }
          } else {
            if (previousFocus != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (currentFocus.hasFocus) {
                  FocusScope.of(context).requestFocus(previousFocus);
                }
              });
            }
          }
        },
      ),
    );
  }
}
