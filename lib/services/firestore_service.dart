import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/inventory_item.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _productsCollection = _db.collection('products');
  static final CollectionReference _quantitiesCollection = _db.collection('quantities');

  // Product operations
  static Future<bool> checkIfNameExists(String name) async {
    try {
      final result = await _productsCollection
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      print('Error checking name existence: $e');
      throw Exception('فشل في التحقق من وجود الاسم');
    }
  }

  static Future<void> addProduct(Product product) async {
    try {
      String uniqueId = Uuid().v4();
      product.id = uniqueId;
      await _productsCollection.doc(uniqueId).set(product.toMap());
      await _quantitiesCollection.doc(uniqueId).set({'quantity': 0});
      print('Product added with UUID: $uniqueId');
    } catch (e) {
      print('Error adding product: $e');
      throw Exception('فشل في إضافة المنتج');
    }
  }

  static Future<void> updateProduct(Product product) async {
    try {
      await _productsCollection.doc(product.id).update(product.toMap());
      print('Product updated successfully with ID: ${product.id}');
    } catch (e) {
      print('Error updating product: $e');
      throw Exception('فشل في تحديث المنتج');
    }
  }

  static Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
      print('Product deleted successfully with ID: $productId');
    } catch (e) {
      print('Error deleting product: $e');
      throw Exception('فشل في حذف المنتج');
    }
  }

  static Future<void> deleteProductByName(String productName) async {
    try {
      QuerySnapshot querySnapshot = await _productsCollection
          .where('name', isEqualTo: productName)
          .get();

      for (var doc in querySnapshot.docs) {
        await _productsCollection.doc(doc.id).delete();
      }
      print('All products with name $productName have been deleted successfully');
    } catch (e) {
      print('Error deleting products by name: $e');
      throw Exception('فشل في حذف المنتجات بالاسم');
    }
  }

  // Inventory operations
  static Future<void> addInventoryItem(InventoryItem item) async {
    try {
      String uniqueId = Uuid().v4();
      item.id = uniqueId;
      await _quantitiesCollection.doc(uniqueId).set(item.toMap());
      print('Inventory item added with ID: $uniqueId');
    } catch (e) {
      print('Error adding inventory item: $e');
      throw Exception('فشل في إضافة عنصر المخزون');
    }
  }

  static Future<void> updateInventoryItem(String id, Map<String, dynamic> itemData) async {
    try {
      await _quantitiesCollection.doc(id).update(itemData);
      print('Inventory item updated successfully with ID: $id');
    } catch (e) {
      print('Error updating inventory item: $e');
      throw Exception('فشل في تحديث عنصر المخزون');
    }
  }

  static Future<void> deleteInventoryItem(String itemName) async {
    try {
      QuerySnapshot snapshot = await _quantitiesCollection
          .where('name', isEqualTo: itemName)
          .get();
      for (var doc in snapshot.docs) {
        await _quantitiesCollection.doc(doc.id).delete();
      }
      print('Inventory item deleted successfully: $itemName');
    } catch (e) {
      print('Error deleting inventory item: $e');
      throw Exception('فشل في حذف عنصر المخزون');
    }
  }

  static Future<void> updateInventoryQuantity(String productName, int change) async {
    try {
      var snapshot = await _quantitiesCollection
          .where('name', isEqualTo: productName)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        int currentQuantity = data['quantity'] ?? 0;
        int newQuantity = currentQuantity + change;
        
        if (newQuantity > 0) {
          await _quantitiesCollection.doc(doc.id).update({'quantity': newQuantity});
        } else {
          await _quantitiesCollection.doc(doc.id).update({'quantity': 'نفذت الكمية'});
        }
      }
    } catch (e) {
      print('Error updating inventory quantity: $e');
      throw Exception('فشل في تحديث كمية المخزون');
    }
  }

  // Streams for real-time updates
  static Stream<QuerySnapshot> get productsStream => 
      _productsCollection.orderBy('saved_at', descending: true).snapshots();
  
  static Stream<QuerySnapshot> get inventoryStream => 
      _quantitiesCollection.snapshots();
}
