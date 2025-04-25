import 'dart:io';

import 'package:fluffyn/controllers/cartcontroller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluffyn/models/product_model.dart';
// Removed duplicate import: import 'package:fluffyn/controllers/cartcontroller.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  // Use GetX controller to manage cart state
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Shopping Cart",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          // Background Design
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 230, 242, 255),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // Section Title
          Positioned(
            top: 15,
            left: 24,
            child: Text(
              "Your Items",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // Main Content
          Obx(() {
            if (cartController.cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.black12,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your cart is empty",
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add some products to get started",
                      style: GoogleFonts.poppins(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 86, 86, 0.8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'CONTINUE SHOPPING',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 50, bottom: 150, left: 20, right: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartController.cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: CartItemCard(cartItem: cartItem),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),

          // Bottom Checkout Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return SizedBox(); // Hide if cart is empty
              }

              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, -5),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Price Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "\$${cartController.subtotal.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tax",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "\$${cartController.tax.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(thickness: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "\$${cartController.total.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(255, 86, 86, 0.8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Checkout Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar(
                            "Processing Order",
                            "Your order is being processed",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Color.fromRGBO(255, 86, 86, 0.8),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(16),
                            borderRadius: 10,
                            duration: Duration(seconds: 2),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 86, 86, 0.8),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'CHECKOUT',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Dismissible(
          key: Key(cartItem.product.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
          onDismissed: (direction) {
            cartController.removeItem(cartItem.product);
            Get.snackbar(
              "Item Removed",
              "${cartItem.product.title} was removed from your cart",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade400,
              colorText: Colors.white,
              margin: EdgeInsets.all(16),
              borderRadius: 10,
              duration: Duration(seconds: 2),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Hero(
                tag: 'cart-${cartItem.product.id}',
                child: Container(
                  width: 100,
                  height: 100,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: cartItem.product.image.startsWith('http')
                      ? Image.network(cartItem.product.image)
                      : Image.file(File(cartItem.product.image)),
                ),
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.product.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "\$${cartItem.product.price.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(255, 86, 86, 0.8),
                        ),
                      ),
                      SizedBox(height: 8),

                      // Quantity Control
                      Row(
                        children: [
                          InkWell(
                            onTap: () => cartController
                                .decrementQuantity(cartItem.product),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.remove, size: 16),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "${cartItem.quantity}",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => cartController
                                .incrementQuantity(cartItem.product),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 86, 86, 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.add,
                                  size: 16,
                                  color: Color.fromRGBO(255, 86, 86, 0.8)),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Removed the duplicate CartItem class definition
