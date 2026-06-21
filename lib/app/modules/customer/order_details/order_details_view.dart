import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'order_detail_controller.dart';

class OrderDetailsScreen extends GetView<OrderDetailsController> {
  OrderDetailsScreen({super.key});

  @override
  final OrderDetailsController controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      body: Stack(
        children: [

          /// Background circles


          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                    ),

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          _buildOrderCard(),

                          const SizedBox(height: 18),

                          _buildCustomerDetails(),

                          const SizedBox(height: 18),

                          _buildDeliverySchedule(),

                          const SizedBox(height: 18),

                          _buildDeliveryAddress(),

                          const SizedBox(height: 18),

                          _buildOrderSummary(),

                          const SizedBox(height: 30),
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
            top: -100,
            right: -100,
            child: Container(
              height: 260,
              width: 260,
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

  Widget _buildOrderCard() {
    return _buildCard(
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: Color(0xFF1976D2),
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order No.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 6),
                Text(
                  controller.orderNumber,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '${controller.deliveryDate} ${controller.deliveryTime}',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetails() {
    return _buildSection(
      title: 'Customer Details',
      icon: Icons.person_outline,
      child: Column(
        children: [
          _DetailTile(
            icon: Icons.person_outline,
            title: 'Customer Name',
            value: controller.customerName,
          ),
          Divider(height: 24),
          _DetailTile(
            icon: Icons.call_outlined,
            title: 'Mobile Number',
            value: controller.customerMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySchedule() {
    return _buildSection(
      title: 'Delivery Schedule',
      icon: Icons.calendar_month_outlined,
      child: Row(
        children: [
          Expanded(
            child: _DetailTile(
              icon: Icons.calendar_today_outlined,
              title: 'Delivery Date',
              value: controller.deliveryDate,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _DetailTile(
              icon: Icons.access_time,
              title: 'Delivery Time',
              value: controller.deliveryTime,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return _buildSection(
      title: 'Delivery Address',
      icon: Icons.location_on_outlined,
      child: Column(
        children: [
          _DetailTile(
            icon: Icons.home_outlined,
            title: 'House No.',
            value: controller.houseNumber,
          ),
          const Divider(height: 24),
          _DetailTile(
            icon: Icons.apartment_outlined,
            title: 'Flat No.',
            value: controller.flatNumber,
          ),
          const Divider(height: 24),
          _DetailTile(
            icon: Icons.groups_outlined,
            title: 'Society Name',
            value: controller.societyName,
          ),
          const Divider(height: 24),
          _DetailTile(
            icon: Icons.route_outlined,
            title: 'Gali / Lane',
            value: controller.galiNumber,
          ),
          const Divider(height: 24),
          _DetailTile(
            icon: Icons.flag_outlined,
            title: 'Landmark',
            value: controller.landmark,
          ),
          const Divider(height: 24),
          _DetailTile(
            icon: Icons.location_city_outlined,
            title: 'City',
            value: controller.city,
          ),
          const Divider(height: 24),
          _DetailTile(
            icon: Icons.map_outlined,
            title: 'State',
            value: controller.state,
          ),
          const Divider(height: 24),
          _DetailTile(
            icon: Icons.local_post_office_outlined,
            title: 'Pincode',
            value: controller.pincode,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return _buildSection(
      title: 'Order Summary',
      icon: Icons.shopping_bag_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Color(0xFF1976D2),
                  size: 40,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Water Bottle',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text('Quantity : 2', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Text(
                '₹${controller.totalAmount}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _priceRow('Price (Per Item)', '₹${controller.price}'),
          const SizedBox(height: 12),
          _priceRow('Total Quantity', '2'),
          const Divider(height: 32),
          _priceRow(
            'Total Amount',
            '₹${controller.totalAmount}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 22 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFF1976D2) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(
                icon,
                color: const Color(
                    0xFF1976D2),
                size: 26,
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  Color(0xFF1A2C56),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF1976D2)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
