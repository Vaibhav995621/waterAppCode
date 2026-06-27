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
                    Obx(() {
                      IconData iconData = Icons.check;
                      List<Color> gradientColors = [const Color(0xff57B4FF), const Color(0xff6C63FF)];

                      if (controller.type.value == "cod") {
                        iconData = Icons.local_shipping_outlined;
                        gradientColors = [const Color(0xff4CAF50), const Color(0xff81C784)];
                      } else if (controller.type.value == "subscription") {
                        iconData = Icons.star_rounded;
                        gradientColors = [const Color(0xffFF9F1C), const Color(0xffFFBF69)];
                      } else if (controller.type.value == "subscription_purchase") {
                        iconData = Icons.card_membership_rounded;
                        gradientColors = [const Color(0xff6C63FF), const Color(0xff57B4FF)];
                      }

                      return Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: gradientColors,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradientColors[0].withOpacity(.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Icon(
                          iconData,
                          color: Colors.white,
                          size: 65,
                        ),
                      );
                    }),

                    const SizedBox(
                      height: 35,
                    ),

                    Obx(() {
                      String titleText = "Payment Successful";
                      if (controller.type.value == "cod") {
                        titleText = "Order Placed!";
                      } else if (controller.type.value == "subscription") {
                        titleText = "Order Confirmed!";
                      } else if (controller.type.value == "subscription_purchase") {
                        titleText = "Subscription Active!";
                      }
                      return Text(
                        titleText,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4A4A4A),
                        ),
                      );
                    }),

                    const SizedBox(
                      height: 12,
                    ),

                    Obx(() {
                      String descText = "Your payment has been completed successfully.";
                      if (controller.type.value == "cod") {
                        descText = "Your order has been placed successfully. Please pay cash upon delivery.";
                      } else if (controller.type.value == "subscription") {
                        descText = "Your order has been confirmed using your active subscription plan.";
                      } else if (controller.type.value == "subscription_purchase") {
                        descText = "Your subscription plan has been activated successfully.";
                      }
                      return Text(
                        descText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      );
                    }),

                    const SizedBox(
                      height: 50,
                    ),

                    /// Amount card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Obx(() {
                        String cardTitleText = "Amount Paid";
                        String cardValueText = controller.amount.value;

                        if (controller.type.value == "cod") {
                          cardTitleText = "Amount to Pay";
                        } else if (controller.type.value == "subscription") {
                          cardTitleText = "Payment Method";
                          cardValueText = "Subscription Plan";
                        } else if (controller.type.value == "subscription_purchase") {
                          cardTitleText = "Plan Amount";
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cardTitleText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              cardValueText,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6C63FF),
                              ),
                            ),
                          ],
                        );
                      }),
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