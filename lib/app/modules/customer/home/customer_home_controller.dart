import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/profile_model/profile_model.dart';
import '../../../models/Admin/admin_order_list/admin_order_model.dart';

class CustomerHomeController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  Rxn<ProfileModel> profile =
  Rxn<ProfileModel>();

  var isLoadingOrders = false.obs;
  RxList<Order> activeOrders = <Order>[].obs;

  var userName = "".obs;
  var currentPlan = "".obs;
  var nextDeliveryDate = "".obs;
  var orderId = "".obs;
  var orderStatus = "0".obs;
  var bottleType = "".obs;
  var quantity = "".obs;
  var deliveryTime = "".obs;


  RxString bottles = "".obs;
  RxInt originalPrice = 0.obs;
  RxInt discountedPrice = 0.obs;

  double get perBottlePrice =>
      discountedPrice.value / 15;
  int get savedAmount =>
      originalPrice.value - discountedPrice.value;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProfile();
    getActiveOrders();
  }

  void bookWater() {
    // API call or navigation
    Get.toNamed(AppRoutes.bookingWaterScreen);

    //Get.snackbar("Booked", "Water booked successfully");
  }

  void viewAllOrders() {
    Get.snackbar("Orders", "Opening all orders");
  }


  Future<bool> getProfile() async {
    try {
      var custId = AppSession.userId;
      final user =
      await _repo.getUserProfile(custId);

      if (user.statusCode == '201') {
        AppSnackbar.error(user.message);
        return false;
      }

      if (user.statusCode == '200') {
        AppSession.saveUser(
          userId: AppSession.userId,
          token: '',
          image: user.data.photo,
          name: user.data.fullname ?? '',
          role: user.data.role,
          planType: user.data.plandetail.id
        );
        profile.value = user;
      }
      update();
      return true;
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
      return false;
    } finally {
    }
  }

  Future<void> getActiveOrders() async {
    try {
      isLoadingOrders.value = true;
      var custId = AppSession.userId;
      final response = await _repo.getActiveOrderList(custId);
      if (response.statusCode == '200') {
        activeOrders.assignAll(response.data);
      }
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      isLoadingOrders.value = false;
    }
  }

  /// Status Text
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

  /// Status Color
  Color getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Date Format
  String formatDate(DateTime date, String time) {
    return "${DateFormat('dd MMM, yyyy').format(date)} | $time";
  }
}