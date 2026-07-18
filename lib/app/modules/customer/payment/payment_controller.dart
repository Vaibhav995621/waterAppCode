import 'package:get/get.dart';
import 'package:zourney/app/modules/customer/select_address/select_address_controller.dart';
import 'package:zourney/utlis/progress_hud/app_snackbar.dart';
import 'package:zourney/app/modules/customer/wallet/wallet_controller.dart';

import '../../../app_session/app_session.dart';

class PaymentController extends GetxController {
  late int waterBottleId;
  late String price;
  late int quantity;
  late DateTime deliveryDate;
  late String deliveryTime;
  late int plantype;

  // Selected payment method: 'cod', 'pay_now' or 'wallet'
  final selectedMethod = 'cod'.obs;

  late SelectAddressController addressController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments is Map ? Get.arguments : {};
    waterBottleId = args["waterbottleid"] ?? 0;
    price = args["price"] ?? "0";
    quantity = args["quantity"] ?? 0;
    deliveryDate = args["deliverydate"] is DateTime
        ? args["deliverydate"]
        : DateTime.now();
    deliveryTime = args["deliverytime"] ?? "";
    plantype = args["plantype"] ?? 0;

    // Retrieve or initialize SelectAddressController
    addressController = Get.put(SelectAddressController());

    if (isSubscriptionOrder) {
      selectedMethod.value = 'subscription';
    }
  }

  bool get isSubscriptionOrder => plantype != 0 && AppSession.planType == plantype;

  // Get wallet balance
  double get walletBalance {
    try {
      final walletController = Get.put(WalletController());
      return walletController.walletBalance;
    } catch (e) {
      return 0.0;
    }
  }

  void selectPaymentMethod(String method) {
    selectedMethod.value = method;
  }

  Future<void> processPayment() async {
    if (addressController.selectedId.value == -1) {
      AppSnackbar.error("Please select a delivery address.");
      return;
    }

    final isCod = selectedMethod.value == 'cod';
    final isWallet = selectedMethod.value == 'wallet';

    if (isWallet) {
      final orderAmount = double.tryParse(price) ?? 0.0;
      if (walletBalance < orderAmount) {
        AppSnackbar.error(
            "Insufficient wallet balance. Please add money to your wallet or choose another payment method.");
        return;
      }
    }

    int paymentMode = 1;
    if (selectedMethod.value == 'cod') {
      paymentMode = 1;
    } else if (selectedMethod.value == 'subscription') {
      paymentMode = 2;
    } else if (selectedMethod.value == 'wallet') {
      paymentMode = 4;
    } else {
      paymentMode = 3;
    }

    addressController.isPaymentLoading.value = true;
    try {
      final success = await addressController.addOrder(
        waterBottleId.toString(),
        price,
        quantity.toString(),
        deliveryDate,
        deliveryTime,
        addressController.selectedId.value.toString(),
        paymentMode.toString(),
        plantype,
        isCod: isCod,
        isWallet: isWallet,
      );

      if (success && isWallet) {
        try {
          final walletController = Get.put(WalletController());
          walletController.sessionAddedAmount.value -=
              double.tryParse(price) ?? 0.0;
        } catch (_) {}
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      addressController.isPaymentLoading.value = false;
    }
  }
}