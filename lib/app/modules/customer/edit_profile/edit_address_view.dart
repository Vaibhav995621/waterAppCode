import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_address_controller.dart';
import '../../../models/register_model/state_list_model.dart';
import '../../../models/register_model/district_list_model.dart';
import '../../../models/register_model/subdivision_list_model.dart';
import '../../../models/register_model/register_sector_list_model.dart';
import '../../../models/register_model/register_locality_list_model.dart';

class EditAddressView extends GetView<EditAddressController> {
  const EditAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xff1A2C56)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.addressData == null ? "Add Address" : "Edit Address",
          style: const TextStyle(
            color: Color(0xff1A2C56),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: const Color(0xffF4F4F4),
          child: Obx(() {
            return SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : (controller.addressData == null
                        ? controller.addAddress
                        : controller.updateAddress),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xff6C63FF).withOpacity(0.4),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        controller.addressData == null
                            ? "Add Address"
                            : "Update Address",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          }),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field("Address", controller.addressController),
                _stateDropdownField(),
                _cityDropdownField(),
                _districtDropdownField(),
                _sectorDropdownField(),
                _localityDropdownField(),
                _field("PinCode", controller.pinCodeController,
                    keyboardType: TextInputType.number),
                _field("Flat No / House No / Floor", controller.houseNoController),
                _field("Floor Number", controller.floorNumberController,
                    keyboardType: TextInputType.number, required: false),
                _liftAvailableToggleField(),
                _field("Landmark", controller.landmarkController),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Lift Available Toggle Switch Field
  Widget _liftAvailableToggleField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.elevator_rounded,
                    color: Color(0xff6C63FF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Is Lift Available?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1A2C56),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Enable if the building has an active lift",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Obx(
              () => Switch.adaptive(
                value: controller.isLiftAvailable.value,
                activeColor: const Color(0xff6C63FF),
                onChanged: (val) {
                  controller.isLiftAvailable.value = val;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔤 Common TextField
  Widget _field(
    String label,
    TextEditingController textController, {
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff1A2C56),
              ),
            ),
          ),

          /// TextField
          TextFormField(
            controller: textController,
            keyboardType: keyboardType,
            validator: (value) {
              if (required && (value == null || value.trim().isEmpty)) {
                return "Please enter $label";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Enter $label",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xff6C63FF),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stateDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "State",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff1A2C56),
              ),
            ),
          ),
          Obx(() {
            if (controller.isStateLoading.value) {
              return const SizedBox(
                height: 55,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return DropdownButtonFormField<StateData>(
              value: controller.selectedState.value,
              hint: const Text("Select State"),
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xff6C63FF),
                    width: 1.5,
                  ),
                ),
              ),
              items: controller.states.map((state) {
                return DropdownMenuItem<StateData>(
                  value: state,
                  child: Text(state.statename),
                );
              }).toList(),
              validator: (value) {
                if (value == null) return "State is required";
                return null;
              },
              onChanged: (StateData? newValue) {
                controller.onStateSelected(newValue);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _cityDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "City",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff1A2C56),
              ),
            ),
          ),
          Obx(() {
            if (controller.isDistrictLoading.value) {
              return const SizedBox(
                height: 55,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return DropdownButtonFormField<DistrictData>(
              key: ValueKey(controller.selectedState.value?.id),
              value: controller.selectedDistrict.value,
              hint: const Text("Select City"),
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xff6C63FF),
                    width: 1.5,
                  ),
                ),
              ),
              items: controller.districts.map((district) {
                return DropdownMenuItem<DistrictData>(
                  value: district,
                  child: Text(district.districtname),
                );
              }).toList(),
              validator: (value) {
                if (value == null) return "City is required";
                return null;
              },
              onChanged: (DistrictData? newValue) {
                controller.onDistrictSelected(newValue);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _districtDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "District",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff1A2C56),
              ),
            ),
          ),
          Obx(() {
            if (controller.isSubdivisionLoading.value) {
              return const SizedBox(
                height: 55,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return DropdownButtonFormField<SubdivisionData>(
              key: ValueKey(controller.selectedDistrict.value?.id),
              value: controller.selectedSubdivision.value,
              hint: const Text("Select District"),
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xff6C63FF),
                    width: 1.5,
                  ),
                ),
              ),
              items: controller.subdivisions.map((subdivision) {
                return DropdownMenuItem<SubdivisionData>(
                  value: subdivision,
                  child: Text(subdivision.subdivisionname),
                );
              }).toList(),
              validator: (value) {
                if (value == null) return "District is required";
                return null;
              },
              onChanged: (SubdivisionData? newValue) {
                controller.onSubdivisionSelected(newValue);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _sectorDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "Sector/Locality",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff1A2C56),
              ),
            ),
          ),
          Obx(() {
            if (controller.isSectorLoading.value) {
              return const SizedBox(
                height: 55,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return DropdownButtonFormField<RegisterSectorData>(
              key: ValueKey(controller.selectedSubdivision.value?.id),
              value: controller.selectedSector.value,
              hint: const Text("Select Sector/Locality"),
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xff6C63FF),
                    width: 1.5,
                  ),
                ),
              ),
              items: controller.sectors.map((sector) {
                return DropdownMenuItem<RegisterSectorData>(
                  value: sector,
                  child: Text(sector.sectororvillagename),
                );
              }).toList(),
              validator: (value) {
                if (value == null) return "Sector/Locality is required";
                return null;
              },
              onChanged: (RegisterSectorData? newValue) {
                controller.onSectorSelected(newValue);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _localityDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "Street Name / Block Name / Gali No",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff1A2C56),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLocalityLoading.value) {
              return const SizedBox(
                height: 55,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return DropdownButtonFormField<RegisterLocalityData>(
              key: ValueKey(controller.selectedSector.value?.id),
              value: controller.selectedLocality.value,
              hint: const Text("Select Street Name/ Block Name / Gali No"),
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xff6C63FF),
                    width: 1.5,
                  ),
                ),
              ),
              items: controller.localities.map((locality) {
                return DropdownMenuItem<RegisterLocalityData>(
                  value: locality,
                  child: Text(locality.localityname),
                );
              }).toList(),
              validator: (value) {
                if (value == null) return "Street/Block/Gali is required";
                return null;
              },
              onChanged: (RegisterLocalityData? newValue) {
                controller.onLocalitySelected(newValue);
              },
            );
          }),
        ],
      ),
    );
  }
}