import 'package:e_shop_app/services/api_service.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:e_shop_app/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_review.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ItemDetailsScreen({super.key, required this.product});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  int _selectedIndex = 0;

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthHelper.checkLoginStatus(context);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          widget.product['imageUrl'],
                          height: 500,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.product['name'],
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.product['price'].toString()}ден",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Description: ${widget.product['description'] ?? 'No description available'}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        String? userId = prefs.getString('userId');
                        ApiService.addItemFromCart(
                            widget.product['id'], userId!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Successfully added the item to cart.'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 40),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Add to Cart'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddReviewScreen(itemId: widget.product['id']),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 40),
                        backgroundColor: Colors.amberAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Add Review'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationWidget(
        onIndexChanged: _onIndexChanged,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
