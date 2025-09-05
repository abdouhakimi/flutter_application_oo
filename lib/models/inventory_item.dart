import 'package:intl/intl.dart';
import 'enums.dart';

class InventoryItem {
  String? id;
  String name;
  int wholesalePrice;
  int quantity;
  int originalQuantity;
  DateTime addedDate;
  DateTime addedTime;

  InventoryItem({
    this.id,
    required this.name,
    required this.wholesalePrice,
    required this.quantity,
    required this.originalQuantity,
    required this.addedDate,
    required this.addedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'wholesalePrice': wholesalePrice,
      'quantity': quantity,
      'originalQuantity': originalQuantity,
      'addedDate': DateFormat('yyyy-MM-dd').format(addedDate),
      'addedTime': DateFormat('HH:mm:ss').format(addedTime),
    };
  }

  InventoryStatus get status {
    if (quantity == 0) return InventoryStatus.outOfStock;
    if (quantity <= (originalQuantity * 0.2)) return InventoryStatus.lowStock;
    return InventoryStatus.available;
  }
  
  bool get isOutOfStock => status == InventoryStatus.outOfStock;
  
  String get statusText => status == InventoryStatus.outOfStock 
      ? status.arabicName 
      : quantity.toString();
  
  double get stockPercentage {
    if (originalQuantity == 0) return 0.0;
    return (quantity / originalQuantity) * 100;
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      wholesalePrice: map['wholesalePrice'] ?? 0,
      quantity: map['quantity'] ?? 0,
      originalQuantity: map['originalQuantity'] ?? 0,
      addedDate: map['addedDate'] != null 
          ? DateFormat('yyyy-MM-dd').parse(map['addedDate'])
          : DateTime.now(),
      addedTime: map['addedTime'] != null 
          ? DateFormat('HH:mm:ss').parse(map['addedTime'])
          : DateTime.now(),
    );
  }
}
