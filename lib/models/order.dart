import 'package:e_shop_app/models/item.dart';

class Order {
  final int id;
  final double totalPrice;
  final List<Item>itemsInOrder;
  final bool status;

  Order({required this.id, required this.totalPrice, required this.itemsInOrder,required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
  return Order(
    id: json['id'],
    totalPrice: (json['totalPrice'] as num).toDouble(),
    itemsInOrder: (json['itemsInOrder'] as List)
        .map((item) => Item.fromJson(item))
        .toList(),
    status: json['status'],
  );
}

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'price': totalPrice,
    'itemsInOrder': itemsInOrder.map((item) => item.toJson()).toList(),
    'status': status,
  };
}
}