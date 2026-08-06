import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../utlis/progress_hud/app_snackbar.dart';
import 'bottle_subscription_controller.dart';

class BottleSubscriptionScreen extends StatelessWidget {
  BottleSubscriptionScreen({super.key});

  final controller = Get.put(BottleSubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FC),
      body: Stack(
        children: [
          /// THEME BACKGROUND
          Positioned(
            top: -60,
            left: -60,
            child: GestureDetector(
              onTap: () {
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
            top: -100,
            right: -100,
            child: Container(
              height: 260,
              width: 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6B67F6),
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: 120),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 25),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Choose your plan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0D1B52),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Obx(
                        () => Column(
                          children: List.generate(
                            controller.subscriptionList.length,
                            (index) {
                              final plan = controller.subscriptionList[index];
                              double basePrice = controller.getBasePrice(plan);
                              double floorCharge = controller.getFloorCharge(plan);
                              double totalPrice = controller.getTotalPrice(plan);
                              String bottles = plan.bottlequantity.toString();
                              String oldPrice = plan.originalprice;
                              String save = plan.totalsave.toString();
                              String perBottle = plan.rateperbottle
                                  .toStringAsFixed(2);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 18),
                                child: _buildPlanCard(
                                  index: index,
                                  bottles: bottles,
                                  save: save,
                                  oldPrice: oldPrice,
                                  price: basePrice.toStringAsFixed(0),
                                  floorCharge: floorCharge,
                                  totalPrice: totalPrice,
                                  perBottle: perBottle,
                                  color: Colors.blue,
                                  selected:
                                      controller.selectedPlan.value == index,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildPriceSummary(),

                      const SizedBox(height: 20),

                      _buildFeatures(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              /// BUTTON
              Padding(
                padding: const EdgeInsets.all(20),
                child: Obx(
                  () => SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6B67F6),
                        disabledBackgroundColor: const Color(0xff6B67F6),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: controller.isLoadingPayment.value
                          ? null
                          : () {
                              if (controller.subscriptionList.isEmpty) return;
                              final plan = controller.subscriptionList[
                                  controller.selectedPlan.value];
                              double price = controller.getTotalPrice(plan);
                              if (price > 0) {
                                controller.makePayment(price);
                              } else {
                                AppSnackbar.error(
                                  'Plan amount not valid',
                                );
                              }
                            },
                      child: controller.isLoadingPayment.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Pay Now",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xffF8FBFF), Color(0xffEEF5FF)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              const Text(
                "Bottle Subscription",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff0D1B52),
                ),
              ),
              const Text(
                "Stay hydrated, save more",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xffEAF1FF),
                      child: Icon(
                        Icons.local_offer_rounded,
                        color: Color(0xff2962FF),
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹20 per bottle",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff0D1B52),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Regular price",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),

                    VerticalDivider(),

                    Expanded(
                      child: Text(
                        "Save more with\nsubscription",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff16A34A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 30,
          right: 10,
          child: Image.network(
            "https://cdn-icons-png.flaticon.com/512/3105/3105807.png",
            height: 40,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String bottles,
    required String save,
    required String oldPrice,
    required String price,
    required double floorCharge,
    required double totalPrice,
    required String perBottle,
    required Color color,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () => controller.selectedPlan.value = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// BOTTLE IMAGE
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop_rounded,
                size: 50,
                color: Color(0xff64B5F6),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$bottles Bottles",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff0D1B52),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffE8F8EE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Save ₹$save",
                      style: const TextStyle(
                        color: Color(0xff16A34A),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                "Original Price:",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "₹$price",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff0D1B52),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const Expanded(
                        //       child: Text(
                        //         "Per Floor Charge:",
                        //         style: TextStyle(
                        //           fontSize: 11,
                        //           color: Colors.grey,
                        //         ),
                        //         overflow: TextOverflow.ellipsis,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 4),
                        //     Text(
                        //       "₹${(int.tryParse(bottles) ?? 0) * 3}/floor",
                        //       style: const TextStyle(
                        //         fontSize: 11,
                        //         fontWeight: FontWeight.w600,
                        //         color: Color(0xff475569),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                "Floor Price:",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.isLiftAvailable.value
                                  ? "₹0 (Lift)"
                                  : "₹${floorCharge.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: controller.isLiftAvailable.value
                                    ? const Color(0xff16A34A)
                                    : const Color(0xff2563EB),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Divider(height: 1, thickness: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                "Total Charges:",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff0D1B52),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "₹${totalPrice.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? color : Colors.grey.shade300,
                      width: 2,
                    ),
                    color: selected ? color : Colors.transparent,
                  ),
                  child: selected
                      ? const Icon(Icons.check, color: Colors.white, size: 10)
                      : null,
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "₹$perBottle",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "per bottle",
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildPriceSummary() {
    return Obx(() {
      if (controller.subscriptionList.isEmpty) return const SizedBox.shrink();
      final index = controller.selectedPlan.value;
      if (index < 0 || index >= controller.subscriptionList.length) {
        return const SizedBox.shrink();
      }

      final plan = controller.subscriptionList[index];
      final basePrice = controller.getBasePrice(plan);
      final floorCharge = controller.getFloorCharge(plan);
      final totalPrice = controller.getTotalPrice(plan);
      final floor = controller.selectedFloor.value;
      final bottles = plan.bottlequantity;
      final hasLift = controller.isLiftAvailable.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Price Summary",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff0D1B52),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Base Plan ($bottles Bottles)",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  "₹${basePrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff0D1B52),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hasLift
                        ? "Floor Charge (Lift Available)"
                        : (floor > 0
                            ? "Floor Charge ($floor Floor${floor > 1 ? 's' : ''} × $bottles Bottles × ₹3)"
                            : "Floor Charge (Ground Floor)"),
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
                Text(
                  hasLift || floor == 0
                      ? "₹0"
                      : "+ ₹${floorCharge.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: hasLift || floor == 0
                        ? const Color(0xff16A34A)
                        : const Color(0xff2563EB),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff0D1B52),
                  ),
                ),
                Text(
                  "₹${totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff6B67F6),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xffEEF5FF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FeatureItem(
            icon: Icons.calendar_month_outlined,
            title: "Regular delivery",
            subtitle: "Weekly / Monthly",
          ),
          _FeatureItem(
            icon: Icons.refresh,
            title: "Easy to manage",
            subtitle: "Pause anytime",
          ),
          _FeatureItem(
            icon: Icons.shield_outlined,
            title: "Secure & reliable",
            subtitle: "On-time delivery",
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Color(0xff1259FF), size: 28),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xff0D1B52),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
