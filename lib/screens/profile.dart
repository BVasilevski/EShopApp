import 'package:e_shop_app/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'change_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String firstAndLastName = "Test Testovski";
  final String email = "test@gmail.com";
  int _selectedIndex = 2;

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
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            color: Colors.blueAccent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'First and Last Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors
                        .black,
                  ),
                ),
                Text(
                  firstAndLastName,
                  style: const TextStyle(
                      fontSize: 22, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Email:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors
                        .black,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                      fontSize: 22, color: Colors.white),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/orders');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    textStyle: const TextStyle(
                        fontSize: 20),
                  ),
                  child: const Text('My Orders'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeDataScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    textStyle: const TextStyle(
                        fontSize: 20),
                  ),
                  child: const Text('Change Data'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Log out logic goes here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    textStyle: const TextStyle(
                        fontSize: 20),
                  ),
                  child: const Text('Log Out'),
                ),
                const SizedBox(height: 300),
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
