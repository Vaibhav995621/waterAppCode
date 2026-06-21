/// assign_delivery_boy_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'assign_delivery_boy_controller.dart';

class AssignDeliveryBoyView
    extends GetView<AssignDeliveryBoyController> {
  AssignDeliveryBoyView({super.key});

  @override
  final AssignDeliveryBoyController controller =
  Get.put(AssignDeliveryBoyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5FB),

      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADER
        buildHeader(),

        /// SEARCH FIXED
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),

          child: Container(
            height: 50,

            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),

              border: Border.all(
                color: Colors.grey.shade300,
              ),

              color: Colors.white,
            ),

            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.searchDeliveryBoy,
                    decoration: InputDecoration(

                      border: InputBorder.none,

                      hintText:
                      "Search delivery boy...",

                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// ONLY LIST SCROLL
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.filteredBoys.isEmpty) {
              return const Center(
                child: Text(
                  "No delivery boys found",
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              itemCount: controller.filteredBoys.length,
              separatorBuilder: (_, __) => Divider(
                color: Colors.grey.shade200,
                height: 24,
              ),
              itemBuilder: (context, index) {
                final item = controller.filteredBoys[index];

                return GestureDetector(
                  onTap: () => controller.selectBoy(item.id),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xffE8EEF9),
                        backgroundImage: item.photo.isNotEmpty
                            ? NetworkImage(item.photo)
                            : null,
                        child: item.photo.isEmpty
                            ? const Icon(
                          Icons.person,
                          color: Colors.grey,
                        )
                            : null,
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.fullname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff222222),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.mobile,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.status == 1
                                  ? "Available"
                                  : "Inactive",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: item.status == 1
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Obx(() {
                        final isSelected =
                            controller.selectedBoyId.value == item.id;

                        return GestureDetector(
                          onTap: () => controller.selectBoy(item.id),
                          child: Container(
                            height: 26,
                            width: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Center(
                              child: CircleAvatar(
                                radius: 7,
                                backgroundColor: Colors.blue,
                              ),
                            )
                                : null,
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          }),
        ),
        /// FIXED BUTTON
        Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            20,
          ),

          child: SizedBox(
            width: double.infinity,
            height: 54,

            child: ElevatedButton(
              onPressed: () {
               controller.assignDeliveryBoy(context);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xff5B35D5),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),

              child: const Text(
                "Assign",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }
  Widget buildHeader() {
    return Container(
      height: 110,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff4527A0), Color(0xff5E35B1)],
        ),
      ),
      child: Column(
        children: [

          SizedBox(height: 30,),
          Stack(
            alignment: Alignment.center,
            children: [

              /// BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),

              /// TITLE
              const Center(
                child: Text(
                  "Assign Delivery Boy",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}