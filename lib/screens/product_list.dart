import 'package:fluffyn/wigdets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluffyn/controllers/product_contoller.dart';
// fix the typo here

class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Our Products",
          style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(24, 96, 96, 250),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(189, 225, 240, 0.385),
        ),
        child: Obx(() {
          if (productController.productList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: productController.productList.length,
              itemBuilder: (context, index) {
                final product = productController.productList[index];
                return ProductCard(product: product);
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new product (local only)
        },
        backgroundColor: const Color.fromRGBO(255, 86, 86, 0.69),
        child: const Icon(Icons.add),
      ),
    );
  }
}
