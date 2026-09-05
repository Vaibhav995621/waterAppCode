import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../routes/app_routes.dart';
import '../../../app_session/app_session.dart';
import 'delivery_dashboard_controller.dart';

class DeliveryDashboardView extends StatelessWidget {
  DeliveryDashboardView({super.key});

  final DeliveryDashboardController controller =
      Get.put(DeliveryDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff62B5F8),
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              height: 280,
              width: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff3949AB),
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
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Delivery Dashboard",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppSession.name.isNotEmpty
                                ? "Welcome, ${AppSession.name}"
                                : "Delivery Partner Panel",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.notifications),
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// CONTENT
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.fetchDashboardData();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            /// STATS GRID
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: controller.isLoading.value
                                    ? _buildStatsShimmer()
                                    : GridView.count(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 14,
                                        crossAxisSpacing: 14,
                                        childAspectRatio: 1.45,
                                        children: [
                                          DeliveryStatsCard(
                                            title: "Total Orders",
                                            value: controller.totalOrders.value
                                                .toString(),
                                            colors: const [
                                              Color(0xff5C6BC0),
                                              Color(0xff3949AB),
                                            ],
                                          ),
                                          DeliveryStatsCard(
                                            title: "Active Orders",
                                            value: controller.activeOrders.value
                                                .toString(),
                                            colors: const [
                                              Color(0xff42A5F5),
                                              Color(0xff1976D2),
                                            ],
                                          ),
                                          DeliveryStatsCard(
                                            title: "Delivered Orders",
                                            value: controller
                                                .completedOrders.value
                                                .toString(),
                                            colors: const [
                                              Color(0xff66BB6A),
                                              Color(0xff2E7D32),
                                            ],
                                          ),
                                          DeliveryStatsCard(
                                            title: "Cancel Orders",
                                            value: controller
                                                .cancelledOrders.value
                                                .toString(),
                                            colors: const [
                                              Color(0xffEF5350),
                                              Color(0xffC62828),
                                            ],
                                          ),
                                          DeliveryStatsCard(
                                            title: "Total Earnings",
                                            value:
                                                "₹${controller.totalRevenue.value}",
                                            colors: const [
                                              Color(0xffAB47BC),
                                              Color(0xff6A1B9A),
                                            ],
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),
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

  Widget _buildStatsShimmer() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.45,
      children: List.generate(5, (index) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 90,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 50,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// STATS CARD
class DeliveryStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final List<Color> colors;

  const DeliveryStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
