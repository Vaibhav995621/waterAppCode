import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/welcom_screen/welcome_controller.dart';

import '../../utlis/constants/app_colors.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // background slides during swipe — title is per-page content
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.pages.length,
            itemBuilder: (context, index) {
              final page = controller.pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(page["image"]!, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/welcomeShadow.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: bottomInset + 192,
                    child: Text(
                      page["title"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // fixed controls — stay still during swipe
          Positioned(
            bottom: bottomInset + 30,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(controller.pages.length, (dotIndex) {
                      final isActive = controller.currentIndex.value == dotIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 26 : 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: controller.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Obx(
                      () => Text(
                        controller.pages[controller.currentIndex.value]["button"]!,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // fixed height so layout doesn't shift on last page
                Obx(
                  () => SizedBox(
                    height: 24,
                    child: controller.currentIndex.value == controller.pages.length - 1
                        ? null
                        : GestureDetector(
                            onTap: controller.skip,
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
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