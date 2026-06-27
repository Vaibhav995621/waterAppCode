import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import 'delivery_order_list_controller.dart';

class DeliveryOrderListView extends GetView<DeliveryOrderListController> {
  const DeliveryOrderListView({super.key});
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
            top: -80,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 44),
                      const Text(
                        "My Orders",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A2C56),
                        ),
                      ),
                      
                      // Notification Icon Button
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.notifications);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.black12,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Color(0xff6B67F6),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Toggle Card
                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                      horizontal: 16),
                  child: Container(
                    padding:
                    const EdgeInsets.all(5),
                    decoration:
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                          30),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Row(
                      children: [

                        _toggleButton(
                            "Active Orders",
                            true),

                        _toggleButton(
                            "History",
                            false),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    margin:
                    const EdgeInsets.only(
                      top: 10,
                    ),
                    padding:
                    const EdgeInsets.only(
                      top: 10,
                    ),
                    decoration:
                    const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(
                        top: Radius.circular(
                            35),
                      ),
                    ),

                    child: Obx(() {

                      if (controller
                          .isLoading.value) {
                        return const Center(
                          child:
                          CircularProgressIndicator(),
                        );
                      }

                      final orders =
                      controller
                          .isActiveSelected
                          .value
                          ? controller
                          .activeOrders
                          : controller
                          .historyOrders;

                      if (orders.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Orders Found",
                          ),
                        );
                      }

                      return ListView.builder(
                        padding:
                        const EdgeInsets
                            .all(16),
                        itemCount:
                        orders.length,
                        itemBuilder:
                            (context, index) {

                          final order =
                          orders[index];

                          return Padding(
                            padding:
                            const EdgeInsets
                                .only(
                              bottom: 15,
                            ),
                            child:
                            GestureDetector(
                                onTap: () async {
                                  final result = await Get.toNamed(
                                    AppRoutes.deliveryOrderDetail,
                                    arguments: order,
                                  );

                                  if (result == true) {
                                    controller
                                        .getCustomerActiveOrder(); // reload API
                                  }

                              },
                              child:
                              _orderCard(
                                orderId: order
                                    .ordernumber,
                                date: controller
                                    .formatDate(
                                  order
                                      .deliverydate,
                                  order
                                      .deliverytime,
                                ),
                                status:
                                controller
                                    .getStatusText(
                                  order
                                      .status,
                                ),
                                statusColor:
                                controller
                                    .getStatusColor(
                                  order
                                      .status,
                                ),
                                product:
                                order.waterbottle_name,
                                qty:
                                "${order.quantity} Qty",
                                price:
                                "₹${order.price}",
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 🔘 Toggle Button (GetX)
  Widget _toggleButton(String text, bool isActive) {
    return Expanded(
      child: Obx(() {
        final selected = controller.isActiveSelected.value == isActive;

        return GestureDetector(
          onTap: () => controller.toggleTab(isActive),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  /// 📦 Order Card UI
  Widget _orderCard({
    required String orderId,
    required String date,
    required String status,
    required Color statusColor,
    required String product,
    required String qty,
    required String price,
  }) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #$orderId",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

            ],
          ),
          const SizedBox(height: 5),

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 5),

          Text(
            date,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),

          const SizedBox(height: 12),

          /// Product Row
          Row(
            children: [
              Image.asset(
                "assets/images/bottle.png", // add your splash image here
                fit: BoxFit.fill,
                height: 45,
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    Text(qty,
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),

              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}