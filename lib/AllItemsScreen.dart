import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AllItemsScreen extends StatefulWidget {
  @override
  _AllItemsScreenState createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  List<bool> isFavoritedList = List.generate(10, (index) => false);
  List<Map<String, String>> gridProductData = [
    {
      "image": "vans old skool.png",
      "label": "Shoe",
      "price": "₹999",
      "discount": "10% Off",
      "rating": "4.2"
    },
    {
      "image": "watch2.png",
      "label": "Watch",
      "price": "₹1,299",
      "discount": "15% Off",
      "rating": "4.7"
    },
    {
      "image": "shops-1.png",
      "label": "AirPods",
      "price": "₹9,999",
      "discount": "5% Off",
      "rating": "4.5"
    },
    {
      "image": "shops-2.png",
      "label": "Phone",
      "price": "₹69,999",
      "discount": "20% Off",
      "rating": "4.6"
    },
    {
      "image": "bag_1.png",
      "label": "Bag",
      "price": "₹799",
      "discount": "12% Off",
      "rating": "4.3"
    },
    {
      "image": "Air Jordan.png",
      "label": "Shoe",
      "price": "₹3,999",
      "discount": "30% Off",
      "rating": "4.1"
    },
    {
      "image": "shops-9.png",
      "label": "AirPod",
      "price": "₹5,999",
      "discount": "8% Off",
      "rating": "4.0"
    },
    {
      "image": "shops-8.png",
      "label": "Bluetooth Headset",
      "price": "₹1,499",
      "discount": "25% Off",
      "rating": "4.4"
    },
    {
      "image": "sports shoes.png",
      "label": "Sports Shoes",
      "price": "₹2,499",
      "discount": "18% Off",
      "rating": "4.8"
    },
    {
      "image": "laptop2.png",
      "label": "Laptop",
      "price": "₹79,999",
      "discount": "20% Off",
      "rating": "4.5"
    },
  ];

  List<Map<String, String>> filteredProducts = [];
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";

  @override
  void initState() {
    super.initState();
    filteredProducts = gridProductData;
    _speech = stt.SpeechToText();
// Initialize with all products
  }

  void _startListening() async {
    await _speech.initialize();
    setState(() {
      _isListening = true;
    });

    _speech.listen(onResult: (result) {
      setState(() {
        _text = result.recognizedWords;
        searchController.text = _text;
        _filterProducts(_text); // Filter products as per recognized words
      });
    });
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts =
            gridProductData; // Show all products if query is empty
      } else {
        filteredProducts = gridProductData.where((product) {
          return product["label"]!.toLowerCase().contains(query.toLowerCase());
        }).toList(); // Filter products based on the query
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        File pickedImage = File(image.path);
        // Do something with the picked image
        // For example, display it or upload it somewhere
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isSearching ? 0 : kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.teal,
          title: isSearching
              ? Container() // Hide title when searching
              : Text('All Items'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true; // Activate search mode
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Implement cart functionality here
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (isSearching)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.teal[600], // Search box background color
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isSearching = false; // Deactivate search mode
                        searchController.clear();
                        filteredProducts =
                            gridProductData; // Reset to show all products
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: _filterProducts,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.white),
                    onPressed: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              color: Colors.teal[50],
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 products per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.65, // Better height-to-width ratio
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Stack(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/${product["image"]}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    product["label"] ?? 'Product',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    product["price"] ?? 'Price',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.teal[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: List.generate(
                                          int.parse(
                                              product["rating"]!.split(".")[0]),
                                          (index) => Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        product["rating"] ?? 'Rating',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            product["discount"] ?? 'Discount',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isFavoritedList[index] = !isFavoritedList[index];
                            });
                          },
                          child: Icon(
                            isFavoritedList[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavoritedList[index]
                                ? Colors.red
                                : Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
