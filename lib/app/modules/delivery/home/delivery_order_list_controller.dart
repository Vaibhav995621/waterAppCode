// --- Controller ---
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:zourney/app/models/Admin/admin_order_list/admin_order_model.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';

class DeliveryOrderListController extends GetxController {
  /// 🔁 Toggle state
  RxBool isActiveSelected = true.obs;

  final AuthRepository _repo = AuthRepository();

  /// ✅ API Order Lists
  RxList<Order> activeOrders = <Order>[].obs;
  RxList<Order> historyOrders = <Order>[].obs;

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
  Color getStatusColor(String status) {
    switch (status) {
      case 'Failed':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  /// ✅ Date Format (DD-MMM-YYYY hh:mm a)
  String formatDate(DateTime date) {
    return DateFormat('dd-MMM-yyyy hh:mm a').format(date);
  }

  /// Groups orders by cdate (dd-MMM-yyyy), sorted newest-first.
  Map<String, List<Order>> groupOrdersByDate(List<Order> orderList) {
    final Map<String, List<Order>> grouped = {};
    final DateFormat fmt = DateFormat('dd-MMM-yyyy');

    for (final order in orderList) {
      final key = fmt.format(order.cdate);
      grouped.putIfAbsent(key, () => []).add(order);
    }

    // Sort keys by date descending (newest first)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final da = fmt.parse(a);
        final db = fmt.parse(b);
        return db.compareTo(da);
      });

    return Map.fromEntries(
      sortedKeys.map((k) => MapEntry(k, grouped[k]!)),
    );
  }
}