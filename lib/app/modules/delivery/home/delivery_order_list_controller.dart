// --- Controller ---
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:zourney/app/models/Admin/admin_order_list/admin_order_model.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';

class DeliveryOrderListController extends GetxController {
  /// 🔁 Tab state: 0 = Active Orders, 1 = Delivered Orders, 2 = Cancelled Orders
  RxInt selectedTabIndex = 0.obs;

  /// Backward compatibility for any boolean check
  RxBool isActiveSelected = true.obs;

  final AuthRepository _repo = AuthRepository();

  /// ✅ API Order Lists
  RxList<Order> activeOrders = <Order>[].obs;
  RxList<Order> deliveredOrders = <Order>[].obs;
  RxList<Order> cancelledOrders = <Order>[].obs;
  RxList<Order> historyOrders = <Order>[].obs;

  /// ✅ Loader
  RxBool isLoading = false.obs;

  List<Order> get currentOrders {
    switch (selectedTabIndex.value) {
      case 0:
        return activeOrders;
      case 1:
        return deliveredOrders;
      case 2:
        return cancelledOrders;
      default:
        return activeOrders;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    isActiveSelected.value = (index == 0);
    if (index == 0) {
      getCustomerActiveOrder();
    } else {
      getCustomerHistoryOrder();
    }
  }

  void toggleTab(bool value) {
    changeTab(value ? 0 : 1);
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllOrders();
  }

  Future<void> fetchAllOrders() async {
    await Future.wait([
      getCustomerActiveOrder(),
      getCustomerHistoryOrder(),
    ]);
  }

  Future<void> refreshCurrentTab() async {
    if (selectedTabIndex.value == 0) {
      await getCustomerActiveOrder();
    } else {
      await getCustomerHistoryOrder();
    }
  }

  Future<bool> getCustomerActiveOrder() async {
    try {
      isLoading.value = true;

      final data = await _repo.getDeliveryActiveOrderList(AppSession.userId);

      /// ❌ API Error
      if (data.statusCode == "201") {
        activeOrders.clear();
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        final list = List<Order>.from(data.data);
        sortOrdersSlotWise(list);

        // Filter active orders (only not delivered and not cancelled)
        final activeList = list.where((o) => o.isActive).toList();
        activeOrders.assignAll(activeList);

        // If any delivered orders were in the active API response, keep track of them
        final deliveredFromActive = list.where((o) => o.isDelivered).toList();
        for (final o in deliveredFromActive) {
          if (!deliveredOrders.any((d) => d.id == o.id)) {
            deliveredOrders.add(o);
          }
        }
        if (deliveredFromActive.isNotEmpty) {
          sortOrdersSlotWise(deliveredOrders);
        }

        // If any cancelled orders were in the active API response, keep track of them
        final cancelledFromActive = list.where((o) => o.isCancelled).toList();
        for (final o in cancelledFromActive) {
          if (!cancelledOrders.any((c) => c.id == o.id)) {
            cancelledOrders.add(o);
          }
        }
        if (cancelledFromActive.isNotEmpty) {
          sortOrdersSlotWise(cancelledOrders);
        }
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
        deliveredOrders.clear();
        cancelledOrders.clear();
        historyOrders.clear();
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        final list = List<Order>.from(data.data);
        sortOrdersSlotWise(list);
        historyOrders.assignAll(list);

        // Delivered orders: strictly isDelivered OR (not cancelled and not active)
        final delivered = list.where((o) => o.isDelivered || (!o.isCancelled && !o.isActive)).toList();
        deliveredOrders.assignAll(delivered);

        // Cancelled orders: strictly isCancelled
        final cancelled = list.where((o) => o.isCancelled).toList();
        cancelledOrders.assignAll(cancelled);
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
      case 4:
        return "Cancelled";
      default:
        return "Unknown";
    }
  }

  /// ✅ Status Color
  Color getStatusColor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'failed':
      case 'cancelled':
      case 'canceled':
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