import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zourney/app/modules/customer/subscription_history_list/subscription_history_controller.dart';

class SubscriptionHistoryView extends GetView<SubscriptionHistoryController> {
  const SubscriptionHistoryView({super.key});

  // Theme Colors matching the image profile layout
  final Color primaryColor = const Color(0xFF54A3F5); // Blue from background & Sign In
  final Color secondaryColor = const Color(0xFF7C83FD); // Purple-blue fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF), // Light matching tone
      appBar: AppBar(
        title: const Text(
          'Subscription History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (controller.subscriptionList.isEmpty) {
          return const Center(child: Text("No subscription data found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.subscriptionList.length,
          itemBuilder: (context, index) {
            final item = controller.subscriptionList[index];
            final details = item.subscriptionDetails;

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0), // Rounded theme look
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Column(
                  children: [
                    // Header Accent block mimicking UI shapes
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      color: secondaryColor.withOpacity(0.15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            details?.planname ?? "Standard Plan",
                            style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.status == 0 ? Colors.amber[700] : primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.status == 0 ? "Pending" : "Active",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Card Content
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Quantity", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${details?.bottlequantity ?? 0} Bottles",
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$${item.totalamount}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 24, thickness: 0.8),

                          // Transaction meta details
                          _buildDetailRow("Transaction ID", item.transId ?? "N/A"),
                          const SizedBox(height: 8),
                          _buildDetailRow("Date",DateFormat('yyyy-MM-dd').format(item.transDate) ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}