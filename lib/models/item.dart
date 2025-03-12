import 'package:e_shop_app/models/item_rating.dart';

class Item {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String? description;
  final List<ItemRating>? itemRatings;

  Item({required this.id, required this.name, required this.price, required this.imageUrl, required this.description, required this.itemRatings});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      description: json['description'],
      itemRatings: (json['itemRatings'] as List?)?.map((rating) => ItemRating.fromJson(rating)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'itemRatings': itemRatings,
    };
  }
}