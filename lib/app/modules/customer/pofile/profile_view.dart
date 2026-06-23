import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/app_session/app_session.dart';
import '../../../../routes/app_routes.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: [

            /// Background
            Container(
              decoration: const BoxDecoration(
                color: Color(0xffF4F7FC),
              ),
            ),

            /// Top circles theme
            Positioned(
              top: -80,
              left: -60,
              child: Container(
                height: 180,
                width: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff62B5F8),
                ),
              ),
            ),

            Positioned(
              top: -90,
              right: -100,
              child: Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff6B67F6),
                ),
              ),
            ),

            SingleChildScrollView(
              child: Column(
                children: [

                  /// Profile Header
                  Container(
                    height: 360,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 100,
                    ),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Column(
                        children: [

                          InkWell(
                            onTap: controller.showImagePicker,
                            child: Stack(
                              children: [

                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                      )
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundImage:
                                    controller.selectedImage.value != null
                                        ? FileImage(
                                      controller
                                          .selectedImage
                                          .value!,
                                    )
                                        : controller.image.isNotEmpty
                                        ? NetworkImage(
                                      controller.image,
                                    )
                                        : const NetworkImage(
                                      "https://i.pravatar.cc/150",
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 10,
                                  right: 0,
                                  child: Container(
                                    padding:
                                    const EdgeInsets.all(8),
                                    decoration:
                                    const BoxDecoration(
                                      color:
                                      Color(0xff6B67F6),
                                      shape:
                                      BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            controller.userName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight:
                              FontWeight.bold,
                              color: Color(0xff6C63FF),
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            controller.phone,
                            style: TextStyle(
                              color:
                              Color(0xff6C63FF),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                  /// Menu Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15),
                    child: Column(
                      children: [

                        AppSession.role  == 1 ?
                        cardTile(
                          Icons.location_on,
                          "My Address",
                              () {
                            Get.toNamed(
                              AppRoutes.addressList,
                            );
                          },
                        ): SizedBox.shrink(),
                        cardTile(
                          Icons.payment,
                          "Payment History",
                              () {
                            Get.toNamed(
                              AppRoutes.paymentHistory,
                            );
                          },
                        ),
                        AppSession.role  == 1 ?
                        cardTile(
                          Icons.wallet_giftcard,
                          "Subscription History",
                              () {
                            Get.toNamed(
                              AppRoutes.subscriptionHistoryList,
                            );
                          },
                         ) : SizedBox.shrink(),
                        cardTile(
                          Icons.lock,
                          "Change Password",
                              () {
                                Get.toNamed(
                                  AppRoutes.changePassword,
                                );
                              },
                        ),

                        cardTile(
                          Icons.help,
                          "Help & Support",
                              () {},
                        ),

                        cardTile(
                          Icons.logout,
                          "Logout",
                          controller.logout,
                          isLogout: true,

                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
    );
  }

  Widget cardTile(
      IconData icon,
      String title,
      VoidCallback onTap,{
        bool isLogout=false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:
        const EdgeInsets.only(bottom: 15),
        padding:
        const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          children: [

            Icon(
              icon,
              color: isLogout
                  ? Colors.red
                  : const Color(
                  0xff6B67F6),
            ),

            const SizedBox(width:15),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight:
                  FontWeight.w600,
                  color:isLogout
                      ? Colors.red
                      : Colors.black,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size:16,
            )
          ],
        ),
      ),
    );
  }
}
