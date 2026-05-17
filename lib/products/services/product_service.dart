import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_http_provider/core/constants/api_constants.dart';
import 'package:flutter_http_provider/products/models/product.dart';

class ProductService {
  ProductService({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<List<Product>> getProducts() async {
    final response = await _client.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProductById(int id) async {
    final response = await _client.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productById(id)}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch product: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson(decoded);
  }

  Future<Product> createProduct(Product product) async {
    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create product: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson(decoded);
  }

  Future<Product> updateProduct(Product product) async {
    if (product.id == null) {
      throw ArgumentError('Product id is required for updates.');
    }

    final response = await _client.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productById(product.id!)}'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson(decoded);
  }

  Future<void> deleteProduct(int id) async {
    final response = await _client.delete(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productById(id)}'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }
}
