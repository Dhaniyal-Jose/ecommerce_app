import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() => {
        'product': {
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'image': product.image,
          'description': product.description,
        },
        'quantity': quantity,
      };

  static CartItem fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    return CartItem(
      product: Product(
        id: productJson['id'],
        name: productJson['name'],
        price: productJson['price'],
        image: productJson['image'],
        description: productJson['description'],
      ),
      quantity: json['quantity'],
    );
  }
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(
    0.0,
    (sum, item) => sum + item.product.price * item.quantity,
  );

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  CartProvider() {
    loadCart(); // Load from storage on init
  }

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product));
    }
    saveCart();
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      saveCart();
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    saveCart();
    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartData =
        _items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('cart', cartData);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartData = prefs.getStringList('cart');

    if (cartData != null) {
      _items.clear();
      _items.addAll(cartData.map((e) => CartItem.fromJson(jsonDecode(e))));
      notifyListeners();
    }
  }
}
