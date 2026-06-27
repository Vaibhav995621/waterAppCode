import 'package:get/get.dart';
import 'package:zourney/app/modules/customer/select_address/select_address_controller.dart';
import 'package:zourney/utlis/progress_hud/app_snackbar.dart';

import '../../../app_session/app_session.dart';

class PaymentController extends GetxController {
  late int waterBottleId;
  late String price;
  late int quantity;
  late DateTime deliveryDate;
  late String deliveryTime;
  late int plantype;

  // Selected payment method: 'cod' or 'pay_now'
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

  void selectPaymentMethod(String method) {
    selectedMethod.value = method;
  }

  Future<void> processPayment() async {
    if (addressController.selectedId.value == -1) {
      AppSnackbar.error("Please select a delivery address.");
      return;
    }

    final isCod = selectedMethod.value == 'cod';

    addressController.isPaymentLoading.value = true;
    try {
      await addressController.addOrder(
        waterBottleId.toString(),
        price,
        quantity.toString(),
        deliveryDate,
        deliveryTime,
        addressController.selectedId.value.toString(),
        plantype,
        isCod: isCod,
      );
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      addressController.isPaymentLoading.value = false;
    }
  }
}