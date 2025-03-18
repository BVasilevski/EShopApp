import 'dart:convert';

import 'package:e_shop_app/models/order.dart';
import 'package:e_shop_app/services/api_service.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/navigation.dart';
import 'order_details.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];

  int _selectedIndex = 2;
  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _viewOrderDetails(Order order) {
    Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => OrderDetailsScreen(order: order),
     ),
   );
  }

  void getItemsFromAPI(String userId) {
    ApiService.getOrders(userId).then((response) {
      var data = json.decode(response.body);
      print(data);
      if (data is List) {
        setState(() {
          orders = data.map<Order>((json) => Order.fromJson(json)).toList();
        });
      } else {
        print("Unexpected API response format");
      }
    }).catchError((error) {
      print("Error fetching items: $error");
    });
  }

  Future<void> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    getItemsFromAPI(userId!);
  }
  @override
  void initState()  {
    super.initState();
    getOrders(); 
  }
  @override
  Widget build(BuildContext context) {
    AuthHelper.checkLoginStatus(context);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: GestureDetector(
                          onTap: () => _viewOrderDetails(order),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${index + 1}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Total: ${order.totalPrice.toStringAsFixed(0)}ден.',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NavigationWidget(
              onIndexChanged: _onIndexChanged,
              selectedIndex: _selectedIndex,
            ),
          ),
        ],
      ),
    );
  }
}
