import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class OrdersController extends GetxController {
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
  }

  Future<bool> getCustomerActiveOrder() async {
    try {
      isLoading.value = true;
      activeOrders.value = [];
      final data = await _repo.getActiveOrderList(AppSession.userId);

      /// ❌ API Error
      if (data.statusCode == "201" && data.message != "No Data Found") {
        AppSnackbar.error(data.message);
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        activeOrders.assignAll(data.data);

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
      historyOrders.value = [];
      final data = await _repo.getOrderHistoryList(AppSession.userId);

      /// ❌ API Error
      if (data.statusCode == "201") {
        AppSnackbar.error(data.message);
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




  /// ✅ Status Color
  Color getStatusColor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'paid':
      case 'success':
      case 'completed':
      case '1':
        return Colors.green;
      case 'failed':
      case 'declined':
      case 'cancelled':
      case 'canceled':
      case '2':
        return Colors.red;
      case 'pending':
      case 'unpaid':
      case 'processing':
      case '0':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  /// ✅ Date Format
  String formatDate(DateTime date, String time) {
    return "${DateFormat('dd MMM, yyyy').format(date)} | $time";
  }

  /// Groups orders by deliverydate (dd MMM yyyy), sorted newest-first.
  Map<String, List<Order>> groupOrdersByDate(List<Order> orderList) {
    final Map<String, List<Order>> grouped = {};
    final DateFormat fmt = DateFormat('dd MMM yyyy');

    for (final order in orderList) {
      final key = fmt.format(order.deliverydate);
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