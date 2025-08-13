import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedCategory = '';

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final categories = _products.map((product) => product.category).toSet().toList();
    categories.sort();
    return categories;
  }

  ProductProvider();

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _products = await ApiService.getProducts();
      _filteredProducts = _products;
    } catch (e) {
      _error = 'Məhsullar yüklənərkən xəta baş verdi: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products.where((product) => product.category == category).toList();
    }
    notifyListeners();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _selectedCategory.isEmpty ? _products : 
          _products.where((product) => product.category == _selectedCategory).toList();
    } else {
      _filteredProducts = _products.where((product) =>
          product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }


} 