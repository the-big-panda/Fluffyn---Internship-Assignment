import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluffyn/models/product_model.dart';
import 'package:get_storage/get_storage.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class CartController extends GetxController {
  final _cartItems = <CartItem>[].obs;
  final box = GetStorage();

  List<CartItem> get cartItems => _cartItems;

  @override
  void onInit() {
    super.onInit();
    // Make sure GetStorage is initialized
    ever(
        _cartItems,
        (_) =>
            saveCartToStorage()); // Optional: automatically save when cart changes
    loadCartFromStorage();
  }

  void addItem(Product product) {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex >= 0) {
      incrementQuantity(product);
    } else {
      _cartItems.add(CartItem(product: product));
      Get.snackbar(
        "Added to Cart",
        "${product.title} has been added to your cart",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color.fromRGBO(255, 86, 86, 0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 10,
        duration: Duration(seconds: 2),
      );
    }
    saveCartToStorage(); // Make sure to save to storage when an item is added
  }

  void removeItem(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    saveCartToStorage(); // Save after removing an item
  }

  void saveCartToStorage() {
    List<Map<String, dynamic>> cartJson =
        cartItems.map((item) => item.toJson()).toList();
    box.write('cart', cartJson);
  }

  void loadCartFromStorage() {
    try {
      final stored = box.read('cart');
      print(stored);
      if (stored != null && stored is List) {
        final List<dynamic> storedList = stored;
        final cartData = storedList
            .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _cartItems.assignAll(cartData);
      }
    } catch (e) {
      print('Error loading cart from storage: $e');
    }
  }

  void incrementQuantity(Product product) {
    final index =
        _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
      _cartItems.refresh();
      saveCartToStorage(); // Save after incrementing quantity
    }
  }

  void decrementQuantity(Product product) {
    final index =
        _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        removeItem(product);
      }
      _cartItems.refresh();
      saveCartToStorage(); // Save after decrementing quantity
    }
  }

  double get subtotal {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double get tax => subtotal * 0.08; // 8% tax rate

  double get total => subtotal + tax;

  void clearCart() {
    _cartItems.clear();
    saveCartToStorage(); // Save after clearing cart
  }

  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
