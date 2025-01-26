import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  final Color backgroundColor;
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const NavigationWidget({
    this.backgroundColor = Colors.indigo,
    required this.selectedIndex,
    required this.onIndexChanged,
    super.key,
  });

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.selectedIndex;
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
          _buildIconButton(
            index: 0,
            icon: Icons.search,
            label: 'Search',
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              widget.onIndexChanged(
                  _selectedIndex);
              Navigator.pushNamed(
                  context, '/items');
            },
            isSelected: _selectedIndex == 0,
          ),
          _buildIconButton(
            index: 1,
            icon: Icons.shopping_cart,
            label: 'Cart',
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              widget.onIndexChanged(_selectedIndex);
              Navigator.pushNamed(context, '/cart');
            },
            isSelected: _selectedIndex == 1,
          ),
          _buildIconButton(
            index: 2,
            icon: Icons.account_circle,
            label: 'Profile',
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              widget.onIndexChanged(_selectedIndex);
              Navigator.pushNamed(
                  context, '/profile');
            },
            isSelected: _selectedIndex == 2,
          ),
        ],
      ),
    );
  }

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
