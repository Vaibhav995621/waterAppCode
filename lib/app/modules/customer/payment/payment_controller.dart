import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zourney/app/modules/customer/select_address/select_address_controller.dart';
import 'package:zourney/routes/app_routes.dart';
import 'package:zourney/utlis/network/repositories/auth_repository.dart';
import 'package:zourney/utlis/progress_hud/app_snackbar.dart';
import 'package:zourney/app/modules/customer/wallet/wallet_controller.dart';

import '../../../app_session/app_session.dart';

class PaymentController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  late int waterBottleId;
  late String price;
  late int quantity;
  late DateTime deliveryDate;
  late String deliveryTime;
  late int plantype;
  int floor = 0;
  int floorCharges = 0;
  String onlinePaymentMode= "1";

  // Schedule payment data
  bool isSchedulePayment = false;
  Map<String, dynamic> scheduleBody = {};

  late Razorpay razorpay;
  late Map<String, dynamic> addOrderMap;
  String orderId = "";

  // Selected payment method: 'cod', 'pay_now' or 'wallet'
  final selectedMethod = 'cod'.obs;
  int paymentMode = 0;

  late SelectAddressController addressController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments is Map ? Get.arguments : {};

    // Detect if this is a schedule payment
    isSchedulePayment = args["isSchedulePayment"] == true;
    scheduleBody = args["scheduleBody"] is Map<String, dynamic>
        ? Map<String, dynamic>.from(args["scheduleBody"])
        : <String, dynamic>{};

    waterBottleId = int.tryParse(args["waterbottleid"]?.toString() ?? '') ??
        (args["waterbottleid"] as int? ?? 0);
    price = args["price"]?.toString() ?? "0";
    quantity = args["quantity"] ?? 0;
    deliveryDate = args["deliverydate"] is DateTime
        ? args["deliverydate"]
        : DateTime.now();
    deliveryTime = args["deliverytime"] ?? "";
    plantype = args["plantype"] ?? 0;
    floor = args["floor"] ?? 0;
    floorCharges = args["floorCharges"] ?? 0;

    // Initialize Razorpay
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Retrieve or initialize SelectAddressController
    addressController = Get.put(SelectAddressController());

    if (isSchedulePayment) {
      selectedMethod.value = 'pay_now';
    } else if (isSubscriptionOrder) {
      selectedMethod.value = 'subscription';
    } else {
      selectedMethod.value = 'cod';
    }
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }

  bool get hasActiveSubscription => AppSession.planType != 0;

  bool get isSubscriptionOrder =>
      plantype != 0 && AppSession.planType == plantype;

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

  void makePayment(double amountPrice) {
    try {
      addressController.isPaymentLoading.value = true;
      var options = {
        'key': 'rzp_test_SrUuMWoExaIWgc',
        'amount': amountPrice * 100,
        'name': 'Water Delivery',
        'description': 'Water Bottle Order',
        'prefill': {'contact': AppSession.name, 'name': AppSession.name},
        'theme': {'color': '#0D47A1'},
        'method': {
          'upi': true,
          'card': true,
          'wallet': true,
          'netbanking': true,
        },
      };
      razorpay.open(options);
    } catch (e) {
      addressController.isPaymentLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    addressController.isPaymentLoading.value = false;
    Get.snackbar("Success", "Payment Success");
    print(response.paymentId);
    if (isSchedulePayment) {
      // For schedule payment: call saveSchedule API with transaction ID
      _processSchedulePayment(response.paymentId.toString(), "1");
    } else {
      orderPayment(response.paymentId.toString(), "1");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    addressController.isPaymentLoading.value = false;
    if (isSchedulePayment) {
      AppSnackbar.error(response.message ?? "Payment failed");
    } else {
      orderPayment('', "2");
      Get.snackbar("Failed", response.message ?? "Payment failed");
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Wallet", response.walletName ?? "");
  }

  Future<bool> orderPayment(String transId, String status) async {
    try {
      addressController.isPaymentLoading.value = true;
      final response = await _repo.orderPayment(
        price,
        transId,
        orderId,
      );
      addressController.isPaymentLoading.value = false;
      if (response.statusCode == "201") {
        AppSnackbar.error(response.message);
        return false;
      }
      try {
        final success = await addOrder(
          waterBottleId.toString(),
          price,
          quantity.toString(),
          deliveryDate,
          deliveryTime,
          addressController.selectedId.value.toString(),
          onlinePaymentMode,
          status,
          transId,
          plantype,
        );
        if (success) {
            if (status == "1") {
              Get.toNamed(
                AppRoutes.paymentSuccess,
                arguments: {"amount": price, "type": "online"},
              );
            } else {
              AppSnackbar.error('Payment failed');
              Get.offAllNamed(AppRoutes.mainNavigation);
            }
        }
      } catch (e) {
        addressController.isPaymentLoading.value = false;
        AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
      }

      return true;
    } catch (e) {
      addressController.isPaymentLoading.value = false;
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      addressController.isPaymentLoading.value = false;
    }
  }

  Future<bool> schedulePayment(Map<String, dynamic> body, {String transId = '', String status = '1'}) async {
    try {
      if (transId.isNotEmpty) {
        body['trans_id'] = transId;
      }
      final response = await _repo.saveSchedule(body);

      String statusCode = response['status_code']?.toString() ?? response['status']?.toString() ?? '200';
      String message = response['message']?.toString() ?? 'Schedule saved successfully!';

      if (statusCode == '200' || statusCode == '1' || response['success'] == true || statusCode == 'true') {
        AppSnackbar.success(message);
        Get.offAllNamed(AppRoutes.mainNavigation);
        return true;
      } else {
        AppSnackbar.error(message);
        return false;
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
      return false;
    }
  }

  /// Called after Razorpay success for schedule payment
  Future<void> _processSchedulePayment(String transId, String status) async {
    try {
      addressController.isPaymentLoading.value = true;
      final body = Map<String, dynamic>.from(scheduleBody);
      body['paymentstatus'] = status == '1' ? 1 : 2;
      await schedulePayment(body, transId: transId, status: status);
    } catch (e) {
      addressController.isPaymentLoading.value = false;
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      addressController.isPaymentLoading.value = false;
    }
  }






  Future<void> processPayment(String paymentStatus) async {
    if (!isSchedulePayment && addressController.selectedId.value == -1) {
      AppSnackbar.error("Please select a delivery address.");
      return;
    }
    final isSubscription = selectedMethod.value == 'subscription';
    final isCod = selectedMethod.value == 'cod';
    final isWallet = selectedMethod.value == 'wallet';
    final isPayNow = selectedMethod.value == 'pay_now';

    // ----- Schedule payment flow -----
    if (isSchedulePayment) {
      if (isPayNow) {
        // Open Razorpay; on success _handlePaymentSuccess → _processSchedulePayment
        makePayment(double.tryParse(price) ?? 0.0);
      } else if (isCod) {
        // COD: call saveSchedule API immediately
        addressController.isPaymentLoading.value = true;
        final body = Map<String, dynamic>.from(scheduleBody);
        body['paymentmode'] = '0';
        body['paymentstatus'] = 0;
        await schedulePayment(body);
        addressController.isPaymentLoading.value = false;
      } else if (isWallet) {
        // Wallet: call saveSchedule API immediately
        addressController.isPaymentLoading.value = true;
        final body = Map<String, dynamic>.from(scheduleBody);
        body['paymentmode'] = '3';
        body['paymentstatus'] = 1;
        await schedulePayment(body);
        addressController.isPaymentLoading.value = false;
      } else {
        makePayment(double.tryParse(price) ?? 0.0);
      }
      return;
    }

    // ----- Normal order payment flow -----
    if (isSubscription) {
      if (!hasActiveSubscription) {
        AppSnackbar.error(
          "No active subscription plan found. Please subscribe to a plan or choose another payment method.",
        );
        return;
      }
    }

    if (isWallet) {
      final orderAmount = double.tryParse(price) ?? 0.0;
      if (walletBalance < orderAmount) {
        AppSnackbar.error(
          "Insufficient wallet balance. Please add money to your wallet or choose another payment method.",
        );
        return;
      }
    }
    if (selectedMethod.value == 'cod') {
      paymentMode = 0;
    } else if (selectedMethod.value == 'subscription') {
      paymentMode = 2;
    } else if (selectedMethod.value == 'wallet') {
      paymentMode = 3;
    } else {
      paymentMode = 1;
    }

    if (paymentMode == 0 ||
        paymentMode == 2 ||
        paymentMode == 3 ||
        paymentMode == 4) {
      addressController.isPaymentLoading.value = true;
      try {
        final success = await addOrder(
          waterBottleId.toString(),
          price,
          quantity.toString(),
          deliveryDate,
          deliveryTime,
          addressController.selectedId.value.toString(),
          paymentMode.toString(),
          paymentStatus,
          '',
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
        addressController.isPaymentLoading.value = false;
        AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
      }
    } else {
      makePayment(double.tryParse(price) ?? 0.0);
    }
  }

  Future<bool> addOrder(
    String waterBottleId,
    String price,
    String quantity,
    DateTime deliveryDate,
    String deliveryTime,
    String addressId,
    String paymentmode,
    String paymentstatus,
    String trans_id,
    int planType, {
    bool isCod = false,
    bool isWallet = false,
  }) async {
    addOrderMap = {
      "customerid": AppSession.userId,
      "waterbottleid": waterBottleId,
      "price": price,
      "quantity": quantity,
      "deliverydate": DateFormat('yyyy-MM-dd').format(deliveryDate),
      "deliverytime": deliveryTime,
      "addressid": addressId,
      "paymentmode": paymentmode,
      "paymentstatus": paymentstatus,
      "trans_id" : trans_id,
      "floor": floor.toString(),
      "floorcharges": floorCharges.toString(),
    };
    try {
      addressController.isPaymentLoading.value = true;
      final response = await _repo.addOrder(body: addOrderMap);

      if (response.statusCode == "201") {
        addressController.isPaymentLoading.value = false;
        AppSnackbar.error(response.message ?? "Something went wrong");
        return false;
      }

      if (response.statusCode == "200") {
        orderId = response.data.id.toString();
        if (AppSession.planType == planType ||
            isCod ||
            isWallet ||
            selectedMethod.value == 'subscription') {
          addressController.isPaymentLoading.value = false;
          Get.toNamed(
            AppRoutes.paymentSuccess,
            arguments: {
              "amount": addOrderMap["price"].toString(),
              "type": isCod ? "cod" : (isWallet ? "wallet" : "subscription"),
            },
          );
        }
        return true;
      }
      addressController.isPaymentLoading.value = false;
      AppSnackbar.error(response.message ?? "Failed to load bottles");

      return false;
    } catch (e) {
      addressController.isPaymentLoading.value = false;
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
      return false;
    }
  }
}
