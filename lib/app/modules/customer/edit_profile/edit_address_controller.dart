import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:zourney/app/app_session/app_session.dart';
import 'package:zourney/app/models/address_model/addresss_model.dart';
import '../../../models/register_model/state_list_model.dart';
import '../../../models/register_model/district_list_model.dart';
import '../../../models/register_model/subdivision_list_model.dart';
import '../../../models/register_model/register_sector_list_model.dart';
import '../../../models/register_model/register_locality_list_model.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';

class EditAddressController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final AuthRepository _repo = AuthRepository();

  final addressController = TextEditingController();
  final houseNoController = TextEditingController();
  final floorNumberController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();

  RxBool isLiftAvailable = false.obs;
  Rxn<File> selectedImage = Rxn<File>();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      AppSnackbar.error("Failed to pick image: $e");
    }
  }

  // Dropdown lists and reactive selections
  RxList<StateData> states = <StateData>[].obs;
  RxBool isStateLoading = false.obs;
  Rxn<StateData> selectedState = Rxn<StateData>();

  RxList<DistrictData> districts = <DistrictData>[].obs;
  RxBool isDistrictLoading = false.obs;
  Rxn<DistrictData> selectedDistrict = Rxn<DistrictData>();

  RxList<SubdivisionData> subdivisions = <SubdivisionData>[].obs;
  RxBool isSubdivisionLoading = false.obs;
  Rxn<SubdivisionData> selectedSubdivision = Rxn<SubdivisionData>();

  RxList<RegisterSectorData> sectors = <RegisterSectorData>[].obs;
  RxBool isSectorLoading = false.obs;
  Rxn<RegisterSectorData> selectedSector = Rxn<RegisterSectorData>();

  RxList<RegisterLocalityData> localities = <RegisterLocalityData>[].obs;
  RxBool isLocalityLoading = false.obs;
  Rxn<RegisterLocalityData> selectedLocality = Rxn<RegisterLocalityData>();

  RxBool isLoading = false.obs;

  late AddressData? addressData;

  @override
  void onInit() {
    super.onInit();
    addressData = Get.arguments as AddressData?;
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await fetchStates();
    if (addressData != null) {
      await setData();
    }
  }

  Future<void> setData() async {
    addressController.text = addressData?.fullAddress ?? "";
    landmarkController.text = addressData?.landmark ?? "";
    pinCodeController.text = addressData?.pincode ?? "";
    floorNumberController.text =
        (addressData?.floornumber ?? 0) > 0 ? addressData!.floornumber.toString() : "";
    isLiftAvailable.value = addressData?.isLiftAvailable == 1;

    final displayHouse = addressData?.houseFlatFloorNo != null &&
            addressData!.houseFlatFloorNo!.isNotEmpty
        ? addressData!.houseFlatFloorNo!
        : addressData?.housenumber ?? "";

    houseNoController.text = displayHouse;

    // 1. Find and select State
    if (addressData?.stateid != null || addressData?.state != null) {
      final state = states.firstWhereOrNull(
        (s) =>
            s.id == addressData?.stateid ||
            s.statename.toLowerCase() == addressData?.state.toLowerCase(),
      );
      if (state != null) {
        selectedState.value = state;
        stateController.text = state.statename;
        await fetchDistricts(state.id.toString());

        // 2. Find and select District
        if (addressData?.districtid != null || addressData?.city != null) {
          final district = districts.firstWhereOrNull(
            (d) =>
                d.id == addressData?.districtid ||
                d.districtname.toLowerCase() == addressData?.city.toLowerCase(),
          );
          if (district != null) {
            selectedDistrict.value = district;
            cityController.text = district.districtname;
            await fetchSubdivisions(
                state.id.toString(), district.id.toString());

            // 3. Find and select Subdivision
            if (addressData?.subdivisionid != null ||
                addressData?.subdivisionname != null) {
              final subdivision = subdivisions.firstWhereOrNull(
                (sub) =>
                    sub.id == addressData?.subdivisionid ||
                    sub.subdivisionname.toLowerCase() ==
                        addressData?.subdivisionname?.toLowerCase(),
              );
              if (subdivision != null) {
                selectedSubdivision.value = subdivision;
                pinCodeController.text = subdivision.pincode;
                await fetchSectors(state.id.toString(), district.id.toString(),
                    subdivision.id.toString());

                // 4. Find and select Sector
                if (addressData?.sectorid != null) {
                  final sector = sectors.firstWhereOrNull(
                    (sec) => sec.id == addressData?.sectorid,
                  );
                  if (sector != null) {
                    selectedSector.value = sector;
                    await fetchLocalities(
                        state.id.toString(),
                        district.id.toString(),
                        subdivision.id.toString(),
                        sector.id.toString());

                    // 5. Find and select Locality
                    if (addressData?.localityid != null ||
                        addressData?.societyGaliBlockNo != null ||
                        addressData?.societyname != null) {
                      final targetLocalityName =
                          (addressData?.societyGaliBlockNo?.isNotEmpty ?? false)
                              ? addressData?.societyGaliBlockNo
                              : addressData?.societyname;
                      final locality = localities.firstWhereOrNull(
                        (loc) =>
                            loc.id == addressData?.localityid ||
                            loc.localityname.toLowerCase() ==
                                targetLocalityName?.toLowerCase(),
                      );
                      if (locality != null) {
                        selectedLocality.value = locality;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
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
      pinCodeController.clear();
      fetchDistricts(state.id.toString());
    } else {
      stateController.clear();
      cityController.clear();
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
      pinCodeController.clear();
      final stateId = selectedState.value?.id.toString();
      if (stateId != null) {
        fetchSubdivisions(stateId, district.id.toString());
      }
    } else {
      cityController.clear();
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
      final stateId = selectedState.value?.id.toString();
      final districtId = selectedDistrict.value?.id.toString();
      if (stateId != null && districtId != null) {
        fetchSectors(stateId, districtId, subdivision.id.toString());
      }
    } else {
      pinCodeController.clear();
    }
  }

  void onSectorSelected(RegisterSectorData? sector) {
    selectedSector.value = sector;
    selectedLocality.value = null;
    localities.clear();

    if (sector != null) {
      final stateId = selectedState.value?.id.toString();
      final districtId = selectedDistrict.value?.id.toString();
      final subdivisionId = selectedSubdivision.value?.id.toString();
      if (stateId != null && districtId != null && subdivisionId != null) {
        fetchLocalities(
            stateId, districtId, subdivisionId, sector.id.toString());
      }
    }
  }

  void onLocalitySelected(RegisterLocalityData? locality) {
    selectedLocality.value = locality;
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

  Future<void> fetchSectors(
      String stateId, String districtId, String subdivisionId) async {
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

  Future<void> fetchLocalities(String stateId, String districtId,
      String subdivisionId, String sectorId) async {
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

  Future<void> addAddress() async {
    if (!formKey.currentState!.validate()) return;
    Map<String, dynamic> profileData = {
      "customerid": AppSession.userId,
      "userid": AppSession.userId,
      "fulladdress": addressController.text,
      "house_flat_floor_no": houseNoController.text,
      "floornumber": floorNumberController.text.trim().isEmpty
          ? 0
          : int.parse(floorNumberController.text.trim()),
      "is_lift_available": isLiftAvailable.value ? 1 : 0,
      "society_gali_block_no": selectedLocality.value?.localityname ?? "",
      "localityid": selectedLocality.value?.id.toString() ?? "",
      "sectornumber": selectedSector.value?.sectororvillagename ?? "",
      "sectorid": selectedSector.value?.id.toString() ?? "",
      "landmark": landmarkController.text,
      "stateid": selectedState.value?.id.toString() ?? "",
      "districtid": selectedDistrict.value?.id.toString() ?? "",
      "subdivisionid": selectedSubdivision.value?.id.toString() ?? "",
      "subdivisionname": selectedSubdivision.value?.subdivisionname ?? "",
      "city": cityController.text,
      "state": stateController.text,
      "pincode": pinCodeController.text,
      "status": "active",
      "is_default_address": "0",
    };

    try {
      isLoading.value = true;

      final res = await _repo.addAddress(body: profileData);

      /// ✅ Handle API-level failure
      if (res.statusCode == '201') {
        AppSnackbar.error(res.message);
      }

      /// ✅ Navigation
      if (res.statusCode == "200") {
        if (selectedImage.value != null && res.data != null) {
          try {
            await _repo.uploadAddressPhoto(
              addressId: res.data!.id.toString(),
              customerId: AppSession.userId,
              image: selectedImage.value!,
            );
          } catch (e) {
            AppSnackbar.error("Address created, but photo upload failed");
          }
        }
        Get.back(result: true);
      }
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress() async {
    if (!formKey.currentState!.validate()) return;

    Map<String, dynamic> updateData = {
      "id": addressData?.id.toString() ?? "",
      "userid": addressData?.userid.toString() ?? AppSession.userId,
      "fulladdress": addressController.text,
      "house_flat_floor_no": houseNoController.text,
      "floornumber": floorNumberController.text.trim().isEmpty
          ? (addressData?.floornumber ?? 0)
          : int.parse(floorNumberController.text.trim()),
      "is_lift_available": isLiftAvailable.value ? 1 : 0,
      "society_gali_block_no": selectedLocality.value?.localityname ??
          addressData?.societyGaliBlockNo ??
          addressData?.societyname ??
          "",
      "localityid": selectedLocality.value?.id.toString() ??
          addressData?.localityid?.toString() ??
          "",
      "sectornumber": selectedSector.value?.sectororvillagename ?? "NA",
      "sectorid": selectedSector.value?.id.toString() ??
          addressData?.sectorid?.toString() ??
          "",
      "landmark": landmarkController.text,
      "stateid": selectedState.value?.id.toString() ??
          addressData?.stateid?.toString() ??
          "",
      "districtid": selectedDistrict.value?.id.toString() ??
          addressData?.districtid?.toString() ??
          "",
      "subdivisionid": selectedSubdivision.value?.id.toString() ??
          addressData?.subdivisionid?.toString() ??
          "",
      "subdivisionname": selectedSubdivision.value?.subdivisionname ??
          addressData?.subdivisionname ??
          "",
      "city": cityController.text,
      "state": stateController.text,
      "pincode": pinCodeController.text,
      "status": "active",
      "is_default_address": addressData?.isDefault.toString() ?? "0",
    };

    try {
      isLoading.value = true;

      final res = await _repo.updateAddress(body: updateData);

      /// ✅ Handle API-level failure
      if (res.statusCode == '201') {
        AppSnackbar.error(res.message);
      }

      /// ✅ Navigation
      if (res.statusCode == "200") {
        if (selectedImage.value != null) {
          try {
            await _repo.uploadAddressPhoto(
              addressId: addressData!.id.toString(),
              customerId: addressData!.userid.toString(),
              image: selectedImage.value!,
            );
          } catch (e) {
            AppSnackbar.error("Address updated, but photo upload failed");
          }
        }
        Get.back(result: true);
      }
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");
      AppSnackbar.error(message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    houseNoController.dispose();
    floorNumberController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    super.onClose();
  }
}