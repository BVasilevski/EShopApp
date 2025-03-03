import 'package:e_shop_app/models/user.dart';
import 'package:e_shop_app/services/api_service.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:e_shop_app/widgets/input_field.dart';
import 'package:e_shop_app/widgets/navigation.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;
  const EditProfileScreen({super.key, this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String email;
  late String firtsAndLastName;
  int _selectedIndex = 2;

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
                    color: Colors.black,
                  ),
                ),
                InputField(
                  labelText: "Enter first and last name",
                  onChanged: (value) {
                    setState(() {
                    firtsAndLastName = value;
                    });
                    },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Email:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                InputField(
                  onChanged: (value) {
                    setState(() {
                    email = value;
                    });
                    },
                  labelText: "Enter email",
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () async {
                    bool succ = await ApiService.editUser(widget.user!.id.toString(),email, firtsAndLastName);
                    if (succ){
                      Navigator.pushReplacementNamed(context, '/profile'); 
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Editing failed. Try again.')),
                        );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Save changes'),
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
