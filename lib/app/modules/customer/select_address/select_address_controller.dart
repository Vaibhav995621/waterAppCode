import 'dart:core';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zourney/app/models/address_model/addresss_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';

class SelectAddressController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  RxInt selectedId = (-1).obs;
  Rx<AddressData?> selectedAddress = Rx<AddressData?>(null);
  RxList<AddressData> addressList = <AddressData>[].obs;
  RxBool isLoading = false.obs;
  RxBool isPaymentLoading = false.obs;

  late Map<String, dynamic> addOrderMap;
   String orderId = "";

  @override
  void onInit() {
    super.onInit();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getAddressList();
  }

  void selectAddress(int id) {
    selectedId.value = id;

    selectedAddress.value = addressList.firstWhere((e) => e.id == id);
  }

  Future<bool> getAddressList() async {
    try {
      isLoading.value = true;

      final data = await _repo.getAddressList(customerId: AppSession.userId);
      isLoading.value = false;

      if (data.statusCode == "201") {
        AppSnackbar.error(data.message);

        return false;
      }

      if (data.statusCode == "200") {
        addressList.assignAll(data.data);

        final defaultAddress = addressList.firstWhereOrNull(
          (e) => e.isDefault == 1,
        );

        if (defaultAddress != null) {
          selectedId.value = defaultAddress.id!;

          selectedAddress.value = defaultAddress;
        } else if (addressList.isNotEmpty) {
          selectedId.value = addressList.first.id!;

          selectedAddress.value = addressList.first;
        }
      }

      return true;
    } catch (e) {
      isLoading.value = false;

      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  late Razorpay razorpay;

  void makePayment(double price) {
    try {
      isPaymentLoading.value = true;
      var options = {
        'key': 'rzp_test_SrUuMWoExaIWgc',
        'amount': price * 100,
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
      isPaymentLoading.value = false;

      Get.snackbar("Error", e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    isPaymentLoading.value = false;

    Get.snackbar("Success", "Payment Success");

    print(response.paymentId);
    orderPayment(response.paymentId.toString(),"1");

    // call payment verification API
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isPaymentLoading.value = false;
    orderPayment('',"2");
    Get.snackbar("Failed", response.message ?? "Payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Wallet", response.walletName ?? "");
  }

  Future<bool> addOrder(
    String waterBottleId,
    String price,
    String quantity,
    DateTime deliveryDate,
    String deliveryTime,
    String addressId,
      int planType
  ) async {
    addOrderMap = {
      "customerid": AppSession.userId,
      "waterbottleid": waterBottleId,
      "price": price,
      "quantity": quantity,
      "deliverydate": DateFormat('yyyy-MM-dd').format(deliveryDate),
      "deliverytime": deliveryTime,
      "addressid": addressId,
    };
    try {
      isLoading.value = true;
      final response = await _repo.addOrder(body: addOrderMap);

      /// ERROR
      if (response.statusCode == "201") {
        AppSnackbar.error(response.message ?? "Something went wrong");
        return false;
      }

      /// SUCCESS
      if (response.statusCode == "200") {
        orderId = response.data.id.toString();
        if(AppSession.planType == planType) {
          Get.toNamed(
            AppRoutes.paymentSuccess,
            arguments: {"amount": addOrderMap["price"].toString()},
          );
        }else{
        makePayment(double.tryParse(price) ?? 0.0);
        }
        return true;
      }
      AppSnackbar.error(response.message ?? "Failed to load bottles");

      return false;
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> orderPayment(String transId, String status) async {
    try {
      isLoading.value = true;
      final response = await _repo.orderPayment(
        addOrderMap["price"].toString(),
        transId,
        orderId,
      );
      isLoading.value = false;
      if (response.statusCode == "201") {
        AppSnackbar.error(response.message);
        return false;
      }
      if (response.statusCode == "200") {
        isLoading.value = false;
        if(status == "1") {
          Get.toNamed(
            AppRoutes.paymentSuccess,
            arguments: {"amount": addOrderMap["price"].toString()},
          );
        }else{
          AppSnackbar.error('Payment fail');
          Get.offAllNamed(AppRoutes.mainNavigation);
        }
      }
      return true;
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
