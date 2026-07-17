import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';
import '../../models/register_model/state_list_model.dart';
import '../../models/register_model/district_list_model.dart';
import '../../models/register_model/subdivision_list_model.dart';

class RegisterScreen extends GetView<RegisterController> {
  RegisterScreen({super.key});
  final RegisterController registerController = Get.put(RegisterController());


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      body: Stack(
        children: [

          /// TOP LEFT CIRCLE
          Positioned(
            top: -90,
            left: -70,
            child: Container(
              height: 220,
              width: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff62B5F8),
              ),
            ),
          ),

          /// TOP RIGHT CIRCLE
          Positioned(
            top: -120,
            right: -90,
            child: Container(
              height: 280,
              width: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6C63FF),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),

                  child: Row(
                    children: [

                      InkWell(
                        borderRadius:
                        BorderRadius.circular(50),

                        onTap: () => Get.back(),

                        child: Container(
                          height: 45,
                          width: 45,

                          decoration: BoxDecoration(
                            color:
                            Colors.white.withOpacity(
                              .25,
                            ),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),

                      const Expanded(
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              color: Color(0xff1A2C56),
                              fontSize: 24,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 45),
                    ],
                  ),
                ),

                const Text(
                  "Register to get started",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 18),

                /// FORM CONTAINER
                Expanded(
                  child: Container(
                    padding:
                    const EdgeInsets.only(top: 4),

                    decoration:
                    const BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                      BorderRadius.vertical(
                        top:
                        Radius.circular(40),
                      ),
                    ),

                    child:
                    SingleChildScrollView(
                      padding:
                      const EdgeInsets
                          .fromLTRB(
                        20,
                        0,
                        20,
                        20,
                      ),

                      child: Form(
                        key:
                        controller.formKey,

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            /// ROLE TITLE
                            // const Text(
                            //   "Select Role",
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight:
                            //     FontWeight
                            //         .bold,
                            //     color: Color(
                            //         0xff1A2C56),
                            //   ),
                            // ),

                            // const SizedBox(
                            //     height: 14),
                            //
                            // /// ROLE CARD
                            // Obx(
                            //       ()=>Container(
                            //     padding:
                            //     const EdgeInsets
                            //         .all(
                            //         5),
                            //
                            //     decoration:
                            //     BoxDecoration(
                            //       color:
                            //       const Color(
                            //         0xffF7F9FC,
                            //       ),
                            //
                            //       borderRadius:
                            //       BorderRadius.circular(
                            //           18),
                            //     ),
                            //
                            //     child: Row(
                            //       children: [
                            //         "Admin",
                            //         "User",
                            //         "Delivery"
                            //       ].map(
                            //             (role) {
                            //           bool isSelected =
                            //               controller.selectedRole.value ==
                            //                   role;
                            //
                            //           return Expanded(
                            //             child:
                            //             GestureDetector(
                            //               onTap:
                            //                   ()=>controller.setRole(role),
                            //
                            //               child:
                            //               AnimatedContainer(
                            //                 duration:
                            //                 const Duration(
                            //                     milliseconds:
                            //                     300),
                            //
                            //                 padding:
                            //                 const EdgeInsets.symmetric(
                            //                   vertical:
                            //                   14,
                            //                 ),
                            //
                            //                 decoration:
                            //                 BoxDecoration(
                            //                   gradient: isSelected
                            //                       ? const LinearGradient(
                            //                     colors: [
                            //                       Color(0xff4F8EF7),
                            //                       Color(0xff6C63FF),
                            //                     ],
                            //                   )
                            //                       : null,
                            //
                            //                   borderRadius:
                            //                   BorderRadius.circular(
                            //                       14),
                            //                 ),
                            //
                            //                 child:
                            //                 Center(
                            //                   child:
                            //                   Text(
                            //                     role,
                            //                     style:
                            //                     TextStyle(
                            //                       color: isSelected
                            //                           ? Colors.white
                            //                           : Colors.black87,
                            //
                            //                       fontWeight:
                            //                       FontWeight.w600,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           );
                            //         },
                            //       ).toList(),
                            //     ),
                            //   ),
                            // ),

                            const SizedBox(
                                height: 24),

                            /// ALL FIELDS
                            _field(
                              "Full Name",
                              controller
                                  .fullNameController,
                                  (v)=>controller.validateRequired(
                                  v!,
                                  "Full Name"),
                            ),

                            _field(
                              "Mobile Number",
                              controller
                                  .mobileController,
                                  (v)=>controller
                                  .validateMobile(
                                  v!),
                            ),

                            _field(
                              "Address",
                              controller
                                  .addressController,
                                  (v)=>controller.validateRequired(
                                  v!,
                                  "Address"),
                            ),

                            _stateDropdownField(),

                            _cityDropdownField(),

                            _societyDropdownField(),

                            _field(
                              "PinCode",
                              controller
                                  .pinCodeController,
                              null,
                            ),

                            _field(
                              "Street Name",
                              controller
                                  .streetController,
                              null,
                            ),

                            _field(
                              "House No",
                              controller
                                  .houseNoController,
                              null,
                            ),

                            _field(
                              "Flat No",
                              controller
                                  .flatNoController,
                              null,
                            ),

                            _field(
                              "Landmark",
                              controller
                                  .landmarkController,
                              null,
                            ),

                            _passwordField(
                              "Password",
                              controller
                                  .passwordController,
                                  (v)=>controller
                                  .validatePassword(
                                  v!),
                            ),

                            _passwordField(
                              "Confirm Password",
                              controller
                                  .confirmPasswordController,
                                  (v)=>controller.validateConfirmPassword(
                                  v!),
                            ),

                            const SizedBox(
                                height: 20),

                            /// BUTTON
                            Container(
                              height: 60,

                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    22),

                                gradient:
                                const LinearGradient(
                                  colors: [
                                    Color(
                                        0xff4F8EF7),
                                    Color(
                                        0xff6C63FF),
                                  ],
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    const Color(
                                      0xff6C63FF,
                                    ).withOpacity(
                                        .3),

                                    blurRadius:
                                    20,

                                    offset:
                                    const Offset(
                                        0,
                                        10),
                                  )
                                ],
                              ),

                              child: ElevatedButton(
                                onPressed:
                                controller
                                    .register,

                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Colors
                                      .transparent,

                                  shadowColor:
                                  Colors
                                      .transparent,
                                ),

                                child:
                                const Text(
                                  "Create Account",

                                  style:
                                  TextStyle(
                                    color:
                                    Colors
                                        .white,

                                    fontSize:
                                    18,

                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller,
      String? Function(String?)? validator,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label outside TextField
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: "Enter $label",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stateDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              "State",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
              initialValue: controller.selectedState.value,
              hint: const Text("Select State"),
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
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
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              "City",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
              initialValue: controller.selectedDistrict.value,
              hint: const Text("Select City"),
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
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

  Widget _societyDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              "Society Name",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
              initialValue: controller.selectedSubdivision.value,
              hint: const Text("Select Society Name"),
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              ),
              items: controller.subdivisions.map((subdivision) {
                return DropdownMenuItem<SubdivisionData>(
                  value: subdivision,
                  child: Text(subdivision.subdivisionname),
                );
              }).toList(),
              validator: (value) {
                if (value == null) return "Society is required";
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

  Widget _passwordField(
      String label,
      TextEditingController controller,
      String? Function(String?) validator,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label Outside
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          /// Password Field
          Obx(() {
            return TextFormField(
              controller: controller,
              validator: validator,
              obscureText: !registerController.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Enter $label",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                /// 👁 Show / Hide Button
                suffixIcon: IconButton(
                  icon: Icon(
                    registerController.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    registerController.isPasswordVisible.value =
                    !registerController.isPasswordVisible.value;
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}