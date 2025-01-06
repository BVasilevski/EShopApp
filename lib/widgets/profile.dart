import 'package:flutter/material.dart';

import '../screens/change_data.dart';

class ProfileWidget extends StatelessWidget {
  final String firstAndLastName;
  final String email;

  const ProfileWidget(
      {super.key, required this.firstAndLastName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First and Last Name Label and Value
          const Text(
            'First and Last Name:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            firstAndLastName,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16), // Spacer between fields

          // Email Label and Value
          const Text(
            'Email:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            email,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32), // Spacer between fields and buttons

          // Change Data Button
          ElevatedButton(
            onPressed: () {
              // Navigate to another screen for changing data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeDataScreen(),
                ),
              );
            },
            child: const Text('Change Data'),
          ),
          const SizedBox(height: 16), // Spacer between buttons

          // Log Out Button
          ElevatedButton(
            onPressed: () {
              // Log out logic goes here
              // Right now, it does nothing
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }}
