import 'package:fluffyn/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluffyn/models/product_model.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.network(
          product.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(product.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${product.rating.rate}'),
                const SizedBox(width: 6),
                Text('(${product.rating.count} reviews)',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.shopping_cart),
        onTap: () {
          // Optional: Navigate to detail or add to cart 
         Get.to(() => ProductDetailPage(product: product));
        },
      ),
    );
  }
}
