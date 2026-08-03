import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zourney/app/models/address_model/addresss_model.dart';
import '../../../../routes/app_routes.dart';
import 'select_address_controller.dart';

class SelectAddressScreen extends StatelessWidget {
  SelectAddressScreen({super.key});

  final SelectAddressController controller = Get.put(SelectAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF4FF),
      body: Stack(
        children: [
          /// Top Left Circle with Back Button
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
                child: const Stack(
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

          /// Top Right Circle
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

              /// Title Header
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Address",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1A2C56),
                        letterSpacing: 0.3,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_location_alt_rounded,
                        color: Color(0xff6C63FF),
                        size: 26,
                      ),
                      onPressed: () async {
                        final result = await Get.toNamed(
                          AppRoutes.editAddressScreen,
                        );
                        if (result == true) {
                          controller.refreshAddress();
                        }
                      },
                    ),
                  ],
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
                  child: Obx(
                    () {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff6C63FF),
                          ),
                        );
                      }

                      if (controller.addressList.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        itemCount: controller.addressList.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 18),
                        itemBuilder: (_, index) {
                          final item = controller.addressList[index];
                          final isSelected = controller.selectedId.value == item.id;

                          return AddressCard(
                            model: item,
                            selected: isSelected,
                            onTap: () {
                              controller.selectAddress(item.id!);
                            },
                            onDelete: () {
                              if (controller.addressList.length > 1 &&
                                  item.isDefault == 0) {
                                controller.deleteAddress(index);
                              }
                            },
                            onEdit: () async {
                              final result = await Get.toNamed(
                                AppRoutes.editAddressScreen,
                                arguments: item,
                              );
                              if (result == true) {
                                controller.refreshAddress();
                              }
                            },
                            onSetDefault: () async {
                              await controller.setDefaultAddress(item.id!);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              _buildBottomActionButtons(),
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
            decoration: const BoxDecoration(
              color: Color(0xffEEF4FF),
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
            "Add a new address to proceed with booking",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// BOTTOM ACTION BUTTON
  Widget _buildBottomActionButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
      decoration: const BoxDecoration(
        color: Color(0xffF8FAFF),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () {
              if (controller.selectedId.value == -1) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Saving will set this address as default for delivery.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Row(
            children: [
              /// Add New Address button
              Expanded(
                flex: 1,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: Colors.blue.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        final result = await Get.toNamed(
                          AppRoutes.editAddressScreen,
                        );
                        if (result == true) {
                          controller.refreshAddress();
                        }
                      },
                      child: const Center(
                        child: Icon(
                          Icons.add_location_alt_rounded,
                          color: Color(0xff6C63FF),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              /// Confirm & Deliver Here button
              Expanded(
                flex: 4,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.white24,
                      onTap: controller.isLoading.value
                          ? null
                          : () {
                              controller.saveAndGoBack();
                            },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Deliver To This Address",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .3,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white70,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// ADDRESS CARD (Identical to AddressListScreen UI)
/// ─────────────────────────────────────────────
class AddressCard extends StatelessWidget {
  final AddressData model;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback? onSetDefault;

  const AddressCard({
    super.key,
    required this.model,
    required this.selected,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    // ── Resolve display values from API fields ──
    final displaySociety = (model.societyGaliBlockNo?.isNotEmpty ?? false)
        ? model.societyGaliBlockNo!
        : (model.societyname.isNotEmpty ? model.societyname : "—");

    final displayHouse = (model.houseFlatFloorNo?.isNotEmpty ?? false)
        ? model.houseFlatFloorNo!
        : (model.housenumber.isNotEmpty ? model.housenumber : "—");

    final displaySector = (model.sectornumber?.isNotEmpty ?? false)
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
                  Container(
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.95),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home_rounded,
                      size: 30,
                      color: selected
                          ? const Color(0xff6C63FF)
                          : const Color(0xff1976D2),
                    ),
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
                            if (model.isDefault == 1)
                              _badge(
                                label: "Default",
                                icon: Icons.star_rounded,
                                bgColor: selected
                                    ? Colors.white24
                                    : Colors.amber.shade50,
                                textColor: selected
                                    ? Colors.white
                                    : Colors.amber.shade800,
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
              if (model.isDefault == 0 && onSetDefault != null)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onSetDefault,
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
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onEdit,
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
                  color: selected ? Colors.white54 : Colors.grey.shade500,
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
