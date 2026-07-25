import 'package:get/get.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';

class OrderScheduleController extends GetxController {
  // Subscription type: 'Daily', 'Weekly', 'Custom'
  var selectedType = 'Daily'.obs;

  // Dates (nullable to remove already selected default values)
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  // Subscription Duration
  var selectedDuration = '15 Days'.obs;
  final List<String> durations = [
    '7 Days',
    '15 Days',
    '1 Month (30 Days)',
    '2 Months (60 Days)',
    '3 Months (90 Days)'
  ];

  // Days of delivery (Weekly) - empty by default so user picks
  final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  var selectedDays = <String>{}.obs;

  // Custom delivery dates (Custom 1-31) - empty by default so user picks
  var selectedCustomDates = <int>{}.obs;

  // Selected tab for product info
  var selectedDetailTab = 0.obs; // 0: Description, 1: Instructions, 2: Additional Info

  // Cart item count
  var cartItemCount = 1.obs;

  @override
  void onInit() {
    super.onInit();
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
      endDate.value = startDate.value!.add(Duration(days: days));
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
    // Auto change End Date based on selected duration when Start Date is selected
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
    // Auto change End Date when Duration changes
    updateEndDateBasedOnDuration();
  }

  void addToCart() {
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

    String summary = "";
    if (selectedType.value == 'Daily') {
      summary = "Daily Subscription (${getDurationDays()} days) added to cart!";
    } else if (selectedType.value == 'Weekly') {
      summary = "Weekly Subscription (${selectedDays.join(', ')}) added to cart!";
    } else {
      summary = "Custom Subscription (${selectedCustomDates.length} dates) added to cart!";
    }
    cartItemCount.value += 1;
    AppSnackbar.success(summary);
  }
}
