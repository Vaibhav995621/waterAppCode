import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'address_controller.dart';
import '../../../../routes/app_routes.dart';
import 'package:zourney/app/models/address_model/addresss_model.dart';

/// SCREEN
class AddressListScreen extends StatelessWidget {
   AddressListScreen({super.key});
  final AddressController controller =
  Get.put(AddressController());
  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      backgroundColor: const Color(0xffEEF4FF),
      body: Stack(
        children: [

          /// Background circles

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
            top: -120,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff6C63FF),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 130,),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xffF8FAFF),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                  ),

                  child: Obx(
                        ()=>ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.addressList.length,
                      separatorBuilder: (_,__) =>
                      const SizedBox(height: 18),
                      itemBuilder: (_,index){

                        final item =
                        controller.addressList[index];

                        return AddressCard(
                          model: item,
                          selected:
                          item.isDefault == 1  ,

                          onTap: () async {
                            final result = await Get.toNamed(
                              AppRoutes.editAddressScreen,
                              arguments: item,
                            );
                            if (result == true) {
                              controller.refreshAddress();
                            }
                          },

                          onDelete: (){
                            if(controller.addressList.length > 1 && controller.addressList[index].isDefault == 0){
                                controller.deleteAddress(index);
                              }
                          },

                          onEdit: () async {
                            controller.selectAddress(index);
                            },
                        );
                      },
                    ),
                  ),
                ),
              ),

              _buildBottomButton(),
            ],
          ),

        ],
      ),
    );
  }

  /// HEADER
  /// UPDATED HEADER

  /// BUTTON
  Widget _buildBottomButton() {
    return TweenAnimationBuilder(
      duration: const Duration(
        milliseconds: 900,
      ),

      tween: Tween<double>(
        begin: -250,
        end: 0,
      ),

      curve: Curves.easeOutBack,

      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },

      child: Container(
        margin: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          22,
        ),

        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(24),

          gradient:
          const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff4F8EF7),
              Color(0xff6C63FF),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(
                0xff6C63FF,
              ).withOpacity(.35),
              blurRadius: 20,
              offset: const Offset(
                0,
                10,
              ),
            )
          ],
        ),

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius:
            BorderRadius.circular(
              24,
            ),

            splashColor:
            Colors.white24,

            onTap: () async {
              {
                final result = await Get.toNamed(
                  AppRoutes.editAddressScreen,
                );
                print("returned: $result");
                if (result == true) {
                  controller.refreshAddress();
                }
              }
            },

            child: Container(
              height: 65,

              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 18,
              ),

              child: Row(
                children: [

                  /// Animated icon bubble
                  TweenAnimationBuilder(
                    tween:
                    Tween<double>(
                      begin: .7,
                      end: 1,
                    ),

                    duration:
                    const Duration(
                      milliseconds:
                      1000,
                    ),

                    curve: Curves
                        .elasticOut,

                    builder: (
                        context,
                        scale,
                        child,
                        ) {
                      return Transform
                          .scale(
                        scale: scale,

                        child:
                        Container(
                          height:
                          42,
                          width:
                          42,

                          decoration:
                          const BoxDecoration(
                            color:
                            Colors
                                .white24,
                            shape:
                            BoxShape
                                .circle,
                          ),

                          child:
                          const Icon(
                            Icons
                                .add_location_alt_rounded,
                            color:
                            Colors
                                .white,
                            size:
                            24,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                      width: 14),

                  const Expanded(
                    child: Text(
                      "Add New Address",

                      style:
                      TextStyle(
                        color: Colors
                            .white,
                        fontSize:
                        18,
                        fontWeight:
                        FontWeight
                            .bold,
                        letterSpacing:
                        .4,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons
                        .arrow_forward_ios,
                    color: Colors
                        .white70,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// CARD
/// UPDATED ADDRESS CARD UI
///
///

class AddressCard extends StatelessWidget {
  final AddressData model;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AddressCard({
    super.key,
    required this.model,
    required this.selected,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {

    final fullAddress =
        "Society Name - ${model.societyname}\n"
        "House Number - ${model.housenumber}\n"
        "Falt No - ${model.flatnumber}\n"
        "Gali No - ${model.galinumber}\n"
        "Sector - ${model.sector}\n"
        "Landmark - ${model.landmark}\n"
        "City - ${model.city} "
        "State - ${model.state} "
        "Pin Code - ${model.pincode}\n";

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff4F8EF7),
              Color(0xff6C63FF),
            ],
          )
              : const LinearGradient(
            colors: [
              Colors.white,
              Color(0xffFAFBFF),
            ],
          ),

          borderRadius: BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: selected
                  ? Colors.blue.withOpacity(.25)
                  : Colors.black12,
              blurRadius: 18,
              offset: const Offset(0, 8),
            )
          ],
        ),

        child: Column(
          children: [

            /// TOP SECTION
            Row(
              children: [

                /// HOME ICON
                Container(
                  height: 65,
                  width: 65,

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.95),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.home_rounded,
                    size: 34,
                    color: selected
                        ? const Color(0xff6C63FF)
                        : const Color(0xff1976D2),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Row(
                        children: [

                          Expanded(
                            child: Text(
                               "Home",

                              style: TextStyle(
                                fontSize: 19,
                                fontWeight:
                                FontWeight.bold,

                                color: selected
                                    ? Colors.white
                                    : const Color(
                                    0xff1A2C56),
                              ),
                            ),
                          ),

                          AnimatedContainer(
                            duration:
                            const Duration(
                                milliseconds:
                                300),

                            height: 28,
                            width: 28,

                            decoration:
                            BoxDecoration(
                              shape:
                              BoxShape.circle,
                              color: selected
                                  ? Colors.white
                                  : Colors
                                  .transparent,

                              border: Border.all(
                                color: selected
                                    ? Colors.white
                                    : Colors.grey
                                    .shade300,
                              ),
                            ),

                            child: selected
                                ? const Icon(
                              Icons.check,
                              size: 18,
                              color: Color(
                                  0xff6C63FF),
                            )
                                : null,
                          )
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                         "",

                        style: TextStyle(
                          color: selected
                              ? Colors.white70
                              : Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (selected)
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),

                          decoration:
                          BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                            BorderRadius
                                .circular(50),
                          ),

                          child: const Text(
                            "Default Address",
                            style: TextStyle(
                              color:
                              Colors.white,
                              fontSize: 11,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// ADDRESS CONTAINER
            Container(
              padding:
              const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: selected
                    ? Colors.white24
                    : const Color(
                    0xffF4F7FC),

                borderRadius:
                BorderRadius.circular(18),
              ),

              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.location_on,
                    color: selected
                        ? Colors.white
                        : const Color(
                        0xff1976D2),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      fullAddress,

                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,

                        color: selected
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Divider(
              color: selected
                  ? Colors.white24
                  : Colors.grey.shade200,
            ),

            const SizedBox(height: 12),

            /// BUTTONS
            Row(
              children: [
                if(model.isDefault == 0)
                Expanded(
                  child:
                  ElevatedButton.icon(
                    onPressed: onEdit,

                    icon: const Icon(
                      Icons.edit,
                      size: 16,
                    ),

                    label:
                    const Text("Set as Default"),

                    style:
                    ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                      Colors.white,

                      foregroundColor:
                      const Color(
                          0xff1976D2),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                if(model.isDefault == 0)
                Expanded(
                  child:
                  ElevatedButton.icon(
                    onPressed:
                    onDelete,

                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                    ),

                    label:
                    const Text(
                        "Delete"),

                    style:
                    ElevatedButton.styleFrom(
                      elevation: 0,

                      backgroundColor:
                      Colors.red
                          .shade50,

                      foregroundColor:
                      Colors.red,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


