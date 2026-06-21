import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message) {
    _show(
      title: "Success",
      message: message,
      color: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static void error(String message) {
    _show(
      title: "Error",
      message: message,
      color: Colors.red,
      icon: Icons.error,
    );
  }

  static void warning(String message) {
    _show(
      title: "Warning",
      message: message,
      color: Colors.orange,
      icon: Icons.warning,
    );
  }

  static void info(String message) {
    _show(
      title: "Info",
      message: message,
      color: Colors.blue,
      icon: Icons.info,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {

    // prevent giant exception text
    final safeMessage =
    message.length > 120
        ? "${message.substring(0, 120)}..."
        : message;

    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      safeMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      maxWidth: Get.width * .9,

      icon: Icon(
        icon,
        color: Colors.white,
      ),

      messageText: Text(
        safeMessage,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),

      duration: const Duration(seconds: 3),
    );
  }
}