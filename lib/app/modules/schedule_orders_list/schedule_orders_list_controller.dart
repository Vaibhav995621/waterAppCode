import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../app_session/app_session.dart';
import '../../models/schedule_model/schedule_list_model.dart';
import '../../../utlis/network/repositories/auth_repository.dart';

class ScheduleOrdersListController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  var isLoading = true.obs;
  var scheduleList = <ScheduleData>[].obs;
  var filteredScheduleList = <ScheduleData>[].obs;
  var searchQuery = ''.obs;
  var selectedTab = 'All'.obs;

  bool get isAdmin => AppSession.role == 3;

  @override
  void onInit() {
    super.onInit();
    fetchScheduleOrders();
  }

  Future<void> fetchScheduleOrders() async {
    isLoading.value = true;
    try {
      ScheduleListModel response;
      if (isAdmin) {
        response = await _repo.getAllScheduleList();
      } else {
        response = await _repo.getScheduleListByCustomerId(AppSession.userId);
      }

      if (response.status) {
        scheduleList.value = response.data;
      } else {
        scheduleList.clear();
      }
      filterSchedules();
    } catch (e) {
      debugPrint("Error fetching schedule orders: $e");
      scheduleList.clear();
      filteredScheduleList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    filterSchedules();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    filterSchedules();
  }

  void filterSchedules() {
    List<ScheduleData> list = List.from(scheduleList);

    // Filter by Tab / Status
    if (selectedTab.value == 'Active') {
      list = list.where((item) => item.status == 1).toList();
    } else if (selectedTab.value == 'Completed') {
      list = list.where((item) => item.status == 2).toList();
    } else if (selectedTab.value == 'Pending') {
      list = list.where((item) => item.status == 0).toList();
    }

    // Filter by search query
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((item) {
        final custName = item.customer?.fullname?.toLowerCase() ?? '';
        final custMobile = item.customer?.mobile?.toLowerCase() ?? '';
        final bottleName = item.waterbottleDetails?.bottlename?.toLowerCase() ?? '';
        final fullAddr = item.address?.fulladdress?.toLowerCase() ?? '';
        final startDate = item.startdate?.toLowerCase() ?? '';
        final endDate = item.enddate?.toLowerCase() ?? '';
        final idStr = item.id.toString();

        return custName.contains(q) ||
            custMobile.contains(q) ||
            bottleName.contains(q) ||
            fullAddr.contains(q) ||
            startDate.contains(q) ||
            endDate.contains(q) ||
            idStr.contains(q);
      }).toList();
    }

    filteredScheduleList.value = list;
  }
}
