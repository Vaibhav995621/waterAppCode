/// edit_address_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/models/address_model/addresss_model.dart';
import 'package:zourney/app/models/profile_model/profile_model.dart';
import 'edit_address_controller.dart';

class EditAddressView extends GetView<EditAddressController> {
   EditAddressView({super.key});
   //final AddressData? addressData = Get.arguments;


  @override
  Widget build(BuildContext context) {
    // if(addressData != null) {
    //   controller.houseNoController.text = addressData?.housenumber ?? '';
    //   controller.flatNoController.text = addressData?.flatnumber ?? '';
    //   controller.houseNoController.text = addressData?.housenumber ?? '';
    //   controller.streetNameController.text = addressData?.galinumber ?? '';
    //   controller.societyNameController.text = addressData?.societyname ?? '';
    //   controller.galiNumberController.text = addressData?.galinumber ?? '';
    //   controller.landmarkController.text = addressData?.landmark ?? '';
    //   controller.cityController.text = addressData?.city ?? '';
    //   controller.stateController.text = addressData?.state ?? '';
    //   controller.pinCodeController.text = addressData?.pincode ?? '';
    // }


    return  Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      body: Stack(
        children: [

          /// Background circles
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                    const EdgeInsets.all(
                        20),

                    child: Form(
                      key:
                      controller.formKey,

                      child: Column(
                        children: [

                          const SizedBox(
                              height: 60),

                          _field(
                            "Address",
                            controller
                                .addressController,
                          ),

                          _field(
                            "House No",
                            controller
                                .houseNoController,
                          ),

                          _field(
                            "Flat No",
                            controller
                                .flatNoController,
                          ),

                          _field(
                            "Street Name",
                            controller
                                .streetNameController,
                          ),

                          _field(
                            "Society Name",
                            controller
                                .societyNameController,
                          ),

                          _field(
                            "Gali Number",
                            controller
                                .galiNumberController,
                          ),

                          _field(
                            "Landmark",
                            controller
                                .landmarkController,
                          ),

                          _field(
                            "City",
                            controller
                                .cityController,
                          ),

                          _field(
                            "State",
                            controller
                                .stateController,
                          ),

                          _field(
                            "PinCode",
                            controller
                                .pinCodeController,
                          ),

                          const SizedBox(
                              height: 25),


                          if(controller.addressData == null)
                            Obx(() {
                              return SizedBox(
                                width: double.infinity,
                                height: 58,

                                child:
                                ElevatedButton(
                                  onPressed:
                                  controller
                                      .isLoading
                                      .value
                                      ? null
                                      : controller
                                      .addAddress,

                                  style:
                                  ElevatedButton
                                      .styleFrom(
                                    elevation:
                                    0,
                                    backgroundColor:
                                    const Color(
                                        0xff6B67F6),

                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          18),
                                    ),
                                  ),

                                  child:
                                  controller
                                      .isLoading
                                      .value
                                      ? const CircularProgressIndicator(
                                    color:
                                    Colors.white,
                                  )
                                      : const Text(
                                    "Update Profile",
                                    style:
                                    TextStyle(
                                      fontSize:
                                      18,
                                      fontWeight:
                                      FontWeight.bold,
                                      color:
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          const SizedBox(
                              height: 30),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: -60,
            left: -60,
            child: GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Container(
                height: 180,
                width: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff62B5F8),
                ),

                child: Stack(
                  children: [
                    Positioned(
                      bottom: 30,
                      right: 60,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -90,
            right: -90,
            child: Container(
              height: 250,
              width: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6B67F6),
              ),
            ),
          ),
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