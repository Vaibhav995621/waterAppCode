import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/bottel_model/botle_model.dart';

class OrderScheduleController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  // Bottle data passed from BookWaterScreen
  var bottleData = Rxn<BottleData>();
  var waterbottleid = "3".obs;
  var orderquantity = "1".obs;
  var unitprice = "8".obs;
  var addressid = 0.obs;

  var isLoading = false.obs;

  // Subscription type: 'Daily', 'Weekly', 'Custom'
  var selectedType = 'Daily'.obs;

  // Dates
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  // Subscription Duration
  var selectedDuration = '7 Days'.obs;
  final List<String> durations = [
    '7 Days',
    '15 Days',
    '1 Month (30 Days)',
    '2 Months (60 Days)',
    '3 Months (90 Days)'
  ];

  // Days of delivery (Weekly)
  final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  var selectedDays = <String>{}.obs;

  // Custom delivery dates (Custom 1-31)
  var selectedCustomDates = <int>{}.obs;

  // Selected tab for product info
  var selectedDetailTab = 0.obs; // 0: Description, 1: Instructions, 2: Additional Info

  // Quantity per order/delivery
  var cartItemCount = 1.obs;

  // Payment settings
  var paymentmode = "1".obs;
  var paymentstatus = 1.obs;
  var status = 1.obs;

  @override
  void onInit() {
    super.onInit();
    initDataFromArguments();
    fetchDefaultAddress();
  }

  void initDataFromArguments() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['bottle'] != null && args['bottle'] is BottleData) {
        bottleData.value = args['bottle'] as BottleData;
        waterbottleid.value = bottleData.value!.id.toString();
        if (bottleData.value!.discountprice != null) {
          unitprice.value = bottleData.value!.discountprice.toString();
        }
      }
      if (args['waterbottleid'] != null) {
        waterbottleid.value = args['waterbottleid'].toString();
      }
      if (args['orderquantity'] != null) {
        orderquantity.value = args['orderquantity'].toString();
        cartItemCount.value = int.tryParse(orderquantity.value) ?? 1;
      }
      if (args['unitprice'] != null) {
        unitprice.value = args['unitprice'].toString();
      }
      if (args['addressid'] != null && args['addressid'] != 0) {
        addressid.value = int.tryParse(args['addressid'].toString()) ?? 0;
      }
    }
  }

  Future<void> fetchDefaultAddress() async {
    if (addressid.value != 0) return;
    try {
      final response = await _repo.getAddressList(customerId: AppSession.userId);
      if (response.statusCode == "200" && response.data.isNotEmpty) {
        final defaultAddr = response.data.firstWhereOrNull((e) => e.isDefault == 1);
        if (defaultAddr != null && defaultAddr.id != null) {
          addressid.value = defaultAddr.id!;
        } else if (response.data.first.id != null) {
          addressid.value = response.data.first.id!;
        }
      }
    } catch (e) {
      debugPrint("Error fetching default address: $e");
    }
  }

  int getDurationDays() {
    String dur = selectedDuration.value;
    if (dur.contains('7')) return 7;
    if (dur.contains('15')) return 15;
    if (dur.contains('60')) return 60;
    if (dur.contains('90')) return 90;
    return 30; // default for 1 Month
  }

  void updateEndDateBasedOnDuration() {
    if (startDate.value != null) {
      int days = getDurationDays();
      endDate.value = startDate.value!.add(Duration(days: days - 1));
    }
  }

  void setSubscriptionType(String type) {
    selectedType.value = type;
  }

  void toggleDay(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
    selectedDays.refresh();
  }

  void toggleCustomDate(int dateNum) {
    if (selectedCustomDates.contains(dateNum)) {
      selectedCustomDates.remove(dateNum);
    } else {
      selectedCustomDates.add(dateNum);
    }
    selectedCustomDates.refresh();
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
    updateEndDateBasedOnDuration();
  }

  void setEndDate(DateTime date) {
    if (startDate.value != null && date.isBefore(startDate.value!)) {
      AppSnackbar.error("End date cannot be before start date.");
      return;
    }
    endDate.value = date;
  }

  void updateDuration(String newDuration) {
    selectedDuration.value = newDuration;
    updateEndDateBasedOnDuration();
  }

  int calculateTotalQuantity() {
    if (startDate.value == null || endDate.value == null) return 0;

    int totalDeliveryDays = 0;
    DateTime current = DateTime(startDate.value!.year, startDate.value!.month, startDate.value!.day);
    DateTime end = DateTime(endDate.value!.year, endDate.value!.month, endDate.value!.day);
    final DateFormat dayFormatter = DateFormat('EEE');

    while (!current.isAfter(end)) {
      if (selectedType.value == 'Daily') {
        totalDeliveryDays++;
      } else if (selectedType.value == 'Weekly') {
        String dayName = dayFormatter.format(current);
        if (selectedDays.contains(dayName)) {
          totalDeliveryDays++;
        }
      } else if (selectedType.value == 'Custom') {
        if (selectedCustomDates.contains(current.day)) {
          totalDeliveryDays++;
        }
      }
      current = current.add(const Duration(days: 1));
    }

    return totalDeliveryDays * cartItemCount.value;
  }

  double calculateTotalAmount() {
    int totalQty = calculateTotalQuantity();
    double price = double.tryParse(unitprice.value) ?? 0.0;
    return totalQty * price;
  }

  Future<void> saveSchedule() async {
    if (startDate.value == null) {
      AppSnackbar.error("Please select a start date.");
      return;
    }
    if (endDate.value == null) {
      AppSnackbar.error("Please select an end date.");
      return;
    }
    if (selectedType.value == 'Weekly' && selectedDays.isEmpty) {
      AppSnackbar.error("Please select at least one day of delivery.");
      return;
    }
    if (selectedType.value == 'Custom' && selectedCustomDates.isEmpty) {
      AppSnackbar.error("Please select at least one delivery date.");
      return;
    }

    int subTypeInt = 1;
    String subTypeValue = "";
    if (selectedType.value == 'Weekly') {
      subTypeInt = 2;
      subTypeValue = selectedDays.join(',');
    } else if (selectedType.value == 'Custom') {
      subTypeInt = 3;
      subTypeValue = selectedCustomDates.join(',');
    } else {
      subTypeInt = 1;
      subTypeValue = "";
    }

    int totalQty = calculateTotalQuantity();
    if (totalQty == 0) {
      AppSnackbar.error("No delivery days match your selection in the selected date range.");
      return;
    }

    double price = double.tryParse(unitprice.value) ?? 0.0;
    double totalAmt = totalQty * price;

    int custId = int.tryParse(AppSession.userId) ?? 3;

    final body = {
      "customerid": custId,
      "waterbottleid": waterbottleid.value.isNotEmpty ? waterbottleid.value : "3",
      "orderquantity": cartItemCount.value.toString(),
      "unitprice": unitprice.value.isNotEmpty ? unitprice.value : "8",
      "totalquantity": totalQty.toString(),
      "totalamount": totalAmt,
      "subscriptiontype": subTypeInt,
      "substypevalue": subTypeValue,
      "startdate": DateFormat('yyyy-MM-dd').format(startDate.value!),
      "enddate": DateFormat('yyyy-MM-dd').format(endDate.value!),
      "addressid": addressid.value > 0 ? addressid.value : 3,
      "paymentmode": paymentmode.value,
      "paymentstatus": paymentstatus.value,
      "status": status.value,
      "subscriptionduration": getDurationDays(),
    };

    try {
      isLoading.value = true;
      final response = await _repo.saveSchedule(body);
      isLoading.value = false;

      String statusCode = response['status_code']?.toString() ?? response['status']?.toString() ?? '200';
      String message = response['message']?.toString() ?? 'Schedule saved successfully!';

      if (statusCode == '200' || statusCode == '1' || response['success'] == true) {
        AppSnackbar.success(message);
        Get.back();
      } else {
        AppSnackbar.error(message);
      }
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    }
  }

  void addToCart() {
    saveSchedule();
  }
}
