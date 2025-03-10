import 'package:e_shop_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // Import Stripe package

class PaymentWidget extends StatelessWidget {
  final double totalAmount;

  const PaymentWidget({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardController = TextEditingController();
    final TextEditingController expirationController = TextEditingController();
    final TextEditingController cvcController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Pay \$${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Card Information'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: cardController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 150,
                child: TextField(
                  controller: expirationController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'MM/YY',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: TextField(
                  controller: cvcController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CVC',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            try {
              // Extract expiration month and year from input
              final expiration = expirationController.text.split('/');
              final expirationMonth = int.parse(expiration[0]);
              final expirationYear = int.parse('20${expiration[1]}');

              // Initialize Stripe with your test publishable key
              Stripe.publishableKey =
                  'pk_test_51QYBdNRr839MP2GDWFvQIFO6lZ0uCiBMUv3FcYCBBpJEJ2CIi8uDZJdomf8kOi3QtCO8CXExwJw3yIATROkMzaJd00JokdhuLf'; // Replace with your actual key
              Stripe.merchantIdentifier =
                  'test'; // Optional, for Apple Pay and Google Pay

              // Create PaymentMethodData
              final paymentMethodData = PaymentMethodData(
                billingDetails: BillingDetails(
                  name: "Customer", // You can replace this with the user's name
                ),
              );

              // Create the payment method
              final paymentMethod = await Stripe.instance.createPaymentMethod(
                params: PaymentMethodParams.card(
                    paymentMethodData: paymentMethodData),
              );

              // Simulate the payment
              print('Payment method created: ${paymentMethod.id}');
              print(
                  'Simulating successful payment of \$${totalAmount.toStringAsFixed(2)}');

              // Process the payment and create the order on the server
              final prefs = await SharedPreferences.getInstance();
              String? userId = prefs.getString('userId');
              ApiService.createOrder(userId!);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment Successful!')),
              );
            } catch (e) {
              print('Payment failed: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment Failed: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text(
            'Pay \$${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
