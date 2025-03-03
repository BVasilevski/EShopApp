class Order {
  final int id;
  final double price;
  final String delivered;

  Order({required this.id, required this.price, required this.delivered});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      price: json['price'].toDouble(),
      delivered: json['delivered'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'delivered': delivered,
    };
  }
}