import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  final Function(BuildContext) onSearchTap;
  final Function(BuildContext) onCartTap;
  final Function(BuildContext) onProfileTap;
  final Color backgroundColor;

  const NavigationWidget({
    required this.onSearchTap,
    required this.onCartTap,
    required this.onProfileTap,
    this.backgroundColor = Colors.white,
    super.key,
  });

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _selectedIndex = 0; // Track the selected index (0 = Search, 1 = Cart, 2 = Profile)

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
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
                _selectedIndex = 0;
              });
              widget.onSearchTap(context); // Pass context for navigation
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
                _selectedIndex = 1;
              });
              widget.onCartTap(context); // Pass context for navigation
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
                _selectedIndex = 2;
              });
              widget.onProfileTap(context); // Pass context for navigation
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
          style: TextStyle(fontSize: 14, color: isSelected ? Colors.deepOrangeAccent : Colors.white),
        ),
      ],
    );
  }
}
