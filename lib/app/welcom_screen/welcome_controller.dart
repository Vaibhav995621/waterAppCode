import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/routes/app_routes.dart';

class WelcomeController extends GetxController {
  final PageController pageController = PageController();

  RxInt currentIndex = 0.obs;

  final List<Map<String, String>> pages = [
    {
      "title": "Crystal-clear water bottle with water splashes.",
      "image": "assets/images/1.png",
      "button": "Next",
    },
    {
      "title": "Pure Water, Delivered Daily.",
      "image": "assets/images/2.png",
      "button": "Next",
    },
    {
      "title": "Fresh, safe drinking water delivered to your doorstep whenever you need it.",
      "image": "assets/images/3.png",
      "button": "Let’s get started!",
    },
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < pages.length - 1) {
      if (!pageController.hasClients) return;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void skip() {
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}