import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import 'order_schedule_controller.dart';


class OrderScheduleScreen extends GetView<OrderScheduleController> {
  const OrderScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Register controller if not present
    final controller = Get.put(OrderScheduleController());

    return Scaffold(
      backgroundColor: const Color(0xffF2F6F3),
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Color(0xff1B4D3E),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1B4D3E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xff1B4D3E),
                          size: 24,
                        ),
                      ),
                      Obx(
                        () => Stack(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Color(0xff1B4D3E),
                                size: 24,
                              ),
                            ),
                            if (controller.cartItemCount.value > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xff4CAF50),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "${controller.cartItemCount.value}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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

            // MAIN SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PROMO BANNER CARD
                    _buildPromoBanner(),

                    const SizedBox(height: 20),

                    // SUBSCRIPTION TYPE (DAILY / WEEKLY / CUSTOM)
                    _buildSubscriptionTypeSelector(controller),

                    const SizedBox(height: 20),

                    // START DATE & END DATE ROW
                    _buildDatePickersRow(context, controller),

                    const SizedBox(height: 20),

                    // SUBSCRIPTION DURATION DROPDOWN
                    _buildDurationDropdown(controller),

                    const SizedBox(height: 20),

                    // DYNAMIC SCHEDULING SECTION (WEEKLY DAYS / CUSTOM DATES GRID / DAILY INFO)
                    Obx(() {
                      if (controller.selectedType.value == 'Weekly') {
                        return _buildWeeklyDaysSelector(controller);
                      } else if (controller.selectedType.value == 'Custom') {
                        return _buildCustomDatesSelector(controller);
                      } else {
                        return _buildDailyInfoBanner();
                      }
                    }),

                    const SizedBox(height: 24),

                    // PRODUCT FEATURES SCROLL ROW
                    _buildProductFeaturesRow(),

                    const SizedBox(height: 24),

                    // PRODUCT DETAIL TABS
                    _buildProductDetailTabs(controller),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // STICKY BOTTOM BUTTON
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff146950),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () => controller.addToCart(),
                  child: const Text(
                    "ADD TO CART",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. PROMO BANNER
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffDDF2E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffC5E8D4)),
      ),
      child: Row(
        children: [
          // Bottle image / illustration
          Container(
            width: 70,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.water_drop,
                  size: 48,
                  color: Color(0xff29B6F6),
                ),
                Positioned(
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xff146950),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "20L Jar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Banner Text & Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Subscribe once.\nStay hydrated daily.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Color(0xff1B4D3E),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff146950),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "SUBSCRIBE NOW",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. SUBSCRIPTION TYPE SELECTOR (DAILY / WEEKLY / CUSTOM)
  Widget _buildSubscriptionTypeSelector(OrderScheduleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Subscription Type",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xff1B4D3E),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            children: [
              _buildTypePill(controller, "Daily"),
              const SizedBox(width: 10),
              _buildTypePill(controller, "Weekly"),
              const SizedBox(width: 10),
              _buildTypePill(controller, "Custom"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypePill(OrderScheduleController controller, String type) {
    final isSelected = controller.selectedType.value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setSubscriptionType(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xffFFE500) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xffFBC02D) : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: const Color(0xffFFE500).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            type,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xff1B4D3E) : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  // 3. START DATE & END DATE PICKERS ROW
  Widget _buildDatePickersRow(BuildContext context, OrderScheduleController controller) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Row(
      children: [
        // START DATE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Start Date",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1B4D3E),
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: controller.startDate.value ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      controller.setStartDate(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.startDate.value != null
                              ? dateFormat.format(controller.startDate.value!)
                              : "YYYY-MM-DD",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: controller.startDate.value != null
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: controller.startDate.value != null
                                ? Colors.black87
                                : Colors.grey.shade400,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // END DATE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "End Date",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1B4D3E),
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    if (controller.startDate.value == null) {
                      AppSnackbar.error("Please select a start date first.");
                      return;
                    }
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: controller.endDate.value ?? controller.startDate.value!,
                      firstDate: controller.startDate.value!,
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      controller.setEndDate(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.endDate.value != null
                              ? dateFormat.format(controller.endDate.value!)
                              : "YYYY-MM-DD",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: controller.endDate.value != null
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: controller.endDate.value != null
                                ? Colors.black87
                                : Colors.grey.shade400,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 4. SUBSCRIPTION DURATION DROPDOWN
  Widget _buildDurationDropdown(OrderScheduleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Subscription Duration",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xff1B4D3E),
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedDuration.value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                items: controller.durations.map((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.updateDuration(val);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 5. WEEKLY DAYS SELECTOR (Mon, Tue, Wed, Thu, Fri, Sat, Sun)
  Widget _buildWeeklyDaysSelector(OrderScheduleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select the days of delivery",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff1B4D3E),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 10,
            children: controller.daysOfWeek.map((day) {
              final isSelected = controller.selectedDays.contains(day);
              return GestureDetector(
                onTap: () => controller.toggleDay(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: (Get.width - 32 - 24) / 4, // 4 items per row
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xffFFE500) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xffFBC02D) : Colors.grey.shade300,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? const Color(0xff1B4D3E) : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 6. CUSTOM DATES SELECTOR (GRID OF DATES 1 to 31)
  Widget _buildCustomDatesSelector(OrderScheduleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Delivery Dates",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff1B4D3E),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 31,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final dateNum = index + 1;
              return Obx(() {
                final isSelected = controller.selectedCustomDates.contains(dateNum);
                return GestureDetector(
                  onTap: () => controller.toggleCustomDate(dateNum),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xffFFE500) : const Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xffFBC02D) : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$dateNum",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? const Color(0xff1B4D3E) : Colors.black87,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  // 7. DAILY INFO BANNER
  Widget _buildDailyInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_outline, color: Color(0xff4CAF50), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Daily Delivery: Water jar will be delivered every single day during your subscription period.",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff1B4D3E),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 8. PRODUCT FEATURES SCROLL ROW
  Widget _buildProductFeaturesRow() {
    final features = [
      {'icon': Icons.shield_outlined, 'title': '10 Stage\nPurification'},
      {'icon': Icons.verified_outlined, 'title': '90 Quality\nTests'},
      {'icon': Icons.opacity_outlined, 'title': 'With Added\nMinerals'},
      {'icon': Icons.cleaning_services_outlined, 'title': 'Double\nOzonisation'},
      {'icon': Icons.sanitizer_outlined, 'title': 'Contactless\nProduction'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: features.map((feat) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  feat['icon'] as IconData,
                  size: 20,
                  color: const Color(0xff146950),
                ),
                const SizedBox(width: 8),
                Text(
                  feat['title'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 9. PRODUCT DETAIL TABS & DESCRIPTION
  Widget _buildProductDetailTabs(OrderScheduleController controller) {
    final tabs = ["Product Description", "Delivery Instructions", "Additional Info"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = controller.selectedDetailTab.value == index;
                return GestureDetector(
                  onTap: () => controller.selectedDetailTab.value = index,
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? const Color(0xff146950) : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xff146950) : Colors.grey.shade600,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          String text = "";
          if (controller.selectedDetailTab.value == 0) {
            text =
                "Bisleri Mineral Water is not just an ordinary bottle of water. Every drop of Bisleri water undergoes a rigorous 10-stage purification process to ensure supreme purity and freshness for your family.";
          } else if (controller.selectedDetailTab.value == 1) {
            text =
                "Deliveries take place every morning between 6:00 AM and 9:00 AM. Please ensure access to your doorstep or leave empty jars outside.";
          } else {
            text =
                "Contains essential minerals such as Potassium and Magnesium. Packaged in 100% recyclable food-grade PET bottles.";
          }

          return Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          );
        }),
      ],
    );
  }
}
