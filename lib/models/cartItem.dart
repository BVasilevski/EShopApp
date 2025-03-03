class CartItem {
  final int id;
  final String itemName;
  final double price;
  final String imageUrl;
  final int quantity;

  CartItem({required this.id, required this.itemName, required this.price, required this.imageUrl, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      itemName: json['itemName'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}