import 'package:flutter/foundation.dart';
import 'package:flutter_http_provider/products/models/product.dart';
import 'package:flutter_http_provider/products/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({required ProductService service}) : _service = service;

  final ProductService _service;

  final List<Product> _products = <Product>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products
        ..clear()
        ..addAll(await _service.getProducts());
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProduct(Product product) async {
    
    print('Create product: ${product.title}');
  }

  Future<void> updateProduct(Product product) async {
    
    print('Update product: ${product.id}');
  }

  Future<void> patchProduct(int id, Map<String, dynamic> data) async {
    
    print('Patch product: $id');
  }

  Future<void> deleteProduct(int id) async {
    // Stub for UI development
    print('Delete product: $id');
  }
}
