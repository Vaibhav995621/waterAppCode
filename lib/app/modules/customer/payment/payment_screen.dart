import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Payment"),
        centerTitle: true,
      ),

      body: Center(
        child: Obx(
              () => SizedBox(
            width: 220,

            height: 55,

            child: ElevatedButton(
              onPressed:
              controller.isLoading.value
                  ? null
                  : () {
                controller
                    .makePayment();
              },

              child:
              controller.isLoading
                  .value
                  ? const CircularProgressIndicator(
                color:
                Colors
                    .white,
              )
                  : const Text(
                "Pay ₹500",
                style:
                TextStyle(
                  fontSize:
                  18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}