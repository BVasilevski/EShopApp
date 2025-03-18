import 'dart:convert';

import 'package:e_shop_app/models/cart_item.dart';
import 'package:e_shop_app/services/api_service.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/navigation.dart';
import '../widgets/payment.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];

  int _selectedIndex = 1;
  bool _isPaymentWidgetVisible = false;

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void getItemsFromAPI(String userId) {
    ApiService.getCartItems(userId).then((response) {
      var data = json.decode(response.body);
      if (data is List) {
        setState(() {
          cartItems = data.map<CartItem>((json) => CartItem.fromJson(json)).toList();
        });
      } else {
        print("Unexpected API response format");
      }
    }).catchError((error) {
      print("Error fetching items: $error");
    });
  }
  void _onCheckoutPressed() {
    setState(() {
      _isPaymentWidgetVisible = true;
    });
  }
  Future<void> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    getItemsFromAPI(userId!); 
  }
  @override
  void initState() {
    super.initState();
    getCartItems();
  }
  @override
  Widget build(BuildContext context) {
  double totalPrice = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  AuthHelper.checkLoginStatus(context);

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
                    ' Total:\n ${totalPrice.toStringAsFixed(0)}ден.',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _onCheckoutPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, 
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
            const SizedBox(height: 16), 

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                              item.itemName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              overflow: TextOverflow.ellipsis, 
                              maxLines: 1, 
                            ),
                            ),
                            IconButton(
                              onPressed: () {
                                ApiService.removeItemFromCart(item.id);
                                setState(() {
                                  cartItems.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Succesfuly removed the item from cart.')),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.price.toStringAsFixed(0)}ден.',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Text(
                              'Quantity: ${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
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
