import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'payment_history_controller.dart';

class PaymentHistoryScreen extends StatelessWidget {
  PaymentHistoryScreen({super.key});

  final controller =
  Get.find<PaymentHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xffF5F8FC,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: GestureDetector(
              onTap: (){
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
            top: -50,
            right: -80,
            child: Container(
              height: 220,
              width: 220,
              decoration: const BoxDecoration(
                color: Color(0xff6C63FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [

              const SizedBox(height: 80),

              const CircleAvatar(
                radius: 38,
                backgroundColor:
                Color(0xff58B6FF),
                child: Icon(
                  Icons.payment,
                  color: Colors.white,
                  size: 35,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Payment History",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  Color(0xff6C63FF),
                ),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: Obx(() {

                  if (controller
                      .isLoading.value) {
                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  if (controller
                      .paymentList
                      .isEmpty) {
                    return const Center(
                      child: Text(
                        "No Payment Found",
                      ),
                    );
                  }

                  return ListView.builder(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 20,
                    ),
                    itemCount:
                    controller
                        .paymentList
                        .length,
                    itemBuilder:
                        (context, index) {

                      final item =
                      controller
                          .paymentList[index];

                      return Container(
                        margin:
                        const EdgeInsets.only(
                          bottom: 15,
                        ),
                        padding:
                        const EdgeInsets.all(
                          18,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            25,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black12,
                              blurRadius:
                              10,
                            )
                          ],
                        ),
                        child: Column(
                          children: [

                            Row(
                              children: [

                                Container(
                                  padding:
                                  const EdgeInsets.all(
                                      12),
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                      0xff58B6FF,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(
                                        15),
                                  ),
                                  child:
                                  const Icon(
                                    Icons
                                        .receipt_long,
                                    color:
                                    Colors.white,
                                  ),
                                ),

                                const SizedBox(
                                    width:
                                    12),

                                Expanded(
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [

                                      Text(
                                        "₹${item.totalamount}",
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          20,
                                          fontWeight:
                                          FontWeight.bold,
                                          color:
                                          Color(
                                            0xff6C63FF,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                          height:
                                          5),

                                      Text(
                                        item.transId,
                                        style:
                                        TextStyle(
                                          color:
                                          Colors.grey
                                              .shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal:
                                    12,
                                    vertical:
                                    6,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color: item.transId.isNotEmpty ? Colors
                                        .green
                                        .shade100 : Colors
                                        .red
                                        .shade100 ,
                                    borderRadius:
                                    BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                  child:
                                  Text(
                                    item.transId.isNotEmpty ? "Paid" : "Failed",
                                    style:
                                    TextStyle(
                                      color:
                                      item.transId.isNotEmpty ? Colors.green : Colors.red,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const Divider(
                              height: 25,
                            ),

                            Row(
                              children: [

                                const Icon(
                                  Icons
                                      .calendar_month,
                                  size: 18,
                                  color:
                                  Colors.grey,
                                ),

                                const SizedBox(
                                    width: 8),

                                Text(
                                  DateFormat(
                                    "dd MMM yyyy, hh:mm a",
                                  ).format(
                                    item.transDate,
                                  ),
                                  style:
                                  TextStyle(
                                    color:
                                    Colors.grey
                                        .shade700,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
              )
            ],
          )
        ],
      ),
    );
  }
}