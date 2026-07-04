import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../global_controller/bottomTabBar/navigation_controller.dart';
import '../../../models/Admin/admin_order_details/admin_order_details_model.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';


class AssignDeliveryBoyController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  RxBool isLoading = false.obs;

  Rxn<Order> order = Rxn<Order>();
  final RxList<Order> selectedOrdersList = <Order>[].obs;


  Rxn<DeliveryBoyListModel> deliveryBoyResponse =
  Rxn<DeliveryBoyListModel>();

  RxList<Datum> boys = <Datum>[].obs;
  RxList<Datum> filteredBoys = <Datum>[].obs;

  /// -1 means nothing selected
  RxInt selectedBoyId = (-1).obs;

  final TextEditingController searchController =
  TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is List<Order>) {
        selectedOrdersList.assignAll(Get.arguments as List<Order>);
        if (selectedOrdersList.isNotEmpty) {
          order.value = selectedOrdersList.first;
        }
      } else if (Get.arguments is Order) {
        order.value = Get.arguments as Order;
        selectedOrdersList.add(Get.arguments as Order);
      }
    }
    deliveryBoyListApi();
  }

  void selectBoy(int id) {
    selectedBoyId.value = id;
    debugPrint("Selected Boy Id : $id");
  }

  void searchDeliveryBoy(String query) {
    final search = query.trim().toLowerCase();

    if (search.isEmpty) {
      filteredBoys.assignAll(boys);
      return;
    }

    filteredBoys.assignAll(
      boys.where(
            (item) =>
        item.fullname.toLowerCase().contains(search) ||
            item.mobile.toLowerCase().contains(search) ||
            item.email.toLowerCase().contains(search),
      ),
    );
  }

  Future<void> deliveryBoyListApi() async {
    try {
      isLoading.value = true;

      final response = await _repo.deliveryBoyList();

      if (response.statusCode == '200') {
        deliveryBoyResponse.value = response;

        boys.assignAll(response.data);
        filteredBoys.assignAll(response.data);
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



  Future<void> assignDeliveryBoy(BuildContext context) async {
    print("DEBUG: assignDeliveryBoy called");
    if (selectedBoyId.value == -1) {
      print("DEBUG: selectedBoyId is -1");
      AppSnackbar.error("Please select a delivery boy.");
      return;
    }
    var deliveryBoyId = selectedBoyId.value.toString();
    print("DEBUG: deliveryBoyId is $deliveryBoyId");
    try {
      isLoading.value = true;
      String orderIds = selectedOrdersList
          .map((order) => order.id.toString())
          .join(',');
      print("DEBUG: orderIds is $orderIds");
      print("DEBUG: Calling API repo.assignDeliveryBoy...");
      final response = await _repo.assignDeliveryBoy(orderIds, deliveryBoyId);
      print("DEBUG: Response received. Status code: ${response.statusCode}, Message: ${response.message}");
      if (response.statusCode == '200') {
        AppSnackbar.success("Delivery boy assigned successfully.");
        Get.offAllNamed(AppRoutes.mainNavigation);
      } else {
        print("DEBUG: Status code is not 200: ${response.statusCode}");
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Failed to assign delivery boy",
        );
      }
    } catch (e, stacktrace) {
      print("DEBUG: Error in assignDeliveryBoy: $e");
      print("DEBUG: Stacktrace: $stacktrace");
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      isLoading.value = false;
      print("DEBUG: assignDeliveryBoy finished");
    }
  }

  Datum? get selectedBoy {
    if (selectedBoyId.value == -1) {
      return null;
    }

    try {
      return boys.firstWhere(
            (e) => e.id == selectedBoyId.value,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}