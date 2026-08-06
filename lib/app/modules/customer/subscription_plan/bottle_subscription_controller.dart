import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/subcription_model/subcription_model.dart';

class BottleSubscriptionController extends GetxController {
  final selectedPlan = 0.obs;
  final selectedFloor = 0.obs;
  final isLiftAvailable = false.obs;
  final double floorPricePerBottle = 3.0;

  final AuthRepository _repo = AuthRepository();
  RxList<SubscriptionData> subscriptionList =
      <SubscriptionData>[].obs;

  late Razorpay razorpay;
  RxBool isLoading = false.obs;
  RxBool isLoadingPayment = false.obs;

  double getBasePrice(SubscriptionData plan) {
    return double.tryParse(plan.price) ?? 0.0;
  }

  double getFloorCharge(SubscriptionData plan) {
    if (isLiftAvailable.value) {
      return 0.0;
    }
    return selectedFloor.value * plan.bottlequantity * floorPricePerBottle;
  }

  double getTotalPrice(SubscriptionData plan) {
    return getBasePrice(plan) + getFloorCharge(plan);
  }

  @override
  void onInit() {
    super.onInit();
    getSubscribePlanList();
    getDefaultAddressFloor();
    razorpay = Razorpay();
    razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );
    razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handlePaymentError,
    );
    razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );
  }

  Future<void> getDefaultAddressFloor() async {
    try {
      final response =
          await _repo.getAddressList(customerId: AppSession.userId);
      if (response.statusCode == "200" && response.data.isNotEmpty) {
        final defaultAddress = response.data.firstWhereOrNull(
          (e) => e.isDefault == 1,
        );
        if (defaultAddress != null) {
          selectedFloor.value = defaultAddress.floornumber;
          isLiftAvailable.value = defaultAddress.isLiftAvailable == 1;
        } else {
          final first = response.data.first;
          selectedFloor.value = first.floornumber;
          isLiftAvailable.value = first.isLiftAvailable == 1;
        }
      }
    } catch (_) {
      // Fallback: selectedFloor remains 0
    }
  }

  void makePayment(double paymentAmount) {
    try {
      isLoadingPayment.value = true;

      var options = {
        'key': 'rzp_test_SrUuMWoExaIWgc',
        'amount': paymentAmount * 100,
        'name': 'Water Delivery',
        'description':
        'Water Bottle Order',
        'prefill': {
          'contact': '7503781220',
          'email': 'test@gmail.com'
        },
        'theme': {
          'color': '#0D47A1'
        },
        'method': {
          'upi': true,
          'card': true,
          'wallet': true,
          'netbanking': true
        }
      };

      razorpay.open(options);
    } catch (e) {
      isLoadingPayment.value = false;

      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse response) {
    isLoadingPayment.value = false;
    Get.snackbar(
      "Success",
      "Payment Success",
    );
    print(response.paymentId);
    if ((response.paymentId ?? '').isNotEmpty && subscriptionList.isNotEmpty) {
      final selected = subscriptionList[selectedPlan.value];
      final totalPaid = getTotalPrice(selected).toStringAsFixed(2);
      buySubscribePlan(
        totalPaid,
        response.paymentId ?? '',
        selected.id.toString(),
      );
    } else {
      AppSnackbar.error(
        'Something went wrong',
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isLoadingPayment.value = false;
    Get.snackbar(
      "Failed",
      response.message ??
          "Payment failed",
    );
  }


  void _handleExternalWallet(
      ExternalWalletResponse response) {
    Get.snackbar(
      "Wallet",
      response.walletName ?? "",
    );
  }


  Future<bool> getSubscribePlanList() async {
    try {
      isLoading.value = true;

      final response =
      await _repo.getSubscriptionList();
      isLoading.value = false;

      if (response.statusCode == "201") {
        AppSnackbar.error(response.message);
        return false;
      }

      if (response.statusCode == "200") {
        isLoading.value = false;
        subscriptionList.assignAll(
            response.data);
      }

      return true;

    } catch (e) {
      isLoading.value = false;

      AppSnackbar.error(
        e.toString().replaceAll(
          "Exception: ",
          "",
        ),
      );
      return false;

    } finally {
      isLoading.value = false;
    }
  }





  Future<bool> buySubscribePlan(
      String totalAmount,
      String transId,
      String subscriptionId
      ) async {
    try {
      isLoading.value = true;
      final response =
      await _repo.buySubscription(totalAmount,transId, subscriptionId,"2");
      isLoading.value = false;
      if (response.statusCode == "201") {
        AppSnackbar.error(response.message);
        return false;
      }
      if (response.statusCode == "200") {
        isLoading.value = false;
        Get.toNamed(
          AppRoutes.paymentSuccess,
          arguments: {
            "amount": totalAmount,
            "type": "subscription_purchase",
          },
        );
      }
      return true;
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.error(
        e.toString().replaceAll(
          "Exception: ",
          "",
        ),
      );
      return false;

    } finally {
      isLoading.value = false;
    }
  }

}
