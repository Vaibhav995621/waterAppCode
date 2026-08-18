import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class AdminOrderListController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  RxBool isLoading = false.obs;
  RxString activeTab = 'Assigned'.obs;

  /// Multi Selection
  RxBool isSelectionMode = false.obs;
  RxList<Order> selectedOrders = <Order>[].obs;

  Rxn<AdminOrderListModel> orderResponse = Rxn<AdminOrderListModel>();
  RxList<Order> orders = <Order>[].obs;

  /// Sector & Search Filter State
  RxList<String> sectors = <String>[].obs;
  RxString selectedSector = ''.obs;
  RxBool isSectorsLoading = false.obs;
  RxString orderSearchQuery = ''.obs;

  bool isSelected(Order order) {
    return selectedOrders.any((e) => e.id == order.id);
  }

  void toggleSelection(Order order) {
    final index = selectedOrders.indexWhere(
          (e) => e.id == order.id,
    );

    if (index >= 0) {
      selectedOrders.removeAt(index);
    } else {
      selectedOrders.add(order);
    }

    if (selectedOrders.isEmpty) {
      isSelectionMode.value = false;
    } else {
      isSelectionMode.value = true;
    }

    selectedOrders.refresh();
  }

  void clearSelection() {
    selectedOrders.clear();
    isSelectionMode.value = false;
  }

  void selectAll() {
    selectedOrders.assignAll(orders);
    isSelectionMode.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    getOrdersApi("" );
  }

  void changeTab(String tab) {
    activeTab.value = tab;
    clearSelection();
    filterOrders();
  }

  Future<void> getOrdersApi(String sector) async {
    try {
      isLoading.value = true;

      final response = await _repo.adminOrderApi(sector);

      if (response.statusCode == '200') {

        orders.clear();
        orderResponse.value = response;
        filterOrders();
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      isLoading.value = false;
    }
  }
  void filterOrders() {
    final data = orderResponse.value?.data;

    if (data == null) {
      orders.clear();
      return;
    }

    List<Order> tempOrders = [];

    switch (activeTab.value) {
      case 'Assigned':
        tempOrders.addAll(data.assignedOrders);
        break;

      case 'Delivered':
        tempOrders.addAll(data.deliveredOrders);
        break;

      case 'Cancelled':
        tempOrders.addAll(data.cancelledOrders);
        break;

      default:
        tempOrders.addAll(data.allOrders);
        break;
    }

    // Apply Sector Filter
    if (selectedSector.value.isNotEmpty) {
      tempOrders = tempOrders.where((order) {
        return order.customerDetails.address.sectornumber.toString().toLowerCase() ==
            selectedSector.value.toLowerCase();
      }).toList();
    }

    // Apply Local Search Filter (Name, Phone, Address, Sector, Order number)
    if (orderSearchQuery.value.isNotEmpty) {
      final query = orderSearchQuery.value.trim().toLowerCase();
      tempOrders = tempOrders.where((order) {
        final orderNo = order.ordernumber.toString().toLowerCase();
        final name = order.customerDetails.fullname.toString().toLowerCase();
        final mobile = order.customerDetails.mobile.toString().toLowerCase();
        
        final addr = order.customerDetails.address;
        final sector = addr.sectornumber.toString().toLowerCase();
        final fulladdress = addr.fulladdress.toString().toLowerCase();
        final societyname = addr.societyname.toString().toLowerCase();
        final housenumber = addr.housenumber.toString().toLowerCase();
        final flatnumber = addr.flatnumber.toString().toLowerCase();
        final city = addr.city.toString().toLowerCase();

        return orderNo.contains(query) ||
            name.contains(query) ||
            mobile.contains(query) ||
            sector.contains(query) ||
            fulladdress.contains(query) ||
            societyname.contains(query) ||
            housenumber.contains(query) ||
            flatnumber.contains(query) ||
            city.contains(query);
      }).toList();
    }

    orders.assignAll(tempOrders);
  }

  Future<void> getSectorsApi() async {
    try {
      isSectorsLoading.value = true;
      final response = await _repo.getSectorList();
      if (response.statusCode == '200') {
        sectors.assignAll(response.data);
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      isSectorsLoading.value = false;
    }
  }



  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade100;

      case 'assigned':
        return Colors.blue.shade100;

      case 'out for delivery':
        return Colors.purple.shade100;

      case 'delivered':
        return Colors.green.shade100;

      default:
        return Colors.grey.shade200;
    }
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