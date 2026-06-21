import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgot_password_controller.dart';

class ForgotPasswordView
    extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      body: Stack(
        children: [

          /// TOP CIRCLE
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

          /// RIGHT CIRCLE
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [

                      InkWell(
                        borderRadius:
                        BorderRadius.circular(50),
                        onTap: () => Get.back(),

                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color:
                            Colors.white.withOpacity(.2),
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
                            "Forgot Password",
                            style: TextStyle(
                              color: Color(0xff1A2C56),
                              fontSize: 22,
                              fontWeight:
                              FontWeight.bold,
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
                    margin:
                    const EdgeInsets.only(top: 10),

                    decoration:
                    const BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                      BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),

                    child: SingleChildScrollView(
                      padding:
                      const EdgeInsets.all(25),

                      child: Column(
                        children: [

                          const SizedBox(
                              height: 30),

                          /// ICON
                          Container(
                            height: 120,
                            width: 120,

                            decoration:
                            BoxDecoration(
                              shape:
                              BoxShape.circle,

                              gradient:
                              LinearGradient(
                                colors: [
                                  Color(0xff4F8EF7),
                                  Color(0xff6C63FF),
                                ],
                              ),
                            ),

                            child: const Icon(
                              Icons.lock_reset,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),

                          const SizedBox(
                              height: 30),

                          const Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              Color(0xff1A2C56),
                            ),
                          ),

                          const SizedBox(
                              height: 10),

                          Text(
                            "Enter your registered mobile number to receive password reset instructions.",
                            textAlign:
                            TextAlign.center,
                            style: TextStyle(
                              color:
                              Colors.grey.shade600,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(
                              height: 35),

                          /// MOBILE FIELD
                          Container(
                            decoration:
                            BoxDecoration(
                              color: const Color(
                                  0xffF7F9FC),

                              borderRadius:
                              BorderRadius
                                  .circular(
                                  20),

                              border: Border.all(
                                color: Colors
                                    .grey.shade200,
                              ),
                            ),

                            child: TextField(
                              controller: controller
                                  .mobileController,

                              keyboardType:
                              TextInputType
                                  .phone,

                              decoration:
                              const InputDecoration(
                                border:
                                InputBorder.none,

                                prefixIcon:
                                Icon(
                                  Icons.phone,
                                  color: Color(
                                      0xff6C63FF),
                                ),

                                hintText:
                                "Enter mobile number",
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 40),

                          /// BUTTON
                          Container(
                            decoration:
                            BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  24),

                              gradient:
                              const LinearGradient(
                                colors: [
                                  Color(
                                      0xff4F8EF7),
                                  Color(
                                      0xff6C63FF),
                                ],
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color:
                                  const Color(
                                    0xff6C63FF,
                                  ).withOpacity(
                                      .35),

                                  blurRadius:
                                  20,

                                  offset:
                                  const Offset(
                                    0,
                                    8,
                                  ),
                                ),
                              ],
                            ),

                            child: Material(
                              color: Colors
                                  .transparent,

                              child: InkWell(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    24),

                                onTap: controller
                                    .sendOtp,

                                child:
                                Container(
                                  height: 60,

                                  alignment:
                                  Alignment
                                      .center,

                                  child:
                                  const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,

                                    children: [
                                      Icon(
                                        Icons
                                            .send_rounded,
                                        color: Colors
                                            .white,
                                      ),

                                      SizedBox(
                                          width:
                                          10),

                                      Text(
                                        "Send OTP",
                                        style:
                                        TextStyle(
                                          color:
                                          Colors.white,

                                          fontSize:
                                          18,

                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 20),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}