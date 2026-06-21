import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends GetxController {
  late Razorpay razorpay;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

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

  void makePayment() {
    try {
      isLoading.value = true;

      var options = {
        'key': 'rzp_test_SrUuMWoExaIWgc',

        'amount': 500 * 100,

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
      isLoading.value = false;

      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse response) {

    isLoading.value = false;

    Get.snackbar(
      "Success",
      "Payment Success",
    );

    print(response.paymentId);

    // call payment verification API
  }

  void _handlePaymentError(
      PaymentFailureResponse response) {

    isLoading.value = false;

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

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }
}