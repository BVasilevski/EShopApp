import 'package:e_shop_app/services/api_service.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:e_shop_app/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReviewScreen extends StatefulWidget {
  final int itemId;

  const AddReviewScreen({super.key, required this.itemId});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int _selectedIndex = 0;
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

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
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Write a Review',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _ratingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Rating (1-10)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Your Comment',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Will handle photo taking later
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                    backgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 5,
                  ),
                  child: const Text('Take a Photo'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    String? userId = prefs.getString('userId');
                    final rating = int.tryParse(_ratingController.text);
                    if (rating == null || rating < 1 || rating > 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enter a valid rating between 1 and 10.'),
                        ),
                      );
                      return;
                    }
                    final comment = _commentController.text;
                    final result = await ApiService.addRatingForItem(
                      widget.itemId,
                      userId!,
                      rating,
                      comment,
                    );

                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Review submitted successfully!'),
                        ),
                      );
                      Navigator.pushNamed(context, "/items");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Failed to submit the review. Please try again.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 5,
                  ),
                  child: const Text('Submit Review'),
                ),
                const SizedBox(height: 20),
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
