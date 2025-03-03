import 'package:e_shop_app/models/user.dart';
import 'package:e_shop_app/screens/edit_profile.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:e_shop_app/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstAndLastName = "";
  String email = "";
  int _selectedIndex = 2;
  User? Curruser;

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void setProfileInfo() async {
    
    final prefs = await SharedPreferences.getInstance();
    
    Curruser = User(id:prefs.getString('userId')!,firstName:prefs.getString('firstName')!,lastName:prefs.getString('lastName')!,email:prefs.getString('email')!);
  
    setState(() {
      firstAndLastName = '${Curruser?.firstName} ${Curruser?.lastName}';
      email = Curruser!.email;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    AuthHelper.checkLoginStatus(context);
    setProfileInfo();
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
                        builder: (context) => EditProfileScreen(user: Curruser),
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
                  onPressed: () async {
                     SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('userId');
                      await prefs.remove('firstName');
                      await prefs.remove('lastName');
                      await prefs.remove('email');
                      Navigator.pushReplacementNamed(context, '/login');
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
