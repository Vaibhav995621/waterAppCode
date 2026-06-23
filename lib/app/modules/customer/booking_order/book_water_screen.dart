import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import 'book_water_controller.dart';
import '../../../models/bottel_model/botle_model.dart';

class BookWaterScreen extends GetView<BookWaterController> {
  const BookWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Water"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// BOTTLE LIST
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    /// Dynamic Bottle List
                    Obx(
                          () => Column(
                        children: controller.bottleList
                            .map(
                              (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _bottleCard(item),
                          ),
                        )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Quantity
                    _sectionTitle("Quantity"),

                    Obx(
                          () => Row(
                        children: [
                          _qtyButton(
                            Icons.remove,
                            controller.decrementQty,
                          ),

                          Container(
                            margin:
                            const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text(
                              "${controller.quantity.value}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          _qtyButton(
                            Icons.add,
                            controller.incrementQty,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// DATE
                    _sectionTitle("Delivery Date"),

                    Obx(
                          () => GestureDetector(
                        onTap: () async {
                          final now = DateTime.now();

                          DateTime initialDate =
                              controller.selectedDate.value;

                          if (initialDate.isBefore(now)) {
                            initialDate = now;
                          }

                          DateTime? picked = await showDatePicker(
                            context: Get.context!,
                            initialDate: initialDate,
                            firstDate: now,
                            lastDate: DateTime(2100),
                          );

                          if (picked != null) {
                            controller.setDate(picked);
                          }
                        },
                        child: _inputTile(
                          "${controller.selectedDate.value.day} "
                              "${_monthName(controller.selectedDate.value.month)}, "
                              "${controller.selectedDate.value.year}",
                          Icons.calendar_today,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// TIME
                    _sectionTitle("Delivery Time"),

                    Obx(
                          () => _inputTile(
                        controller.selectedTime.value,
                        Icons.keyboard_arrow_down,
                      ),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),

            /// PLACE ORDER BUTTON
            Obx(
                  () => SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //controller.addOrder();
                    Get.toNamed(
                      AppRoutes.paymentScreen,
                      arguments: {
                        "waterbottleid": controller.bottle.id,
                        "price": controller.total.toString(),
                        "quantity": controller.quantity.value,
                        "deliverydate": controller.selectedDate.value,
                        "deliverytime": controller.selectedTime.value,
                        "plantype": controller.bottle.plantype,

                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Continue  |  Total ₹${controller.total}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// DYNAMIC BOTTLE CARD
  /// DYNAMIC BOTTLE CARD
  Widget _bottleCard(BottleData item) {
    return Obx(
          () {
        final isSelected =
            controller.selectedBottle.value ==
                item.id;

        return GestureDetector(
          onTap: () {
            controller.selectBottle(
              item.id,
            );
          },

          child: Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? Colors.blue
                    : Colors.grey.shade300,
                width: 1.5,
              ),

              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),

            child: Row(
              children: [
                /// IMAGE
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                    NetworkImage(
                      item.photo,
                    ),
                  ),
                ),


                const SizedBox(width: 12),

                /// DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        item.bottlename,

                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.description,

                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Text(
                            "₹${item.discountprice}",

                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            "₹${item.originalprice}",

                            style: TextStyle(
                              decoration:
                              TextDecoration
                                  .lineThrough,
                              color:
                              Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _qtyButton(
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),

        child: Icon(icon),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),

        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _inputTile(String text, IconData icon) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),

          Icon(icon, size: 18),
        ],
      ),
    );
  }
}

String _monthName(int month) {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  return months[month - 1];
}