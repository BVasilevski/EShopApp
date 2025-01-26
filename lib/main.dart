import 'package:e_shop_app/screens/cart.dart';
import 'package:e_shop_app/screens/edit_profile.dart';
import 'package:e_shop_app/screens/items.dart';
import 'package:e_shop_app/screens/login.dart';
import 'package:e_shop_app/screens/orders.dart';
import 'package:e_shop_app/screens/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EShop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/items',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/cart': (context) => const CartScreen(),
        '/items': (context) => const ItemsScreen(),
        '/orders': (context) => const OrdersScreen()
      },
    );
  }
}
