import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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
                      () {
                        if (controller.isLoading.value) {
                          return Column(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _bottleCardShimmer(),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: controller.bottleList
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _bottleCard(item),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Quantity
                    _sectionTitle("Quantity"),

                    Obx(
                      () => IgnorePointer(
                        ignoring: controller.isLoading.value,
                        child: Opacity(
                          opacity: controller.isLoading.value ? 0.6 : 1.0,
                          child: Row(
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
                      ),
                    ),
                    const SizedBox(height: 15),

                    Obx(
                          () {
                        if (controller.isLoading.value ||
                            controller.bottleList.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final hasLift = controller.isLiftAvailable;
                        final floorNum = controller.floor;
                        final rate = controller.floorCharges;

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Price Breakdown",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Bottle Price (₹${controller.price} × ${controller.quantity.value})",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700),
                                  ),
                                  Text(
                                    "₹${controller.bottleSubtotal}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    hasLift
                                        ? "Floor Charges (Lift Available)"
                                        : "Floor Charges ($floorNum floor${floorNum == 1 ? '' : 's'} × ₹$rate)",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700),
                                  ),
                                  Text(
                                    hasLift
                                        ? "₹0"
                                        : "₹${controller.floorTotal}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: hasLift ? Colors.green : null,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total Amount",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹${controller.total}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    /// PRICE BREAKDOWN
                    const SizedBox(height: 20),

                    /// DELIVERY ADDRESS & FLOOR DETAILS
                    _sectionTitle("Delivery Address & Floor"),

                    Obx(
                      () {
                        final addr = controller
                            .addressController.selectedAddress.value;
                        final floorNum = controller.floor;
                        final hasLift = controller.isLiftAvailable;
                        final rate = controller.floorCharges;

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.blue, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      addr != null &&
                                              addr.fullAddress.isNotEmpty
                                          ? addr.fullAddress
                                          : "No address selected",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.selectAddress);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text("Change"),
                                  ),
                                ],
                              ),
                              const Divider(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      floorNum == 0
                                          ? "Ground Floor (0)"
                                          : "Floor $floorNum",
                                      style: TextStyle(
                                        color: Colors.blue.shade800,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: hasLift
                                          ? Colors.green.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          hasLift
                                              ? Icons.elevator
                                              : Icons.stairs,
                                          size: 14,
                                          color: hasLift
                                              ? Colors.green.shade800
                                              : Colors.orange.shade800,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          hasLift
                                              ? "Lift Available (Free)"
                                              : "No Lift (₹$rate/floor)",
                                          style: TextStyle(
                                            color: hasLift
                                                ? Colors.green.shade800
                                                : Colors.orange.shade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// DATE
                    _sectionTitle("Delivery Date"),

                    Obx(
                      () => IgnorePointer(
                        ignoring: controller.isLoading.value,
                        child: Opacity(
                          opacity: controller.isLoading.value ? 0.6 : 1.0,
                          child: GestureDetector(
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
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// TIME
                    _sectionTitle("Delivery Time"),

                    Obx(
                      () => IgnorePointer(
                        ignoring: controller.isLoading.value,
                        child: Opacity(
                          opacity: controller.isLoading.value ? 0.6 : 1.0,
                          child: _inputTile(
                            controller.selectedTime.value,
                            Icons.keyboard_arrow_down,
                          ),
                        ),
                      ),
                    ),


                    const SizedBox(height: 15),

                    /// SCHEDULE ORDER BANNER
                    GestureDetector(
                      onTap: () {
                        BottleData? selectedBottleData;
                        if (controller.bottleList.isNotEmpty) {
                          selectedBottleData = controller.bottleList.firstWhereOrNull(
                            (e) => e.id == controller.selectedBottle.value,
                          ) ?? controller.bottleList.first;
                        }

                        int addressId = controller.addressController.selectedAddress.value?.id ??
                            (controller.addressController.selectedId.value > 0
                                ? controller.addressController.selectedId.value
                                : 0);

                        Get.toNamed(
                          AppRoutes.orderSchedule,
                          arguments: {
                            "bottle": selectedBottleData,
                            "waterbottleid": controller.selectedBottle.value.toString(),
                            "orderquantity": controller.quantity.value.toString(),
                            "unitprice": controller.price.toString(),
                            "addressid": addressId,
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xffDDF2E6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xffC5E8D4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                color: Color(0xff146950)),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Schedule Water Subscription",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff1B4D3E),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Daily, Weekly or Custom delivery days",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff146950),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xff146950),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Schedule",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),



                  ],
                ),
              ),
            ),

            /// PLACE ORDER BUTTON
            Obx(
              () {
                final isLoading = controller.isLoading.value;
                final isEmpty = controller.bottleList.isEmpty;
                final bool isBtnEnabled = !isLoading && !isEmpty;

                return SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isBtnEnabled
                        ? () {
                            Get.toNamed(
                              AppRoutes.paymentScreen,
                              arguments: {
                                "waterbottleid": controller.bottle.id,
                                "price": controller.total.toString(),
                                "quantity": controller.quantity.value,
                                "deliverydate": controller.selectedDate.value,
                                "deliverytime": controller.selectedTime.value,
                                "plantype": controller.bottle.plantype,
                                "floor": controller.floor,
                                "floorCharges": controller.floorCharges,
                              },
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.blue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLoading
                          ? "Loading Bottles..."
                          : (isEmpty ? "No Bottles Available" : "Continue  |  Total ₹${controller.total}"),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
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

  Widget _bottleCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          /// IMAGE PLACEHOLDER
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          /// DETAILS PLACEHOLDER
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 150,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 50,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 40,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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