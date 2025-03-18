import 'package:e_shop_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            maxLength: 19,
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                String formattedText = '';
                for (int i = 0; i < newText.length; i++) {
                  if (i > 0 && i % 4 == 0) {
                    formattedText += '-';
                  }
                  formattedText += newText[i];
                }
                return newValue.copyWith(
                  text: formattedText,
                  selection: TextSelection.collapsed(offset: formattedText.length),
                );
              }),
            ],
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
                  maxLength: 5,
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                      String formattedText = '';
                      for (int i = 0; i < newText.length; i++) {
                        if (i == 2) {
                          formattedText += '/';
                        }
                        formattedText += newText[i];
                      }
                      return newValue.copyWith(
                        text: formattedText,
                        selection: TextSelection.collapsed(offset: formattedText.length),
                      );
                    }),
                  ],
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
                  maxLength: 3,
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
              final cardNumber = cardController.text.replaceAll(RegExp(r'[^0-9]'), '');
              final expiration = expirationController.text.split('/');
              final expirationMonth = int.parse(expiration[0]);
              final expirationYear = int.parse('20${expiration[1]}');
              final cvc = cvcController.text;

              print('Processing payment...');
              print('Card Number: $cardNumber');
              print('Expiration Date: $expirationMonth/$expirationYear');
              print('CVC: $cvc');
              print('Simulating payment of \$${totalAmount.toStringAsFixed(2)}');

              final prefs = await SharedPreferences.getInstance();
              String? userId = prefs.getString('userId');
              ApiService.createOrder(userId!);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment Successful!')),
              );
              Navigator.pushNamed(context, '/items');
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
            'Pay ${totalAmount.toStringAsFixed(2)}ден',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
