import 'package:e_shop_app/models/order.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:e_shop_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../widgets/navigation.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  void _cancelOrder(BuildContext context, int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    final success = await ApiService.cancelOrder(orderId, userId!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order has been canceled successfully.')),
      );
      Navigator.pushNamed(context, "/orders");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel the order.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthHelper.checkLoginStatus(context);
    final double totalPrice = order.totalPrice;
    var orderStatus = order.status ? "Delivered" : "Not Delivered";
    Color statusColor = order.status == true ? Colors.green : Colors.red;

    final groupedItems = <int, List<Item>>{};
    for (var item in order.itemsInOrder) {
      if (!groupedItems.containsKey(item.id)) {
        groupedItems[item.id] = [];
      }
      groupedItems[item.id]!.add(item);
    }

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.indigo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \n${totalPrice.toStringAsFixed(0)} ден.',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          orderStatus,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (!order.status)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () => _cancelOrder(context, order.id),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 40),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Cancel Order'),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedItems.length,
                    itemBuilder: (context, index) {
                      final itemGroup = groupedItems.values.elementAt(index);
                      final item = itemGroup.first;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      item.imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${item.price.toStringAsFixed(0)} ден",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Quantity: ${itemGroup.length}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
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
              onIndexChanged: (index) {},
              selectedIndex: 2,
            ),
          ),
        ],
      ),
    );
  }
}
