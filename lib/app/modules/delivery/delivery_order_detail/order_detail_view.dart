import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_detail_controller.dart';

class DeliveryOrderDetailView extends GetView<DeliveryOrderDetailController> {
  const DeliveryOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.order;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),

      bottomNavigationBar: GetBuilder<DeliveryOrderDetailController>(
        id: 'status',
        builder: (_) {

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 55,
                child: Obx(
                      () => ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.markAsDelivered('4'),
                    icon: controller.isLoading.value
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.check_circle),
                    label: Text(
                      controller.isLoading.value
                          ? 'Updating...'
                          : 'Mark as Delivered',
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ORDER INFO
            _sectionCard(
              title: 'Order Information',
              children: [
                _row('Order Number', order.ordernumber),
                _row('Quantity', '${order.quantity}'),
                _row('Price', '₹${order.price}'),
              ],
            ),

            const SizedBox(height: 16),

            /// CUSTOMER
            _sectionCard(
              title: 'Customer Details',
              children: [
                _row('Name', order.customername),
                _row('Mobile', order.customermobile),
              ],
            ),

            const SizedBox(height: 16),

            /// PRODUCT
            _sectionCard(
              title: 'Bottle Details',
              children: [
                _row('Bottle', '${order.bottlename ?? '-'}'),
                _row('Weight', '${order.weight ?? '-'}'),
                _row('Description', '${order.bottledescription ?? '-'}'),
              ],
            ),

            const SizedBox(height: 16),

            /// ADDRESS
            _sectionCard(
              title: 'Delivery Address',
              children: [
                Text(
                  '${order.housenumber}, '
                  '${order.flatnumber}, '
                  '${order.societyname}\n'
                  '${order.galinumber}\n'
                  '${order.landmark}\n'
                  '${order.city}, ${order.state} - ${order.pincode}',
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// DELIVERY PARTNER
            if (order.partnername != null)
              _sectionCard(
                title: 'Delivery Partner',
                children: [
                  _row('Name', '${order.partnername}'),
                  _row('Mobile', '${order.partnermobile ?? '-'}'),
                ],
              ),

            const SizedBox(height: 16),

            GetBuilder<DeliveryOrderDetailController>(
              id: 'status',
              builder: (_) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _statusColor(order.status).withOpacity(.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.statusText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _statusColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
