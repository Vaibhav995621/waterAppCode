import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utlis/network/repositories/auth_repository.dart';
import '../../../utlis/progress_hud/app_snackbar.dart';
import '../../app_session/app_session.dart';
import '../../global_controller/bottomTabBar/main_navigation_screen.dart';
import '../../models/register_model/state_list_model.dart';
import '../../models/register_model/district_list_model.dart';
import '../../models/register_model/subdivision_list_model.dart';
import '../../models/register_model/register_sector_list_model.dart';
import '../../models/register_model/register_locality_list_model.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final AuthRepository _repo = AuthRepository();
  RxBool isPasswordVisible = false.obs;

  // Text Controllers
  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final houseNoController = TextEditingController();
  final streetController = TextEditingController();
  final societyController = TextEditingController();
  final landmarkController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // State Dropdown
  RxList<StateData> states = <StateData>[].obs;
  RxBool isStateLoading = false.obs;
  Rxn<StateData> selectedState = Rxn<StateData>();

  // District Dropdown
  RxList<DistrictData> districts = <DistrictData>[].obs;
  RxBool isDistrictLoading = false.obs;
  Rxn<DistrictData> selectedDistrict = Rxn<DistrictData>();

  // Subdivision Dropdown
  RxList<SubdivisionData> subdivisions = <SubdivisionData>[].obs;
  RxBool isSubdivisionLoading = false.obs;
  Rxn<SubdivisionData> selectedSubdivision = Rxn<SubdivisionData>();

  // Sector Dropdown
  RxList<RegisterSectorData> sectors = <RegisterSectorData>[].obs;
  RxBool isSectorLoading = false.obs;
  Rxn<RegisterSectorData> selectedSector = Rxn<RegisterSectorData>();

  // Locality Dropdown
  RxList<RegisterLocalityData> localities = <RegisterLocalityData>[].obs;
  RxBool isLocalityLoading = false.obs;
  Rxn<RegisterLocalityData> selectedLocality = Rxn<RegisterLocalityData>();

  // Address Type (Residential / Commercial)
  RxString addressType = "residential".obs;

  // Role selection
  var selectedRole = "User".obs;

  void setRole(String role) {
    selectedRole.value = role;
  }

  @override
  void onInit() {
    super.onInit();
    fetchStates();
  }

  Future<void> fetchStates() async {
    try {
      isStateLoading.value = true;
      final stateList = await _repo.getStateList();
      if (stateList.statusCode == '200') {
        states.assignAll(stateList.data);
      } else {
        AppSnackbar.error(stateList.message);
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isStateLoading.value = false;
    }
  }

  void onStateSelected(StateData? state) {
    selectedState.value = state;
    selectedDistrict.value = null;
    selectedSubdivision.value = null;
    selectedSector.value = null;
    selectedLocality.value = null;
    districts.clear();
    subdivisions.clear();
    sectors.clear();
    localities.clear();

    if (state != null) {
      stateController.text = state.statename;
      cityController.clear();
      societyController.clear();
      streetController.clear();
      pinCodeController.clear();
      fetchDistricts(state.id.toString());
    } else {
      stateController.clear();
      cityController.clear();
      societyController.clear();
      streetController.clear();
      pinCodeController.clear();
    }
  }

  void onDistrictSelected(DistrictData? district) {
    selectedDistrict.value = district;
    selectedSubdivision.value = null;
    selectedSector.value = null;
    selectedLocality.value = null;
    subdivisions.clear();
    sectors.clear();
    localities.clear();

    if (district != null) {
      cityController.text = district.districtname;
      societyController.clear();
      streetController.clear();
      pinCodeController.clear();
      final stateId = selectedState.value?.id.toString();
      if (stateId != null) {
        fetchSubdivisions(stateId, district.id.toString());
      }
    } else {
      cityController.clear();
      societyController.clear();
      streetController.clear();
      pinCodeController.clear();
    }
  }

  void onSubdivisionSelected(SubdivisionData? subdivision) {
    selectedSubdivision.value = subdivision;
    selectedSector.value = null;
    selectedLocality.value = null;
    sectors.clear();
    localities.clear();

    if (subdivision != null) {
      pinCodeController.text = subdivision.pincode;
      societyController.clear();
      streetController.clear();
      final stateId = selectedState.value?.id.toString();
      final districtId = selectedDistrict.value?.id.toString();
      if (stateId != null && districtId != null) {
        fetchSectors(stateId, districtId, subdivision.id.toString());
      }
    } else {
      pinCodeController.clear();
      societyController.clear();
      streetController.clear();
    }
  }

  void onSectorSelected(RegisterSectorData? sector) {
    selectedSector.value = sector;
    selectedLocality.value = null;
    localities.clear();
    streetController.clear();
    societyController.clear();

    if (sector != null) {
      final stateId = selectedState.value?.id.toString();
      final districtId = selectedDistrict.value?.id.toString();
      final subdivisionId = selectedSubdivision.value?.id.toString();
      if (stateId != null && districtId != null && subdivisionId != null) {
        fetchLocalities(stateId, districtId, subdivisionId, sector.id.toString());
      }
    }
  }

  void onLocalitySelected(RegisterLocalityData? locality) {
    selectedLocality.value = locality;
    if (locality != null) {
      streetController.text = locality.localityname;
      societyController.text = locality.localityname;
    } else {
      streetController.clear();
      societyController.clear();
    }
  }

  Future<void> fetchSectors(String stateId, String districtId, String subdivisionId) async {
    try {
      isSectorLoading.value = true;
      final response = await _repo.getSectorsList(
        stateId: stateId,
        districtId: districtId,
        subdivisionId: subdivisionId,
      );
      if (response.statusCode == '200') {
        sectors.assignAll(response.data);
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isSectorLoading.value = false;
    }
  }

  Future<void> fetchLocalities(String stateId, String districtId, String subdivisionId, String sectorId) async {
    try {
      isLocalityLoading.value = true;
      final response = await _repo.getLocalityList(
        stateId: stateId,
        districtId: districtId,
        subdivisionId: subdivisionId,
        sectorsId: sectorId,
      );
      if (response.statusCode == '200') {
        localities.assignAll(response.data);
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLocalityLoading.value = false;
    }
  }

  Future<void> fetchDistricts(String stateId) async {
    try {
      isDistrictLoading.value = true;
      final response = await _repo.getDistrictList(stateId: stateId);
      if (response.statusCode == '200') {
        districts.assignAll(response.data);
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isDistrictLoading.value = false;
    }
  }

  Future<void> fetchSubdivisions(String stateId, String districtId) async {
    try {
      isSubdivisionLoading.value = true;
      final response = await _repo.getSubdivisionList(
        stateId: stateId,
        districtId: districtId,
      );
      if (response.statusCode == '200') {
        subdivisions.assignAll(response.data);
      } else {
        AppSnackbar.error(response.message);
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isSubdivisionLoading.value = false;
    }
  }

  // Validation Methods
  String? validateRequired(String value, String field) {
    if (value.isEmpty) return "$field is required";
    return null;
  }

  String? validateMobile(String value) {
    if (value.isEmpty) return "Mobile number is required";
    if (value.length != 10) return "Enter valid 10 digit number";
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Minimum 6 characters required";
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  // void register() {
  //   if (formKey.currentState!.validate()) {
  //     print("Role: ${selectedRole.value}");
  //     print("Name: ${fullNameController.text}");
  //     print("Mobile: ${mobileController.text}");
  //
  //     Get.snackbar("Success", "Registered Successfully");
  //   }
  // }

  Future<bool> register() async {
    if (formKey.currentState!.validate()) {
      try {
        final user = await _repo.registerApi(
          userName: fullNameController.text.trim().replaceAll(' ', ''),
          fullName: fullNameController.text.isEmpty
              ? ""
              : fullNameController.text,
          fullAddress: addressController.text.isEmpty
              ? ""
              : addressController.text,
          houseNumber: houseNoController.text.trim().isEmpty
              ? ""
              : houseNoController.text.trim(),


          societyName: societyController.text.trim().isEmpty
              ? ""
              : societyController.text,

          landmark: landmarkController.text.trim().isEmpty
              ? ""
              : landmarkController.text.trim(),
          city: cityController.text.trim().isEmpty
              ? ""
              : cityController.text.trim(),

          state: stateController.text.trim().isEmpty
              ? ""
              : stateController.text.trim(),
          photo: '',
          pinCode: pinCodeController.text.trim().isEmpty
              ? ""
              : pinCodeController.text.trim(),
          password: passwordController.text.trim().isEmpty
              ? ""
              : passwordController.text.trim(),

          mobile: mobileController.text.trim().isEmpty
              ? ""
              : mobileController.text.trim(),

          email: '',
          role:  "1",
          userType: addressType.value == "residential" ? "1" : "2",
          stateId: selectedState.value?.id.toString() ?? "",
          districtId: selectedDistrict.value?.id.toString() ?? "",
          subdivisionId: selectedSubdivision.value?.id.toString() ?? "",
          subdivisionName: selectedSubdivision.value?.subdivisionname ?? societyController.text.trim(),
          sectorId: selectedSector.value?.id.toString() ?? "",
          localityId: selectedLocality.value?.id.toString() ?? "",
        );

        /// ✅ Handle API-level failure
        if (user.statusCode == '201') {
          AppSnackbar.error(user.message);
          return false;
        }

        /// ✅ Navigation
        if (user.statusCode == "200") {
          await AppSession.saveUser(
              userId: user.data.id.toString(),
              token: AppSession.fcmToken,
              image: user.data.photo,
              name: user.data.fullname,
              role: user.data.role,
              planType: user.data.plandetail.id
          );
          Get.offAll(() => const MainNavigationScreen());
        }
        return true;
      } catch (e) {
        final message = e.toString().replaceAll("Exception: ", "");
        AppSnackbar.error(message);
        return false;
      } finally {
        // isLoading.value = false;
      }
    }
    return false;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
