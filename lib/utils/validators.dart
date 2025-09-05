class Validators {
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'اسم المنتج مطلوب';
    }
    if (value.length < 2) {
      return 'اسم المنتج يجب أن يكون أكثر من حرفين';
    }
    if (value.length > 50) {
      return 'اسم المنتج يجب أن يكون أقل من 50 حرف';
    }
    return null;
  }

  static String? validatePrice(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    
    final price = int.tryParse(value);
    if (price == null) {
      return '$fieldName يجب أن يكون رقماً صحيحاً';
    }
    
    if (price <= 0) {
      return '$fieldName يجب أن يكون أكبر من صفر';
    }
    
    if (price > 1000000) {
      return '$fieldName يجب أن يكون أقل من 1,000,000';
    }
    
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'الكمية مطلوبة';
    }
    
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'الكمية يجب أن تكون رقماً صحيحاً';
    }
    
    if (quantity < 0) {
      return 'الكمية لا يمكن أن تكون سالبة';
    }
    
    if (quantity > 10000) {
      return 'الكمية يجب أن تكون أقل من 10,000';
    }
    
    return null;
  }

  static String? validateRetailPrice(String? value, String? wholesalePrice) {
    final retailValidation = validatePrice(value, 'سعر التجزئة');
    if (retailValidation != null) return retailValidation;
    
    if (wholesalePrice != null && wholesalePrice.isNotEmpty) {
      final retail = int.tryParse(value!);
      final wholesale = int.tryParse(wholesalePrice);
      
      if (retail != null && wholesale != null && retail <= wholesale) {
        return 'سعر التجزئة يجب أن يكون أكبر من سعر الجملة';
      }
    }
    
    return null;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!isValidEmail(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }
}
