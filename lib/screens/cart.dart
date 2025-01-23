import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/payment.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Placeholder data
  final List<Map<String, dynamic>> cartItems = [
    {'name': 'Item 1', 'price': 10.99},
    {'name': 'Item 2', 'price': 15.49},
    {'name': 'Item 3', 'price': 8.99},
    {'name': 'Item 4', 'price': 12.00},
  ];

  int _selectedIndex = 1;
  bool _isPaymentWidgetVisible = false;

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCheckoutPressed() {
    setState(() {
      _isPaymentWidgetVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0, (sum, item) => sum + item['price']);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.indigo,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '  Total:\n \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onCheckoutPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Button color
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // Spacer

              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Text(
                                '\$${item['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              // The delete from cart functionality will be here
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: NavigationWidget(
              onIndexChanged: _onIndexChanged,
              selectedIndex: _selectedIndex,
            ),
          ),

          if (_isPaymentWidgetVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 100.0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: PaymentWidget(
                  totalAmount: totalPrice,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
