import 'package:flutter/foundation.dart';
import 'package:flutter_http_provider/features/data/models/product.dart';
import 'package:flutter_http_provider/features/data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({required ProductRepository repository}) : _repository = repository;

  final ProductRepository _repository;

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
        ..addAll(await _repository.getProducts());
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
