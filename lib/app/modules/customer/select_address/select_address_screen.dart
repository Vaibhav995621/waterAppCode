import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/app_session/app_session.dart';
import 'package:zourney/routes/app_routes.dart';
import 'select_address_controller.dart';

class SelectAddressScreen extends StatelessWidget {
  SelectAddressScreen({super.key});

  final controller = Get.put(SelectAddressController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments is Map ? Get.arguments : {};
    final int waterBottleId = args["waterbottleid"] ?? 0;
    final String price = args["price"] ?? "";
    final int quantity = args["quantity"] ?? 0;
    final DateTime deliveryDate = args["deliverydate"] is DateTime
        ? args["deliverydate"]
        : DateTime.now();
    final String deliveryTime = args["deliverytime"] ?? "";
    final int plantype = args["plantype"] ?? 0;


    return Scaffold(
      backgroundColor: const Color(0xffF5F8FD),

      body: Stack(
        children: [
          /// TOP LEFT CIRCLE
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

          /// TOP RIGHT CIRCLE
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

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const SizedBox(width: 48), // Balance the right side icon button
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Select Address",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2D3A5A),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Color(0xff6E6AF8),
                          size: 28,
                        ),
                        onPressed: () async {
                          final result = await Get.toNamed(
                            AppRoutes.editAddressScreen,
                          );
                          if (result == true) {
                            controller.getAddressList();
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// LOCATION ICON
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xff58B6FF), Color(0xff6E6AF8)],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(.3),
                        blurRadius: 15,
                      ),
                    ],
                  ),

                  child: const Icon(Icons.home, color: Colors.white, size: 30),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.addressList.isEmpty) {
                      return const Center(child: Text("No Address Found"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: controller.addressList.length,

                      itemBuilder: (context, index) {
                        var item = controller.addressList[index];

                        return Obx(() {
                          bool selected =
                              controller.selectedId.value == item.id;

                          return GestureDetector(
                            onTap: () {
                              controller.selectAddress(item.id!);
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),

                              margin: const EdgeInsets.only(bottom: 16),

                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(
                                gradient: selected
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xff7268FF),
                                          Color(0xff59B6FF),
                                        ],
                                      )
                                    : null,

                                color: selected ? null : Colors.white,

                                borderRadius: BorderRadius.circular(30),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.15),

                                    blurRadius: 10,

                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),

                              child: Row(
                                children: [
                                  Container(
                                    height: 28,
                                    width: 28,

                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,

                                      border: Border.all(
                                        color: selected
                                            ? Colors.white
                                            : const Color(0xff7268FF),

                                        width: 2,
                                      ),
                                    ),

                                    child: selected
                                        ? const Center(
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          item.societyname,

                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,

                                            color: selected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          item.fullAddress,

                                          style: TextStyle(
                                            color: selected
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: selected ? Colors.white70 : const Color(0xff6E6AF8),
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      final result = await Get.toNamed(
                                        AppRoutes.editAddressScreen,
                                        arguments: item,
                                      );
                                      if (result == true) {
                                        controller.getAddressList();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),

                Obx(() {
                  if (controller.selectedId.value == -1) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Note: Saving will set this address as default.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),

                        gradient: const LinearGradient(
                          colors: [Color(0xff6E6AF8), Color(0xff58B6FF)],
                        ),
                      ),

                      child: Obx(() {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6B67F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  controller.saveAndGoBack();
                                },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      }),
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
}
