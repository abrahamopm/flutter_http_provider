import 'package:flutter/material.dart';
import 'package:flutter_http_provider/widgets/tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ProductCard(
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Electronics',
        productName: 'Product Name',
        price: '\$99.99',
        stock: 10,
        isNew: true,
      ),
    );
  }
}