import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductProvider() {
    _setupProductListener();
  }

  void _setupProductListener() {
    _setLoading(true);
    FirestoreService.productsStream.listen(
      (snapshot) {
        _products = snapshot.docs
            .map((doc) => Product.fromFirestore(doc as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList();
        _filteredProducts = List.from(_products);
        _setLoading(false);
        _clearError();
        notifyListeners();
      },
      onError: (error) {
        _setError('فشل في تحميل المنتجات: ${error.toString()}');
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  Future<void> addProduct(Product product) async {
    try {
      _setLoading(true);
      await FirestoreService.addProduct(product);
      _clearError();
    } catch (e) {
      _setError('فشل في إضافة المنتج: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      _setLoading(true);
      await FirestoreService.updateProduct(product);
      _clearError();
    } catch (e) {
      _setError('فشل في تحديث المنتج: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      _setLoading(true);
      await FirestoreService.deleteProduct(productId);
      _clearError();
    } catch (e) {
      _setError('فشل في حذف المنتج: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void filterProducts(String criteria) {
    _filteredProducts = _products
        .where((product) => 
            product.name.toLowerCase().contains(criteria.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void filterProductsByDate(DateTime date) {
    _filteredProducts = _products
        .where((product) => 
            product.savedAt.year == date.year &&
            product.savedAt.month == date.month &&
            product.savedAt.day == date.day)
        .toList();
    notifyListeners();
  }

  void resetFilter() {
    _filteredProducts = List.from(_products);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
