// --- Controller ---
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:zourney/app/models/Admin/admin_order_list/admin_order_model.dart';

import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';

class DeliveryOrderListController extends GetxController {
  /// 🔁 Tab state: 0 = Fast Delivery, 1 = Active Orders, 2 = Delivered Orders, 3 = Cancelled Orders
  RxInt selectedTabIndex = 0.obs;

  /// ⏰ Slot Filter: "All Slots" or specific slot string (e.g. "6:00 AM - 9:00 AM", "⚡ Quick Delivery")
  RxString selectedSlot = "All Slots".obs;

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

  /// ⚡ Fast/Quick Delivery Orders (from active orders)
  List<Order> get fastOrders => activeOrders
      .where((o) =>
          o.quickDelivery == 1 ||
          (double.tryParse(o.quickdeliverycharge) ?? 0) > 0)
      .toList();

  /// Raw orders for current tab without slot filter applied
  List<Order> get currentRawOrders {
    switch (selectedTabIndex.value) {
      case 0:
        return fastOrders;
      case 1:
        return activeOrders;
      case 2:
        return deliveredOrders;
      case 3:
        return cancelledOrders;
      default:
        return fastOrders;
    }
  }

  /// Filtered orders based on selected slot
  List<Order> get currentOrders {
    final raw = currentRawOrders;
    if (selectedSlot.value.isEmpty ||
        selectedSlot.value == "All" ||
        selectedSlot.value == "All Slots") {
      return raw;
    }

    final sel = selectedSlot.value.trim().toLowerCase();
    if (sel.contains("quick") || sel.contains("fast")) {
      return raw
          .where((o) =>
              o.quickDelivery == 1 ||
              (double.tryParse(o.quickdeliverycharge) ?? 0) > 0)
          .toList();
    }

    return raw
        .where((o) => o.deliverytime.trim().toLowerCase() == sel)
        .toList();
  }

  /// Available slots across all tabs for the dropdown filter
  List<String> get availableSlots {
    final List<String> slots = ["All Slots", "⚡ Quick Delivery"];
    const standard = [
      "6:00 AM - 9:00 AM",
      "9:00 AM - 12:00 PM",
      "12:00 PM - 3:00 PM",
      "3:00 PM - 6:00 PM",
      "6:00 PM - 9:00 PM",
      "9:00 PM - 12:00 AM",
    ];
    for (final s in standard) {
      if (!slots.contains(s)) {
        slots.add(s);
      }
    }
    // Also include any unique slots found across all tabs
    final allOrders = [...activeOrders, ...deliveredOrders, ...cancelledOrders, ...historyOrders];
    for (final o in allOrders) {
      final t = o.deliverytime.trim();
      if (t.isNotEmpty && !slots.contains(t)) {
        slots.add(t);
      }
    }
    return slots;
  }

  void selectSlot(String slot) {
    selectedSlot.value = slot;
    final lower = slot.toLowerCase();
    if (lower.contains("quick") || lower.contains("fast")) {
      if (selectedTabIndex.value != 0) {
        changeTab(0);
      }
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    isActiveSelected.value = (index == 0 || index == 1);
    // Slot filter persists across all tabs

    if (index == 0 || index == 1) {
      getCustomerActiveOrder();
    } else if (index == 2) {
      getCustomerHistoryOrder();
    } else if (index == 3) {
      getDeliveryCancelOrderList();
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
      getDeliveryCancelOrderList(),
    ]);
  }

  Future<void> refreshCurrentTab() async {
    if (selectedTabIndex.value == 0 || selectedTabIndex.value == 1) {
      await getCustomerActiveOrder();
    } else if (selectedTabIndex.value == 2) {
      await getCustomerHistoryOrder();
    } else if (selectedTabIndex.value == 3) {
      await getDeliveryCancelOrderList();
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

  Future<bool> getDeliveryCancelOrderList() async {
    try {
      isLoading.value = true;

      final data = await _repo.getDeliveryCancelOrderList(AppSession.userId);

      /// ❌ API Error
      if (data.statusCode == "201") {
        cancelledOrders.clear();
        return false;
      }

      /// ✅ Success
      if (data.statusCode == "200") {
        final list = List<Order>.from(data.data);
        sortOrdersSlotWise(list);
        cancelledOrders.assignAll(list);
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

  /// Groups orders by date (dd-MMM-yyyy) -> then separately by Slot Time (e.g. "6:00 AM - 9:00 AM", "⚡ Quick Delivery").
  Map<String, Map<String, List<Order>>> groupOrdersByDateAndSlot(List<Order> orderList) {
    final Map<String, Map<String, List<Order>>> grouped = {};
    final DateFormat fmt = DateFormat('dd-MMM-yyyy');

    for (final order in orderList) {
      final date = order.deliverydate.year > 2000 ? order.deliverydate : order.cdate;
      final dateKey = fmt.format(date);

      String slotKey;
      if (order.quickDelivery == 1 || (double.tryParse(order.quickdeliverycharge) ?? 0) > 0) {
        slotKey = "⚡ Quick Delivery";
      } else if (order.deliverytime.trim().isNotEmpty) {
        slotKey = order.deliverytime.trim();
      } else {
        slotKey = "Standard Delivery / Anytime";
      }

      grouped.putIfAbsent(dateKey, () => {});
      grouped[dateKey]!.putIfAbsent(slotKey, () => []).add(order);
    }

    // Sort Date Keys descending (newest first)
    final sortedDateKeys = grouped.keys.toList()
      ..sort((a, b) {
        try {
          final da = fmt.parse(a);
          final db = fmt.parse(b);
          return db.compareTo(da);
        } catch (_) {
          return 0;
        }
      });

    final Map<String, Map<String, List<Order>>> result = {};
    for (final dKey in sortedDateKeys) {
      final slotMap = grouped[dKey]!;
      final sortedSlots = slotMap.keys.toList()
        ..sort((a, b) {
          if (a.contains("Quick Delivery")) return -1;
          if (b.contains("Quick Delivery")) return 1;
          final sa = getSlotStartMinutes(a);
          final sb = getSlotStartMinutes(b);
          return sa.compareTo(sb);
        });

      final Map<String, List<Order>> sortedSlotMap = {};
      for (final sKey in sortedSlots) {
        final orders = slotMap[sKey]!;
        orders.sort((a, b) => b.id.compareTo(a.id));
        sortedSlotMap[sKey] = orders;
      }
      result[dKey] = sortedSlotMap;
    }

    return result;
  }
}