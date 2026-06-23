// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'current_plan.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../app_session/app_session.dart';
import '../../../global_controller/bottomTabBar/navigation_controller.dart';
import 'customer_home_controller.dart';

class CustomerHomeScreen extends GetView<CustomerHomeController> {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: Stack(
        children: [

          /// Background circles
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              height: 180,
              width: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff62B5F8),
              ),
            ),
          ),

          Positioned(
            top: -70,
            right: -90,
            child: Container(
              height: 250,
              width: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6B67F6),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    const SizedBox(height: 30),

                    /// profile
                    ///

                    AppSession.image.isEmpty ? Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Colors.black12,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xff45A9F8),
                      ),
                    ) : Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                        AppSession.image.isNotEmpty
                            ? NetworkImage(AppSession.image)
                            : const NetworkImage(
                          "https://i.pravatar.cc/150",
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      " Hello, ${AppSession.name} 👋",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "Good Morning",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Subscription card
                    Obx(() {
                      final profile = controller.profile.value;

                      if (profile == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return controller.profile.value?.data.plandetail.status ==
                          1 ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                              )
                            ],
                          ),

                          child: Column(
                            children: [

                              /// Active Badge
                              Row(
                                children: [
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration:
                                    BoxDecoration(
                                      color: Colors.green
                                          .withOpacity(.1),
                                      borderRadius:
                                      BorderRadius.circular(
                                          30),
                                    ),
                                    child: const Row(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Plan Active",
                                          style: TextStyle(
                                            color:
                                            Colors.green,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: [

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [

                                        Text(
                                          controller.profile.value?.data
                                              .plandetail.planname ?? "0",
                                          style:
                                          const TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            fontSize: 24,
                                          ),
                                        ),

                                        const SizedBox(
                                            height: 8),

                                        Text(
                                          "Bottles Remains ${controller.profile.value?.data
                                              .planbottlequantity ??
                                              "0"}",
                                          style:
                                          const TextStyle(
                                            color:
                                            Colors.blue,
                                            fontSize: 16
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 6),
                                        Text(
                                          "${controller.profile.value?.data
                                              .plandetail.bottlequantity ??
                                              "0"} Bottles Included",
                                          style:
                                          const TextStyle(
                                            color:
                                            Colors.blue,
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding:
                                    const EdgeInsets.all(
                                        18),
                                    decoration:
                                    BoxDecoration(
                                      gradient:
                                      const LinearGradient(
                                        colors: [
                                          Colors.green,
                                          Colors.teal,
                                        ],
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(
                                          25),
                                    ),
                                    child: Column(
                                      children: [

                                        Text(
                                          "₹${controller.profile.value?.data
                                              .plandetail.price ?? "0"}",
                                          style:
                                          const TextStyle(
                                            color:
                                            Colors.white,
                                            fontSize: 26,
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                        ),
                                        Text(
                                          "Price ₹${
                                              (int.tryParse(
                                                  controller.profile.value?.data
                                                      .plandetail
                                                      .originalprice ?? "0"
                                              ) ?? 0)
                                          }",
                                          style:
                                          const TextStyle(
                                            color:
                                            Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),

                                        Text(
                                          "Saved ₹${
                                              (int.tryParse(
                                                  controller.profile.value?.data
                                                      .plandetail
                                                      .originalprice ?? "0"
                                              ) ?? 0) -
                                                  (int.tryParse(
                                                      controller.profile.value
                                                          ?.data.plandetail
                                                          .price ?? "0") ?? 0)
                                          }",
                                          style:
                                          const TextStyle(
                                            color:
                                            Colors.white,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 25),

                              Container(
                                height: 55,
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      30),
                                  color: Colors.green,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Subscription Active ✓",
                                    style: TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                      ) : Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                            )
                          ],
                        ),
                        child: Column(
                          children: [

                            Row(
                              children: [

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Premium Water",
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),

                                      SizedBox(height: 8),

                                      Text(
                                        "Get faster delivery and save more",
                                        style: TextStyle(
                                            color:
                                            Colors.grey),
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  padding:
                                  EdgeInsets.all(20),
                                  decoration:
                                  BoxDecoration(
                                    gradient:
                                    LinearGradient(
                                      colors: [
                                        Colors.green,
                                        Colors.teal
                                      ],
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        25),
                                  ),
                                  child: Column(
                                    children: const [
                                      Text(
                                        "₹16",
                                        style:
                                        TextStyle(
                                          color:
                                          Colors
                                              .white,
                                          fontSize:
                                          24,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),
                                      Text(
                                        "Bottle",
                                        style:
                                        TextStyle(
                                          color:
                                          Colors
                                              .white,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),

                            SizedBox(height: 25),

                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.subscription);
                              },

                              child: Container(
                                height: 55,
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      30),
                                  gradient:
                                  LinearGradient(
                                    colors: [
                                      Color(
                                          0xff4A7CFF),
                                      Color(
                                          0xffD84BFF)
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Subscribe Now →",
                                    style:
                                    TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );

                    }),

                    SizedBox(height: 30),

                    Align(
                      alignment:
                      Alignment.centerLeft,
                      child: Text(
                        "Active Orders",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      padding:
                      EdgeInsets.all(20),
                      decoration:
                      BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius
                            .circular(
                            25),
                      ),
                      child: Row(
                        children: [

                          CircleAvatar(
                            backgroundColor:
                            Colors.blue
                                .shade100,
                            child: Icon(
                                Icons.local_shipping),
                          ),

                          SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: const [
                                Text(
                                  "Order #1234",
                                  style:
                                  TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                                Text(
                                    "Out for delivery")
                              ],
                            ),
                          ),

                          Container(
                            padding:
                            EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration:
                            BoxDecoration(
                              color: Colors.green
                                  .shade100,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  20),
                            ),
                            child:
                            Text("Track"),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 120)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget actionCard(IconData icon,
      String title,
      Color color,) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
        BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),

          SizedBox(height: 12),

          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}


// import 'customer_home_controller.dart';
//
// class CustomerHomeScreen extends GetView<CustomerHomeController> {
//   const CustomerHomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF4F7FC),
//
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 40,),
//             /// ================= HEADER SECTION =================
//             SizedBox(
//               height: 520,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   /// BLUE HEADER
//                   Container(
//                     height: 320,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xff1976D2), Color(0xff42A5F5)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//
//                       borderRadius: BorderRadius.vertical(
//                         bottom: Radius.circular(30),
//                       ),
//                     ),
//
//                     padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
//
//                     child: Obx(
//                           () => Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           /// TOP BAR
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               /// USER INFO
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Hello, ${controller.userName.value} 👋",
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//
//                                   const SizedBox(height: 6),
//
//                                   const Text(
//                                     "Good Morning!",
//                                     style: TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               /// NOTIFICATION ICON
//                               Container(
//                                 padding: const EdgeInsets.all(10),
//
//                                 decoration: BoxDecoration(
//                                   color: Colors.white24,
//                                   shape: BoxShape.circle,
//                                 ),
//
//                                 child: const Icon(
//                                   Icons.notifications_none,
//                                   color: Colors.white,
//                                   size: 28,
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 30),
//
//                           /// QUICK STATS
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: _buildTopCard(
//                                   icon: Icons.local_drink_outlined,
//                                   value: "12",
//                                   title: "Orders",
//                                 ),
//                               ),
//
//                               const SizedBox(width: 14),
//
//                               Expanded(
//                                 child: _buildTopCard(
//                                   icon: Icons.account_balance_wallet,
//                                   value: "₹450",
//                                   title: "Wallet",
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   /// SUBSCRIBE CARD
//                   Positioned(
//                     top: 140,
//                     left: 20,
//                     right: 20,
//
//                     child: Material(
//                       color: Colors.transparent,
//                       child: SubscribeNowCard(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 60,),
//             /// ================= BOOK BUTTON =================
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 58,
//
//                 child: ElevatedButton(
//                   onPressed: controller.bookWater,
//
//                   style: ElevatedButton.styleFrom(
//                     elevation: 0,
//                     backgroundColor: const Color(0xff1976D2),
//
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                   ),
//
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.water_drop_outlined, color: Colors.white),
//
//                       SizedBox(width: 10),
//
//                       Text(
//                         "Book Water Now",
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 28),
//
//             /// ================= ACTIVE ORDER =================
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//
//               child: Text(
//                 "Active Order",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//
//             const SizedBox(height: 15),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//
//               child: Obx(
//                     () => Container(
//                   padding: const EdgeInsets.all(18),
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(22),
//
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(.04),
//                         blurRadius: 15,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//
//                     children: [
//                       /// ORDER HEADER
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Order #${controller.orderId.value}",
//                             style: const TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade50,
//
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//
//                             child: Text(
//                               controller.orderStatus.value,
//
//                               style: TextStyle(
//                                 color: Colors.green.shade700,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 18),
//
//                       /// DETAILS
//                       Row(
//                         children: [
//                           _buildOrderInfo(
//                             Icons.water_drop_outlined,
//                             controller.bottleType.value,
//                           ),
//
//                           const SizedBox(width: 15),
//
//                           _buildOrderInfo(
//                             Icons.production_quantity_limits,
//                             controller.quantity.value,
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 18),
//
//                       /// DELIVERY TIME
//                       Container(
//                         padding: const EdgeInsets.all(14),
//
//                         decoration: BoxDecoration(
//                           color: const Color(0xffF4F7FC),
//
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.access_time_rounded,
//                               color: Colors.blue,
//                             ),
//
//                             const SizedBox(width: 10),
//
//                             Expanded(
//                               child: Text(
//                                 controller.deliveryTime.value,
//
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             /// VIEW ALL
//             Align(
//               alignment: Alignment.centerRight,
//
//               child: TextButton(
//                 onPressed: controller.viewAllOrders,
//
//                 child: const Padding(
//                   padding: EdgeInsets.only(right: 15),
//
//                   child: Text(
//                     "View All Orders",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xff1976D2),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             /// ================= RECENT ACTIVITY =================
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//
//               child: Text(
//                 "Recent Activity",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//
//             const SizedBox(height: 15),
//
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//
//               itemCount: 3,
//
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 14),
//
//                   padding: const EdgeInsets.all(16),
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//
//                     borderRadius: BorderRadius.circular(18),
//
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(.03),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(.1),
//
//                           shape: BoxShape.circle,
//                         ),
//
//                         child: const Icon(
//                           Icons.local_drink_outlined,
//                           color: Colors.blue,
//                         ),
//                       ),
//
//                       const SizedBox(width: 15),
//
//                       const Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//
//                           children: [
//                             Text(
//                               "20L Water Delivered",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//
//                             SizedBox(height: 4),
//
//                             Text(
//                               "Delivered successfully",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const Text(
//                         "Today",
//                         style: TextStyle(color: Colors.grey, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// ================= TOP CARD =================
//   Widget _buildTopCard({
//     required String title,
//     required String value,
//     required IconData icon,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.12),
//
//         borderRadius: BorderRadius.circular(20),
//
//         border: Border.all(color: Colors.white.withOpacity(.15)),
//       ),
//
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//
//         children: [
//           Icon(icon, color: Colors.white),
//
//           const SizedBox(height: 15),
//
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 4),
//
//           Text(title, style: const TextStyle(color: Colors.white70)),
//         ],
//       ),
//     );
//   }
//
//   /// ================= ORDER INFO =================
//   Widget _buildOrderInfo(IconData icon, String text) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(14),
//
//         decoration: BoxDecoration(
//           color: const Color(0xffF4F7FC),
//
//           borderRadius: BorderRadius.circular(14),
//         ),
//
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.blue, size: 20),
//
//             const SizedBox(width: 10),
//
//             Expanded(
//               child: Text(
//                 text,
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
