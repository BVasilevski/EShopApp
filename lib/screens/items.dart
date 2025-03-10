import 'dart:convert';
import 'package:e_shop_app/models/item.dart';
import 'package:e_shop_app/services/api_service.dart';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/navigation.dart';
import 'item_details.dart';
import 'map.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final List<String> categories = ['CPU', 'GPU', 'RAM' , 'PSU', 'STORAGE', 'MOTHERBOARD'];
  int _selectedIndex = 0;
  List<Item> originalProducts= [];
  String selectedCategory = 'CPU';
  String searchQuery = '';

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getItemsFromAPI(String category) {
    ApiService.getItemsByCategory(category).then((response) {
      var data = json.decode(response.body);
      if (data is List) {
        setState(() {
          originalProducts = data.map<Item>((json) => Item.fromJson(json)).toList();
        });
      } else {
        print("Unexpected API response format");
      }
    }).catchError((error) {
      print("Error fetching items: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    getItemsFromAPI(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    AuthHelper.checkLoginStatus(context);
    List<Item> products = originalProducts
        .where((product) =>
            product.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search for products...',
                      hintStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.map, color: Colors.white),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == selectedCategory;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          searchQuery = '';
                        });
                        getItemsFromAPI(category);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenSize.width > 600 ? 3 : 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: screenSize.width / (screenSize.height * 0.8),
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsScreen(product: product.toJson()),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenSize.height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(product.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${product.price.toStringAsFixed(0)}ден',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  String? userId = prefs.getString('userId');
                                  ApiService.addItemFromCart(product.id, userId!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Succesfuly added the item to cart.')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Text('Add to cart'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
