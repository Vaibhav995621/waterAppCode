import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class AdminOrderListController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  RxBool isLoading = false.obs;
  RxString activeTab = 'Pending'.obs;

  /// Multi Selection
  RxBool isSelectionMode = false.obs;
  RxList<Order> selectedOrders = <Order>[].obs;

  Rxn<AdminOrderListModel> orderResponse = Rxn<AdminOrderListModel>();
  RxList<Order> orders = <Order>[].obs;

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
    getOrdersApi();
  }

  void changeTab(String tab) {
    activeTab.value = tab;
    filterOrders();
  }

  Future<void> getOrdersApi() async {
    try {
      isLoading.value = true;

      final response = await _repo.adminOrderApi();

      if (response.statusCode == '200') {
        orderResponse.value = response;

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

    orders.clear();

    switch (activeTab.value) {
      case 'Pending':
        orders.assignAll(data.pendingOrders);
        break;

      case 'Assigned':
        orders.assignAll(data.assignedOrders);
        break;

      case 'Delivered':
        orders.assignAll(data.deliveredOrders);
        break;

      default:
        orders.assignAll(data.allOrders);
        break;
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
}