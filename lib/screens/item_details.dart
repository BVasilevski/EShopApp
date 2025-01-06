import 'package:e_shop_app/widgets/navigation.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ItemDetailsScreen({super.key, required this.product});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  int _selectedIndex = 0; // Set the default selected index to 0

  // Callback to update the selected index
  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          children: [
            // Product image
            Image.network(
              widget.product['image'],
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Product name
            Text(
              widget.product['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Product price
            Text(
              widget.product['price'],
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),

            // Product description (example)
            Text(
              'Description: ${widget.product['specifications'] ?? 'No specifications available'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Spacer(),

            // Ensure the navigation widget spans from side to side
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,  // This ensures full width
                child: NavigationWidget(
                  onIndexChanged: _onIndexChanged,
                  selectedIndex: _selectedIndex,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
