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
        final list = List<Order>.from(data.data);
        sortOrdersSlotWise(list);
        activeOrders.assignAll(list);

        /// Example History Filter
        final historyList = data.data.where((e) => e.status == 3).toList();
        sortOrdersSlotWise(historyList);
        historyOrders.assignAll(historyList);
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
        final list = List<Order>.from(data.data);
        sortOrdersSlotWise(list);
        historyOrders.assignAll(list);
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

  /// Extracts start minutes from slot string for slot-wise sorting (e.g., "6:00 AM - 9:00 AM" -> 360).
  int getSlotStartMinutes(String slot) {
    if (slot.trim().isEmpty) return 999999;

    try {
      final parts = slot.split('-');
      final startPart = parts.first.trim().toUpperCase();

      final isPM = startPart.contains('PM');
      final isAM = startPart.contains('AM');

      final timeOnly = startPart.replaceAll('AM', '').replaceAll('PM', '').trim();
      final timeComponents = timeOnly.split(':');
      if (timeComponents.isEmpty) return 999999;

      int hour = int.tryParse(timeComponents[0].trim()) ?? 0;
      int minute = timeComponents.length > 1
          ? (int.tryParse(timeComponents[1].trim()) ?? 0)
          : 0;

      if (isPM && hour < 12) {
        hour += 12;
      } else if (isAM && hour == 12) {
        hour = 0;
      }

      return hour * 60 + minute;
    } catch (_) {
      return 999999;
    }
  }

  /// Sorts a list of orders by date (descending) and then slot-wise (ascending).
  void sortOrdersSlotWise(List<Order> list) {
    list.sort((a, b) {
      final dateA = a.deliverydate.year > 2000 ? a.deliverydate : a.cdate;
      final dateB = b.deliverydate.year > 2000 ? b.deliverydate : b.cdate;

      final dayA = DateTime(dateA.year, dateA.month, dateA.day);
      final dayB = DateTime(dateB.year, dateB.month, dateB.day);

      final dateComp = dayB.compareTo(dayA);
      if (dateComp != 0) return dateComp;

      final slotA = getSlotStartMinutes(a.deliverytime);
      final slotB = getSlotStartMinutes(b.deliverytime);
      if (slotA != slotB) return slotA.compareTo(slotB);

      return b.id.compareTo(a.id);
    });
  }

  /// Groups orders by date (dd-MMM-yyyy), sorted newest-first, and sorted slot-wise inside each date.
  Map<String, List<Order>> groupOrdersByDate(List<Order> orderList) {
    final Map<String, List<Order>> grouped = {};
    final DateFormat fmt = DateFormat('dd-MMM-yyyy');

    for (final order in orderList) {
      final date = order.deliverydate.year > 2000 ? order.deliverydate : order.cdate;
      final key = fmt.format(date);
      grouped.putIfAbsent(key, () => []).add(order);
    }

    // Sort keys by date descending (newest first)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        try {
          final da = fmt.parse(a);
          final db = fmt.parse(b);
          return db.compareTo(da);
        } catch (_) {
          return 0;
        }
      });

    // Sort orders within each date group slot-wise (earliest slot first)
    final Map<String, List<Order>> result = {};
    for (final k in sortedKeys) {
      final list = grouped[k]!;
      list.sort((a, b) {
        final slotA = getSlotStartMinutes(a.deliverytime);
        final slotB = getSlotStartMinutes(b.deliverytime);
        if (slotA != slotB) {
          return slotA.compareTo(slotB);
        }
        return b.id.compareTo(a.id);
      });
      result[k] = list;
    }

    return result;
  }
}