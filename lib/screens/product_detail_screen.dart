import 'package:flutter/material.dart';
import 'package:fluffyn/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(product.title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.green)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text('${product.rating.rate} ⭐'),
                const SizedBox(width: 10),
                Text('(${product.rating.count} reviews)',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Text('Category: ${product.category}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
