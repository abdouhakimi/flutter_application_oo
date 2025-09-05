import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'حاسبة الأرباح';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  static const Color successColor = Colors.green;
  
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
  
  // Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 10.0;
  static const double cardElevation = 4.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Validation Limits
  static const int maxProductNameLength = 50;
  static const int minProductNameLength = 2;
  static const int maxPrice = 1000000;
  static const int maxQuantity = 10000;
  
  // Firebase Collections
  static const String productsCollection = 'products';
  static const String quantitiesCollection = 'quantities';
  
  // Error Messages
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String unknownError = 'حدث خطأ غير متوقع';
  static const String validationError = 'يرجى التحقق من البيانات المدخلة';
  
  // Success Messages
  static const String productAddedSuccess = 'تم إضافة المنتج بنجاح';
  static const String productUpdatedSuccess = 'تم تحديث المنتج بنجاح';
  static const String productDeletedSuccess = 'تم حذف المنتج بنجاح';
  static const String inventoryAddedSuccess = 'تم إضافة عنصر المخزون بنجاح';
  static const String inventoryUpdatedSuccess = 'تم تحديث عنصر المخزون بنجاح';
  static const String inventoryDeletedSuccess = 'تم حذف عنصر المخزون بنجاح';
}
