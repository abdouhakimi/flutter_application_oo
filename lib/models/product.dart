import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Product {
  String? id;
  String name;
  int wholesalePrice;
  int retailPrice;
  DateTime savedAt;

  Product({
    this.id,
    required this.name,
    required this.wholesalePrice,
    required this.retailPrice,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'wholesale_price': wholesalePrice,
      'retail_price': retailPrice,
      'saved_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(savedAt),
    };
  }

  int calculateProfit() {
    return retailPrice - wholesalePrice;
  }

  double calculateProfitPercentage() {
    if (wholesalePrice == 0) return 0.0;
    return ((retailPrice - wholesalePrice) / wholesalePrice) * 100;
  }

  static DateTime parseSavedAt(dynamic savedAt) {
    if (savedAt is Timestamp) {
      return savedAt.toDate();
    } else if (savedAt is String) {
      try {
        return DateFormat("yyyy-MM-dd HH:mm:ss").parse(savedAt, true);
      } catch (e) {
        print('Error parsing date: $e');
        return DateTime.now();
      }
    } else {
      print('Unknown date format: $savedAt');
      return DateTime.now();
    }
  }

  factory Product.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    print("Fetching product with ID: ${doc.id}");
    return Product(
      id: doc.id,
      name: doc.data()['name'],
      wholesalePrice: (doc.data()['wholesale_price'] as num).toInt(),
      retailPrice: (doc.data()['retail_price'] as num).toInt(),
      savedAt: parseSavedAt(doc.data()['saved_at']),
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      wholesalePrice: map['wholesalePrice'],
      retailPrice: map['retailPrice'] ?? 0,
      savedAt: map['savedAt'] ?? DateTime.now(),
    );
  }
}
