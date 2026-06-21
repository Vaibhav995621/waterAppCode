import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'payment_success_controller.dart';

class PaymentSuccessView
    extends GetView<PaymentSuccessController> {

  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xffF5F8FD),

      body: Stack(
        children: [

          /// Top Left
          Positioned(
            top: -90,
            left: -50,
            child: Container(
              height: 220,
              width: 220,
              decoration: const BoxDecoration(
                color: Color(0xff57B4FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          /// Top Right
          Positioned(
            top: -70,
            right: -80,
            child: Container(
              height: 240,
              width: 240,
              decoration: const BoxDecoration(
                color: Color(0xff6C63FF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [

                    /// Success Icon
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape:
                        BoxShape.circle,
                        gradient:
                        const LinearGradient(
                          colors: [
                            Color(
                                0xff57B4FF),
                            Color(
                                0xff6C63FF),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue
                                .withOpacity(
                                .3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color:
                        Colors.white,
                        size: 65,
                      ),
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    const Text(
                      "Payment Successful",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                        FontWeight.bold,
                        color: Color(
                            0xff4A4A4A),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Text(
                      "Your payment has been completed successfully.",
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors
                            .grey
                            .shade600,
                      ),
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    /// Amount card
                    Container(
                      padding:
                      const EdgeInsets
                          .all(18),
                      decoration:
                      BoxDecoration(
                        color:
                        Colors.white,
                        borderRadius:
                        BorderRadius
                            .circular(
                            20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                                .05),
                            blurRadius:
                            10,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [

                          const Text(
                            "Amount Paid",
                            style:
                            TextStyle(
                              fontSize:
                              16,
                            ),
                          ),

                          Obx(
                                ()=> Text(
                              controller
                                  .amount
                                  .value,
                              style:
                              const TextStyle(
                                fontSize:
                                20,
                                fontWeight:
                                FontWeight
                                    .bold,
                                color:
                                Color(
                                    0xff6C63FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 60,
                    ),

                    SizedBox(
                      width:
                      double.infinity,
                      height: 58,
                      child:
                      ElevatedButton(
                        style:
                        ElevatedButton
                            .styleFrom(
                          elevation: 0,
                          backgroundColor:
                          const Color(
                              0xff57B4FF),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                30),
                          ),
                        ),
                        onPressed:
                        controller
                            .goToHome,
                        child:
                        const Text(
                          "Back To Home",
                          style:
                          TextStyle(
                            color: Colors
                                .white,
                            fontSize:
                            18,
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Bottom circles
          Positioned(
            bottom: -60,
            left: -50,
            child: Container(
              height: 150,
              width: 150,
              decoration:
              const BoxDecoration(
                color:
                Color(0xff6C63FF),
                shape:
                BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -70,
            right: -40,
            child: Container(
              height: 180,
              width: 180,
              decoration:
              const BoxDecoration(
                color:
                Color(0xff57B4FF),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}