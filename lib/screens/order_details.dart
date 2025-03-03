// import 'package:e_shop_app/models/order.dart';
// import 'package:e_shop_app/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import '../widgets/navigation.dart';

// class OrderDetailsScreen extends StatelessWidget {
//   final List<Order> order;

//   const OrderDetailsScreen({super.key, required this.order});

//   @override
//   Widget build(BuildContext context) {
//     AuthHelper.checkLoginStatus(context);
//     // Sample items for this order

//     final double totalPrice = order.fold(0.0, (sum, item) {
//       return sum + item.price;
//     });
//     const String orderStatus = 'Delivered';
//     Color statusColor = orderStatus == 'Delivered' ? Colors.green : Colors.red;

//     return Scaffold(
//       backgroundColor: Colors.blueAccent,
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 0),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   color: Colors.indigo,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Total: \n\$${totalPrice.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 16.0),
//                         decoration: BoxDecoration(
//                           color: statusColor,
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         child: const Text(
//                           orderStatus,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: orderItems.length,
//                     itemBuilder: (context, index) {
//                       final item = orderItems[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         elevation: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 child: Image.network(
//                                   item['image']!,
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       item['category']!,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blueAccent,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       item['name']!,
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blueAccent,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4), // Spacer
//                                     Text(
//                                       item['price']!,
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.blueAccent,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: NavigationWidget(
//               onIndexChanged: (index) {},
//               selectedIndex: 2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
