import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'product_list_screen.dart';
import '../models/product.dart';

import 'scratch_card_screen.dart';



class ScratchCardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> productList;

  const ScratchCardScreen({super.key, required this.productList});

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  late Map<String, dynamic> selectedProduct;
  bool revealed = false;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.productList[Random().nextInt(widget.productList.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎁 Scratch & Win")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Scratcher(
              brushSize: 40,
              threshold: 50,
              color: Colors.grey,
              onThreshold: () {
                setState(() => revealed = true);
              },
              child: Container(
                height: 200,
                width: 300,
                color: Colors.amber[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("🎉 You won:", style: TextStyle(fontSize: 18)),
                    Text(selectedProduct['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (revealed)
              ElevatedButton(
                child: const Text("Add to Cart for Free"),
               onPressed: () {
  // Add selected product to cart with price = 0
  // You can import and use CartProvider if needed
  final cart = Provider.of<CartProvider>(context, listen: false);

  // Create a Product object from selectedProduct
  final freeProduct = Product(
    id: selectedProduct['id'],
    name: selectedProduct['name'],
    price: 0.0, // Free
    image: selectedProduct['image'] ?? '',
    description: selectedProduct['description'] ?? '',
  );

  // Add it to the cart
  cart.addToCart(freeProduct);

  // Navigate back to product list
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => ProductListScreen()),
  );
}

              )
          ],
        ),
      ),
    );
  }
}
