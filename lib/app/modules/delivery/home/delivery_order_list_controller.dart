// --- Controller ---
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/order_list_model/order_list.dart';

class DeliveryOrderListController extends GetxController {
  /// 🔁 Toggle state
  RxBool isActiveSelected = true.obs;

  final AuthRepository _repo = AuthRepository();

  /// ✅ API Order Lists
  RxList<OrderData> activeOrders = <OrderData>[].obs;
  RxList<OrderData> historyOrders = <OrderData>[].obs;

  /// ✅ Loader
  RxBool isLoading = false.obs;

  void toggleTab(bool value) {
    isActiveSelected.value = value;
    if(value == true){
      getCustomerActiveOrder();
    } else{
      getCustomerHistoryOrder();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCustomerActiveOrder();
    getCustomerHistoryOrder();

  }

  Future<bool> getCustomerActiveOrder() async {
    try {
      isLoading.value = true;

      final data = await _repo.getDeliveryActiveOrderList(AppSession.userId);

      /// ❌ API Error
      if (data.statusCode == "201") {
      //  AppSnackbar.error(data.message);
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        activeOrders.assignAll(data.data);

        /// Example History Filter
        historyOrders.assignAll(
          data.data.where((e) => e.status == 3).toList(),
        );
      }

      return true;
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> getCustomerHistoryOrder() async {
    try {
      isLoading.value = true;

      final data = await _repo.getDeliveryHistoryList(AppSession.userId);

      /// ❌ API Error
      if (data.statusCode == "201") {
      //  AppSnackbar.error(data.message);
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        historyOrders.assignAll(data.data);

      }

      return true;
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  /// ✅ Status Text
  String getStatusText(int status) {
    switch (status) {
      case 1:
        return "Pending";
      case 2:
        return "Out for Delivery";
      case 3:
        return "Delivered";
      default:
        return "Unknown";
    }
  }

  /// ✅ Status Color
  Color getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// ✅ Date Format
  String formatDate(DateTime date, String time) {
    return "${DateFormat('dd MMM, yyyy').format(date)} | $time";
  }
}