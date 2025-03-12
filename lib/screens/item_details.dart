import 'package:e_shop_app/models/item.dart';
import 'package:e_shop_app/services/api_service.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:e_shop_app/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_review.dart';

class ItemDetailsScreen extends StatefulWidget {
  final int itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Future<Item?> _itemFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _itemFuture = ApiService.getDetailsForItem(widget.itemId);
  }

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
      body: SafeArea(
        child: FutureBuilder<Item?>(
          future: _itemFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Center(
                child: Text("Failed to load item.",
                    style: TextStyle(color: Colors.white)),
              );
            }

            final item = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                _buildItemImage(item.imageUrl),
                const SizedBox(height: 16),
                _buildItemDetails(item),
                const SizedBox(height: 20),
                _buildActionButtons(item),
                const SizedBox(height: 30),
                _buildCustomerReviews(item),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationWidget(
          onIndexChanged: _onIndexChanged, selectedIndex: _selectedIndex),
    );
  }

  Widget _buildItemImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.black.withOpacity(0.6),
        ),
        child: Image.network(
          imageUrl,
          height: 400,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildItemDetails(Item item) {
    return Column(
      children: [
        Text(
          item.name,
          style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "${item.price.toString()} ден",
          style: const TextStyle(
              fontSize: 22, color: Colors.green, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          item.description ?? "No description available",
          style: const TextStyle(fontSize: 16, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons(Item item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            String? userId = prefs.getString('userId');
            if (userId != null) {
              ApiService.addItemFromCart(item.id, userId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Successfully added the item to cart.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: const Text('Add to Cart'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddReviewScreen(itemId: item.id)),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            backgroundColor: Colors.amberAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: const Text('Add Review'),
        ),
      ],
    );
  }

  Widget _buildCustomerReviews(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Customer Reviews",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        if (item.itemRatings != null && item.itemRatings!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item.itemRatings!.length,
            itemBuilder: (context, index) {
              final rating = item.itemRatings![index];
              return _buildReviewCard(rating);
            },
          )
        else
          const Text("No reviews yet.",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }

  Widget _buildReviewCard(itemRating) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Review from: ${itemRating.userEmail}"),
            const SizedBox(height: 5),
            Text(
              "Rating: ⭐ ${itemRating.rating}",
              style: const TextStyle(color: Colors.yellow, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text("Comment: ${itemRating.comment}",
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 10),
            if (itemRating.userImageUrl != null &&
                itemRating.userImageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  itemRating.userImageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
