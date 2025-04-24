import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluffyn/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  
  CartItem({required this.product, this.quantity = 1});
}

class CartController extends GetxController {
  final _cartItems = <CartItem>[].obs;
  
  List<CartItem> get cartItems => _cartItems;
  
  void addItem(Product product) {
    final existingItemIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    
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
  }
  
  void removeItem(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
  }
  
  void incrementQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
      _cartItems.refresh();
    }
  }
  
  void decrementQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        removeItem(product);
      }
      _cartItems.refresh();
    }
  }
  
  double get subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }
  
  double get tax => subtotal * 0.08; // 8% tax rate
  
  double get total => subtotal + tax;
  
  void clearCart() {
    _cartItems.clear();
  }
  
  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}