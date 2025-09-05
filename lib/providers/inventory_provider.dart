import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../services/firestore_service.dart';

class InventoryProvider with ChangeNotifier {
  List<InventoryItem> _inventoryItems = [];
  List<InventoryItem> _filteredItems = [];
  bool _isLoading = false;
  String? _error;

  List<InventoryItem> get inventoryItems => _inventoryItems;
  List<InventoryItem> get filteredItems => _filteredItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  InventoryProvider() {
    _setupInventoryListener();
  }

  void _setupInventoryListener() {
    _setLoading(true);
    FirestoreService.inventoryStream.listen(
      (snapshot) {
        _inventoryItems = snapshot.docs
            .map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              if (data['name'] == 'اسم غير معروف' ||
                  data['quantity'] == 0 ||
                  data['wholesalePrice'] == 0) {
                return null;
              }
              return InventoryItem.fromMap({
                'id': doc.id,
                ...data,
              });
            })
            .where((item) => item != null)
            .cast<InventoryItem>()
            .toList();
        _filteredItems = List.from(_inventoryItems);
        _setLoading(false);
        _clearError();
        notifyListeners();
      },
      onError: (error) {
        _setError('فشل في تحميل عناصر المخزون: ${error.toString()}');
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  Future<void> addInventoryItem(InventoryItem item) async {
    try {
      _setLoading(true);
      await FirestoreService.addInventoryItem(item);
      _clearError();
    } catch (e) {
      _setError('فشل في إضافة عنصر المخزون: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateInventoryItem(String id, Map<String, dynamic> itemData) async {
    try {
      _setLoading(true);
      await FirestoreService.updateInventoryItem(id, itemData);
      _clearError();
    } catch (e) {
      _setError('فشل في تحديث عنصر المخزون: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteInventoryItem(String itemName) async {
    try {
      _setLoading(true);
      await FirestoreService.deleteInventoryItem(itemName);
      _clearError();
    } catch (e) {
      _setError('فشل في حذف عنصر المخزون: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateInventoryQuantity(String productName, int change) async {
    try {
      _setLoading(true);
      await FirestoreService.updateInventoryQuantity(productName, change);
      _clearError();
    } catch (e) {
      _setError('فشل في تحديث كمية المخزون: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void filterItems(String criteria) {
    _filteredItems = _inventoryItems
        .where((item) => 
            item.name.toLowerCase().contains(criteria.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void resetFilter() {
    _filteredItems = List.from(_inventoryItems);
    notifyListeners();
  }

  List<InventoryItem> getOutOfStockItems() {
    return _inventoryItems.where((item) => item.isOutOfStock).toList();
  }

  List<InventoryItem> getLowStockItems({int threshold = 10}) {
    return _inventoryItems
        .where((item) => !item.isOutOfStock && item.quantity <= threshold)
        .toList();
  }

  double getTotalInventoryValue() {
    return _inventoryItems
        .where((item) => !item.isOutOfStock)
        .fold(0.0, (sum, item) => sum + (item.wholesalePrice * item.quantity));
  }

  int getTotalItemsCount() {
    return _inventoryItems
        .where((item) => !item.isOutOfStock)
        .fold(0, (sum, item) => sum + item.quantity);
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
