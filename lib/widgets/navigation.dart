import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  final Color backgroundColor;
  final int selectedIndex; // Accept selected index from parent
  final Function(int) onIndexChanged; // Callback function to notify parent

  const NavigationWidget({
    this.backgroundColor = Colors.indigo,
    required this.selectedIndex, // Accept the selected index
    required this.onIndexChanged, // Make sure to pass the callback
    super.key,
  });

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _selectedIndex = 0; // Track the selected index

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.selectedIndex; // Initialize the selected index from parent
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Search icon
          _buildIconButton(
            index: 0,
            icon: Icons.search,
            label: 'Search',
            onTap: () {
              setState(() {
                _selectedIndex = 0; // Update selected index
              });
              widget.onIndexChanged(
                  _selectedIndex); // Call the callback to notify parent
              Navigator.pushNamed(
                  context, '/items'); // Navigate to Search screen
            },
            isSelected: _selectedIndex == 0,
          ),
          // Cart icon
          _buildIconButton(
            index: 1,
            icon: Icons.shopping_cart,
            label: 'Cart',
            onTap: () {
              setState(() {
                _selectedIndex = 1; // Update selected index
              });
              widget.onIndexChanged(_selectedIndex); // Notify parent
              Navigator.pushNamed(context, '/cart'); // Navigate to Cart screen
            },
            isSelected: _selectedIndex == 1,
          ),
          // Profile icon
          _buildIconButton(
            index: 2,
            icon: Icons.account_circle,
            label: 'Profile',
            onTap: () {
              setState(() {
                _selectedIndex = 2; // Update selected index
              });
              widget.onIndexChanged(_selectedIndex); // Notify parent
              Navigator.pushNamed(
                  context, '/profile'); // Navigate to Profile screen
            },
            isSelected: _selectedIndex == 2,
          ),
        ],
      ),
    );
  }

  // Helper method to build each icon button
  Widget _buildIconButton({
    required int index,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.deepOrangeAccent : Colors.white,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.deepOrangeAccent : Colors.white),
        ),
      ],
    );
  }
}
