enum InventoryStatus {
  available('متوفر'),
  outOfStock('نفذت الكمية'),
  lowStock('كمية قليلة');

  const InventoryStatus(this.arabicName);
  final String arabicName;
}

enum ProductCategory {
  category1('الفئة 1'),
  category2('الفئة 2'),
  category3('الفئة 3');

  const ProductCategory(this.arabicName);
  final String arabicName;
}

enum TransactionType {
  sale('بيع'),
  purchase('شراء'),
  adjustment('تعديل');

  const TransactionType(this.arabicName);
  final String arabicName;
}