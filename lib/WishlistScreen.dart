import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  final List<Map<String, String>> favoriteProducts;

  WishlistScreen(this.favoriteProducts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Wishlist'),
      ),
      body: ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset('assets/${favoriteProducts[index]["image"]}',
                width: 50),
            title: Text(favoriteProducts[index]["label"] ?? 'Product'),
            subtitle: Text(favoriteProducts[index]["price"] ?? 'Price'),
          );
        },
      ),
    );
  }
}
