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
  final AddressController controller = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF4FF),
      body: Stack(
        children: [
          /// Background circles
          Positioned(
            top: -60,
            left: -60,
            child: GestureDetector(
              onTap: () {
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
              const SizedBox(height: 130),

              /// Title shown between circles and list
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Addresses",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1A2C56),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xffF8FAFF),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: controller.refreshAddress,
                    child: Obx(
                      () => controller.addressList.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: _buildEmptyState(),
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                              itemCount: controller.addressList.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 18),
                              itemBuilder: (_, index) {
                                final item = controller.addressList[index];
                                return AddressCard(
                                  model: item,
                                  selected: item.isDefault == 1,
                                  onTap: () async {
                                    final result = await Get.toNamed(
                                      AppRoutes.editAddressScreen,
                                      arguments: item,
                                    );
                                    if (result == true) {
                                      controller.refreshAddress();
                                    }
                                  },
                                  onDelete: () {
                                    if (controller.addressList.length > 1 &&
                                        controller.addressList[index].isDefault ==
                                            0) {
                                      controller.deleteAddress(index);
                                    }
                                  },
                                  onEdit: () async {
                                    controller.selectAddress(index);
                                  },
                                  onUploadImage: () async {
                                    final result = await Get.toNamed(
                                      AppRoutes.uploadAddressImageScreen,
                                      arguments: item,
                                    );
                                    if (result == true) {
                                      controller.refreshAddress();
                                    }
                                  },
                                );
                              },
                            ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: const Color(0xffEEF4FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_rounded,
              size: 44,
              color: Color(0xff6C63FF),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "No addresses yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff1A2C56),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add a new address to get started",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// BUTTON
  Widget _buildBottomButton() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 900),
      tween: Tween<double>(begin: -250, end: 0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff4F8EF7),
              Color(0xff6C63FF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff6C63FF).withOpacity(.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            splashColor: Colors.white24,
            onTap: () async {
              final result = await Get.toNamed(
                AppRoutes.editAddressScreen,
              );
              if (result == true) {
                controller.refreshAddress();
              }
            },
            child: Container(
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: .7, end: 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_location_alt_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Add New Address",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .4,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
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

/// ─────────────────────────────────────────────
/// UPDATED ADDRESS CARD
/// ─────────────────────────────────────────────
class AddressCard extends StatelessWidget {
  final AddressData model;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onUploadImage;

  const AddressCard({
    super.key,
    required this.model,
    required this.selected,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.onUploadImage,
  });

  @override
  Widget build(BuildContext context) {
    // ── Resolve display values from new API fields ──
    final displaySociety =
        (model.societyGaliBlockNo?.isNotEmpty ?? false)
            ? model.societyGaliBlockNo!
            : (model.societyname.isNotEmpty ? model.societyname : "—");

    final displayHouse =
        (model.houseFlatFloorNo?.isNotEmpty ?? false)
            ? model.houseFlatFloorNo!
            : (model.housenumber.isNotEmpty ? model.housenumber : "—");

    final displaySector =
        (model.sectornumber?.isNotEmpty ?? false)
            ? model.sectornumber!
            : (model.subdivisionname?.isNotEmpty ?? false)
                ? model.subdivisionname!
                : "—";

    final hasLift = model.isLiftAvailable == 1;
    final floorNo = model.floornumber > 0 ? "Floor ${model.floornumber}" : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 4),
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
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── TOP ROW ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Home icon bubble
                  // Image or Home icon bubble
                  Builder(
                    builder: (context) {
                      final photoUrl = model.photo ?? model.imagepath;
                      final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;
                      return Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.95),
                          shape: BoxShape.circle,
                          image: hasPhoto
                              ? DecorationImage(
                                  image: NetworkImage(photoUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: !hasPhoto
                            ? Icon(
                                Icons.home_rounded,
                                size: 30,
                                color: selected
                                    ? const Color(0xff6C63FF)
                                    : const Color(0xff1976D2),
                              )
                            : null,
                      );
                    },
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Home",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xff1A2C56),
                                ),
                              ),
                            ),
                            // Default check badge
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? Colors.white
                                    : Colors.transparent,
                                border: Border.all(
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: selected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Color(0xff6C63FF),
                                    )
                                  : null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Address line
                        Text(
                          model.fullAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: selected
                                ? Colors.white70
                                : Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Badges row
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            if (selected)
                              _badge(
                                label: "Default",
                                icon: Icons.star_rounded,
                                bgColor: Colors.white24,
                                textColor: Colors.white,
                              ),
                            if (hasLift)
                              _badge(
                                label: "Lift",
                                icon: Icons.elevator_rounded,
                                bgColor: selected
                                    ? Colors.white24
                                    : const Color(0xffE8F5E9),
                                textColor: selected
                                    ? Colors.white
                                    : Colors.green.shade700,
                              ),
                            if (floorNo != null)
                              _badge(
                                label: floorNo,
                                icon: Icons.layers_rounded,
                                bgColor: selected
                                    ? Colors.white24
                                    : const Color(0xffEDE7F6),
                                textColor: selected
                                    ? Colors.white
                                    : const Color(0xff6C63FF),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── DETAIL GRID ──
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white24
                      : const Color(0xffF4F7FC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _detailRow(
                      icon: Icons.apartment_rounded,
                      label: "Flat / House No",
                      value: displayHouse,
                      selected: selected,
                    ),
                    const SizedBox(height: 10),
                    _detailRow(
                      icon: Icons.holiday_village_rounded,
                      label: "Society / Block",
                      value: displaySociety,
                      selected: selected,
                    ),
                    const SizedBox(height: 10),
                    _detailRow(
                      icon: Icons.map_rounded,
                      label: "Sector / Area",
                      value: displaySector,
                      selected: selected,
                    ),
                    if (model.landmark.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _detailRow(
                        icon: Icons.place_rounded,
                        label: "Landmark",
                        value: model.landmark,
                        selected: selected,
                      ),
                    ],
                    const SizedBox(height: 10),
                    _detailRow(
                      icon: Icons.location_city_rounded,
                      label: "City / State",
                      value: "${model.city}, ${model.state} - ${model.pincode}",
                      selected: selected,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Divider(
                color: selected ? Colors.white24 : Colors.grey.shade200,
              ),

              const SizedBox(height: 10),

              // ── ACTION BUTTONS ──
              if (model.isDefault == 0)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.star_outline_rounded, size: 16),
                        label: const Text("Set as Default"),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xff1976D2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: Colors.blue.shade100,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onDelete,
                        icon:
                            const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text("Delete"),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Colors.red.shade100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              // Edit button always visible
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: const Text("Edit Address"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            selected ? Colors.white : const Color(0xff6C63FF),
                        side: BorderSide(
                          color: selected
                              ? Colors.white54
                              : const Color(0xff6C63FF).withOpacity(0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onUploadImage,
                      icon: const Icon(Icons.add_a_photo_rounded, size: 16),
                      label: const Text("Upload Image", style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis,),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            selected ? Colors.white : const Color(0xff6C63FF),
                        side: BorderSide(
                          color: selected
                              ? Colors.white54
                              : const Color(0xff6C63FF).withOpacity(0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool selected,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: selected ? Colors.white70 : const Color(0xff1976D2),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: selected
                      ? Colors.white54
                      : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.black87,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
