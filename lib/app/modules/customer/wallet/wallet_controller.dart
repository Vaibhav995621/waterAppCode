import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zourney/app/app_session/app_session.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utlis/constants/api_endpoints.dart';
import '../../../../utlis/network/api_provider.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../models/payment_model/payment_success_model.dart';
import '../../../models/wallet_model/wallet_model.dart';
import '../home/customer_home_controller.dart';

class WalletController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  var isLoading = false.obs;
  var isPaymentLoading = false.obs;
  var currentWalletAmount = 0.0.obs;
  var sessionAddedAmount = 0.0.obs;

  var transactions = <WalletTransaction>[].obs;
  var totalAdded = 0.0.obs;
  var totalSpent = 0.0.obs;

  double get walletBalance {
    if (currentWalletAmount.value > 0) {
      return currentWalletAmount.value;
    }
    try {
      if (Get.isRegistered<CustomerHomeController>()) {
        final homeController = Get.find<CustomerHomeController>();
        final apiBalance = homeController.profile.value?.data.walletamount ?? 0.0;
        if (apiBalance > 0) return apiBalance.toDouble();
      }
    } catch (_) {}
    return currentWalletAmount.value;
  }

  late Razorpay razorpay;
  double _pendingAmount = 0.0;

  @override
  void onInit() {
    super.onInit();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    loadWalletData();
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }

  Future<void> loadWalletData() async {
    try {
      isLoading.value = true;
      String customerId = AppSession.userId;
      final walletResult = await _repo.getWalletDetails(customerId);
      if (walletResult.statusCode == "200" && walletResult.data != null) {
        currentWalletAmount.value = walletResult.data?.currentWalletAmount ?? 0.0;
        totalSpent.value = walletResult.data?.totalSpendAmount ?? 0.0;
        totalAdded.value = walletResult.data?.totalAddAmount ?? 0.0;

        if (walletResult.data!.transactions.isNotEmpty) {
          final mappedList = walletResult.data!.transactions.map((tx) {
            return WalletTransaction(
              id: tx.id,
              userId: tx.userId,
              totalAmount: tx.totalAmount,
              orderAmount: tx.orderAmount,
              remainAmount: tx.remainAmount,
              title: tx.title,
              subtitle: tx.subtitle,
              amount: tx.amount,
              date: tx.date,
              isCredit: tx.isCredit,
            );
          }).toList();
          transactions.assignAll(mappedList);
          isLoading.value = false;
          return;
        }
      }

      // Fallback to payment history API if wallet transactions list is empty
      final history = await _repo.getPaymentHistory();
      if (history.statusCode == "200") {

        final mappedList = history.data.map((item) {
          final isCredit = item.subscriptionid > 0;
          return WalletTransaction(
            title: isCredit ? "Added Money" : "Order Payment",
            subtitle: isCredit ? "From Payment" : "Order #${item.orderid}",
            amount: double.tryParse(item.totalamount) ?? 0.0,
            date: item.transDate,
            isCredit: isCredit,
          );
        }).toList();
        transactions.assignAll(mappedList);

      }
    } catch (e) {

    } finally {
      isLoading.value = false;
    }
  }



  void addMoneyToWallet(double amount) {
    if (amount <= 0) {
      AppSnackbar.error("Please enter a valid amount");
      return;
    }
    _pendingAmount = amount;
    makePayment(amount);
  }

  void makePayment(double amount) {
    try {
      isPaymentLoading.value = true;
      String userMobile = '7503781220';
      String userEmail = 'test@gmail.com';
      try {
        if (Get.isRegistered<CustomerHomeController>()) {
          final homeController = Get.find<CustomerHomeController>();
          final profileData = homeController.profile.value?.data;
          if (profileData != null) {
            if (profileData.mobile.isNotEmpty) {
              userMobile = profileData.mobile;
            }
            if (profileData.email.isNotEmpty) {
              userEmail = profileData.email;
            }
          }
        }
      } catch (_) {}

      var options = {
        'key': 'rzp_test_SrUuMWoExaIWgc',
        'amount': (amount * 100).toInt(),
        'name': 'Water Delivery',
        'description': 'Add Money to Wallet',
        'prefill': {
          'contact': userMobile,
          'email': userEmail,
        },
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

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    isPaymentLoading.value = false;
    final addedAmountStr = _pendingAmount.toInt().toString();
    String customerId = AppSession.userId;
    if (customerId.isEmpty) {
      customerId = AppSession.userId;
    }

    try {
      final updateRes = await _repo.updateWalletAmount(
        customerId: customerId,
        walletAmount: addedAmountStr,
      );

      if (updateRes.statusCode == "200" && updateRes.data != null) {
        currentWalletAmount.value = updateRes.data!.totalWalletAmount;
        AppSnackbar.success(
          updateRes.message.isNotEmpty
              ? updateRes.message
              : "₹${_pendingAmount.toStringAsFixed(2)} added to wallet successfully!",
        );
      } else {
        currentWalletAmount.value += _pendingAmount;
        AppSnackbar.success("₹${_pendingAmount.toStringAsFixed(2)} added to wallet successfully!");
      }
      saveWalletAmountHistory(addedAmountStr,response.paymentId.toString(),"");
    } catch (e) {
      currentWalletAmount.value += _pendingAmount;
      AppSnackbar.success("₹${_pendingAmount.toStringAsFixed(2)} added to wallet!");
    } finally {
      sessionAddedAmount.value += _pendingAmount;
      _pendingAmount = 0.0;

      if (Get.isRegistered<CustomerHomeController>()) {
        Get.find<CustomerHomeController>().getProfile();
      }
      loadWalletData();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isPaymentLoading.value = false;
    _pendingAmount = 0.0;
    Get.snackbar("Failed", response.message ?? "Payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Wallet", response.walletName ?? "");
  }
  Future<bool> saveWalletAmountHistory(
      String totalAmount,
      String transId,
      String subscriptionId
      ) async {
    try {
      isLoading.value = true;
      final response =
      await _repo.buySubscription(totalAmount,transId, subscriptionId,"3");
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
            "type": "wallet_recharge",
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

class WalletTransaction {
  /// Raw API fields from the transactions array
  final int id;
  final int userId;
  final double totalAmount;
  final double orderAmount;
  final double remainAmount;

  /// Display/computed fields
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final bool isCredit;

  WalletTransaction({
    this.id = 0,
    this.userId = 0,
    this.totalAmount = 0.0,
    this.orderAmount = 0.0,
    this.remainAmount = 0.0,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isCredit,
  });
}
