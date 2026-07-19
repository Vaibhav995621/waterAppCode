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

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: const Color(0xffF4F7FC),
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
                  backgroundColor: const Color(0xff6B67F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
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

      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    _field("Address", controller.addressController),

                    _stateDropdownField(),

                    _cityDropdownField(),

                    _districtDropdownField(),

                    _sectorDropdownField(),

                    _localityDropdownField(),

                    _field("PinCode", controller.pinCodeController),

                    _field("House No / Falt NO", controller.houseNoController),

                    _field("Landmark", controller.landmarkController),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Your top circles remain unchanged
        ],
      ),
    );
  }

  /// 🔤 Common TextField
  Widget _field(
      String label,
      TextEditingController controller,
      ) {
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
              ),
            ),
          ),

          /// TextField
          TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter $label";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Enter $label",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.blue,
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
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Colors.blue,
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
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Colors.blue,
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
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Colors.blue,
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
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Colors.blue,
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
              "Street Name/ Block Name / Gali No",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
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
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Colors.blue,
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