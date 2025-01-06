import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import 'item_details.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  // List of categories
  final List<String> categories = ['CPU', 'GPU', 'PSU', 'Storage'];
  int _selectedIndex = 0;

  // Map of products for each category
  final Map<String, List<Map<String, dynamic>>> products = {
    'CPU': [
      {
        'name': 'Intel Core i7 4970k',
        'price': '\$300',
        'image':
            'https://cdn.mos.cms.futurecdn.net/2ec3b0c81bfb0efa1e92aa64011a1133.jpg',
        'specifications': '8 cores, 16 threads, 3.6 GHz base clock',
      },
      {
        'name': 'AMD Ryzen 5 3600x',
        'price': '\$250',
        'image': 'https://m.media-amazon.com/images/I/81b75EQJrgL.jpg',
        'specifications': '6 cores, 12 threads, 3.4 GHz base clock',
      },
      {
        'name': 'Intel Core i5 7400',
        'price': '\$100',
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbARdid9zKeXZugWMinxvCvjkCLDi-jN7axA&s',
        'specifications': '4 cores, 4 threads, 3.0 GHz base  clock'
      }
    ],
    'GPU': [
      {
        'name': 'NVIDIA RTX 3070',
        'price': '\$500',
        'image': 'https://m.media-amazon.com/images/I/81761uwFaIL.jpg',
        'specifications': '8 GB GDDR6, 5888 CUDA cores',
      },
      {
        'name': 'AMD RX 6800',
        'price': '\$450',
        'image':
            'https://i5.walmartimages.com/seo/MSI-AMD-Radeon-RX-6800-XT-Graphic-Card-16-GB-GDDR6_0fd1c7b5-df1d-4fc1-985a-364ddc4dda59.b292ce3bf9775e51284b248cfd01bbf2.jpeg',
        'specifications': '16 GB GDDR6, 3840 stream processors',
      },
    ],
  };

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String selectedCategory = 'CPU';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter products based on search query
    List<Map<String, dynamic>> filteredProducts = products[selectedCategory]!
        .where((product) =>
            product['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Top padding

          // Search bar above categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          // Spacing between search bar and categories

          // Categories list (horizontally scrollable)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
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
                          searchQuery =
                              ''; // Reset search query when category changes
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
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
                              color:
                                  isSelected ? Colors.white : Colors.blueAccent,
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

          // Products grid for selected category
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1, // Adjusted aspect ratio for smaller cards
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the ItemDetailsScreen when tapping on the card
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsScreen(
                          product:
                              product, // Passing the selected product to the details screen
                        ),
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
                        // Product image
                        Container(
                          height: 150, // Reduced image height
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(product['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6), // Reduced spacing

                        // Product name
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Center(
                              child: Text(
                                product['name'],
                                style: const TextStyle(
                                  fontSize: 14, // Reduced font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),

                        // Product price and Add to Cart button
                        const Spacer(), // Push content to the bottom
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product['price'],
                                style: const TextStyle(
                                  fontSize: 14, // Reduced font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Add to Cart functionality goes here
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  textStyle: const TextStyle(
                                      fontSize: 12), // Reduced button font size
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
          // Navigation bar at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: NavigationWidget(
              onIndexChanged: _onIndexChanged,
              selectedIndex: _selectedIndex,
            ),
          )
        ],
      ),
    );
  }
}
