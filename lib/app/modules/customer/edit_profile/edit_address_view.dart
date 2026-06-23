
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_address_controller.dart';

class EditAddressView extends GetView<EditAddressController> {
   const EditAddressView({super.key});

  @override
  Widget build(BuildContext context) {

    return   Scaffold(
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
                    const SizedBox(height: 60),

                    _field("Address", controller.addressController),
                    _field("House No", controller.houseNoController),
                    _field("Flat No", controller.flatNoController),
                    _field("Floor Number", controller.floorNoController),
                    _field("Street Name", controller.streetNameController),
                    _field("Society Name", controller.societyNameController),
                    _field("Gali Number", controller.galiNumberController),
                    _field("Sector", controller.sectorController),
                    _field("Landmark", controller.landmarkController),
                    _field("City", controller.cityController),
                    _field("State", controller.stateController),
                    _field("PinCode", controller.pinCodeController),

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

}