import 'package:flutter/material.dart';
import 'package:shop_app/AllItemsScreen.dart';
import 'package:shop_app/QRScannerScreen.dart';
import 'package:shop_app/WishlistScreen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.teal[50], // Background for entire app
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[50], // AppBar background color
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // BottomNavigationBar background color
          selectedItemColor: Colors.teal[700],
          unselectedItemColor: Colors.teal[400],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isFavorited = false;
  final List<String> items = List.generate(10, (index) => 'Item $index');
  List<bool> isFavoritedList = List.generate(10, (_) => false);
  List<Map<String, String>> favoriteProducts = [];
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String result = '';

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Search products...';
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredProducts = [];
  // List to track which items are favorited (initially all false)
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
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page')),
    Center(child: Text('Categories')),
    Center(child: Text('My Orders')),
    Center(child: Text('Cart')),
    Center(child: Text('Account')),
  ];

  get controller => null;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                }));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WishlistScreen(favoriteProducts)),
    );
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

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (error) => print('onError: $error'),
    );

    if (available) {
      setState(() => _isListening = true);

      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
          searchController.text = _text;
          _filterProducts(_text); // Filter products as per recognized words
        });
      });
    } else {
      setState(() {
        _isListening = false;
      });
      print('Speech recognition is not available.');
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// Assuming this is the other function that was also named _onItemTapped
  void _onProductTapped(int index) {
    // Your logic for tapping a product
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
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'ShopEase',
              style: TextStyle(
                color: Colors.teal[700],
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: _navigateToWishlist,
            ),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.teal[600]),
              onPressed: () {},
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.search, color: Colors.teal[600]),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.teal[400]),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.teal[600]),
                    onPressed: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.teal[600]),
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner, color: Colors.teal[600]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRScannerScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Swipeable Banners
            Container(
              height: 200, // Height of the banner
              child: PageView(
                children: [
                  Image.asset(
                    'assets/abc.jpg', // Banner 1 image
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'assets/banner-2.png', // Banner 2 image
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Space between banner and products
            // Swipeable Circular Product Carousel
            SizedBox(
              height: 120, // Height of the circular product carousel
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6, // Number of products
                itemBuilder: (context, index) {
                  // List of circular product images and labels
                  List<Map<String, String>> productData = [
                    {"image": "shoes.png", "label": "Shoes"},
                    {"image": "watch2.png", "label": "Watch"},
                    {"image": "headphone2.png", "label": "Headphone"},
                    {"image": "laptop2.png", "label": "Laptop"},
                    {"image": "bag_1.png", "label": "Bag"},
                    {"image": "beauty.jpg", "label": "Coconut Oil"},
                  ];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        // Circular product image
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/${productData[index]["image"]}', // Dynamic product image
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5), // Space between image and text
                        Text(productData[index]["label"] ?? 'Product'),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Special For You',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to the AllItemsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllItemsScreen()),
                    );
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(color: Colors.teal[600]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView.builder(
                physics:
                    NeverScrollableScrollPhysics(), // Disable Grid scrolling
                shrinkWrap: true, // Make Grid take only necessary space
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 products per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      0.65, // Adjust this value for better height-to-width ratio
                ),
                itemCount: 10, // Number of products
                itemBuilder: (context, index) {
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
                    {
                      "image": "beauty.jpg",
                      "label": "Coconut Oil",
                      "price": "₹799",
                      "discount": "12% Off",
                      "rating": "4.3"
                    },
                  ];

                  return Stack(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // Product image
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/${gridProductData[index]["image"]}', // Dynamic product image
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
                                    gridProductData[index]["label"] ??
                                        'Product',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    gridProductData[index]["price"] ?? 'Price',
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
                                          int.parse(gridProductData[index]
                                                  ["rating"]!
                                              .split(".")[0]),
                                          (index) => Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        gridProductData[index]["rating"] ??
                                            'Rating',
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
                            gridProductData[index]["discount"] ?? 'Discount',
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
                                // Toggle favorite state for the specific item
                                isFavoritedList[index] =
                                    !isFavoritedList[index];
                              });
                            },
                            child: Icon(
                              isFavoritedList[index]
                                  ? Icons.favorite
                                  : Icons
                                      .favorite_border, // Toggle between filled and outlined heart
                              color: isFavoritedList[index]
                                  ? Colors.red
                                  : Colors.grey, // Change color based on state
                              size: 24,
                            )
                            // Adjust size as needed
                            ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[700],
        unselectedItemColor: Colors.teal[400],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}
