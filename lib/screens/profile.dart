import 'package:e_shop_app/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'change_data.dart'; // Import the ChangeDataScreen if needed

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String firstAndLastName = "John Doe"; // Example user data
  final String email = "johndoe@example.com";
  int _selectedIndex = 2; // Set the default selected index to 2

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      // Set the background color of the whole page
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // Make the container full width
            padding: const EdgeInsets.all(24.0),
            // Bigger padding
            color: Colors.blueAccent,
            // Set container color same as the background
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Ensure the column is as small as possible
              crossAxisAlignment: CrossAxisAlignment.center,
              // Center the children
              children: [
                // User Icon at the top
                const CircleAvatar(
                  radius: 50, // Size of the avatar
                  backgroundColor: Colors.white, // Avatar background color
                  child: Icon(
                    Icons.account_circle, // Icon for the user
                    size: 80, // Icon size
                    color: Colors.blueAccent, // Icon color
                  ),
                ),
                const SizedBox(height: 24),
                // Spacer between icon and the text content

                // First and Last Name Label and Value
                const Text(
                  'First and Last Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // Bigger text size
                    color: Colors
                        .black, // Text color for visibility on the blue background
                  ),
                ),
                Text(
                  firstAndLastName,
                  style: const TextStyle(
                      fontSize: 22, color: Colors.white), // Bigger text size
                ),
                const SizedBox(height: 24),
                // Bigger spacing

                // Email Label and Value
                const Text(
                  'Email:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // Bigger text size
                    color: Colors
                        .black, // Text color for visibility on the blue background
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                      fontSize: 22, color: Colors.white), // Bigger text size
                ),
                const SizedBox(height: 48),
                // Bigger spacing between fields and buttons

                // Change Data Button with Orange Color and Larger Size
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Change Data Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeDataScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    // Set the button color to orange
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    // Bigger button padding
                    textStyle: const TextStyle(
                        fontSize: 20), // Bigger text size in the button
                  ),
                  child: const Text('Change Data'),
                ),
                const SizedBox(height: 24),
                // Bigger spacing

                // Log Out Button with Orange Color and Larger Size
                ElevatedButton(
                  onPressed: () {
                    // Log out logic goes here
                    // Right now, it does nothing
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    // Set the button color to orange
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    // Bigger button padding
                    textStyle: const TextStyle(
                        fontSize: 20), // Bigger text size in the button
                  ),
                  child: const Text('Log Out'),
                ),
                const SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
      // Navigation bar at the bottom outside the padding
      bottomNavigationBar: NavigationWidget(
        onIndexChanged: _onIndexChanged,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
