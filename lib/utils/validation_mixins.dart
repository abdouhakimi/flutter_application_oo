
mixin ValidationMixin {
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName يجب أن يكون على الأقل $minLength أحرف';
    }
    return null;
  }

  String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName يجب أن يكون أقل من $maxLength أحرف';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'البريد الإلكتروني غير صحيح';
    }
    
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'رقم الهاتف يجب أن يكون 10 أرقام';
    }
    
    return null;
  }

  String? validatePrice(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    
    final price = double.tryParse(value.trim());
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

  String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الكمية مطلوبة';
    }
    
    final quantity = int.tryParse(value.trim());
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

  String? validateRetailPrice(String? value, String? wholesalePrice) {
    final retailValidation = validatePrice(value, 'سعر التجزئة');
    if (retailValidation != null) return retailValidation;
    
    if (wholesalePrice != null && wholesalePrice.isNotEmpty) {
      final retail = double.tryParse(value!.trim());
      final wholesale = double.tryParse(wholesalePrice.trim());
      
      if (retail != null && wholesale != null && retail <= wholesale) {
        return 'سعر التجزئة يجب أن يكون أكبر من سعر الجملة';
      }
    }
    
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
    }
    
    if (value.length > 20) {
      return 'كلمة المرور يجب أن تكون أقل من 20 حرف';
    }
    
    return null;
  }

  String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.trim().isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    
    return null;
  }

  String? validateDate(DateTime? value, String fieldName) {
    if (value == null) {
      return '$fieldName مطلوب';
    }
    
    final now = DateTime.now();
    if (value.isAfter(now)) {
      return '$fieldName لا يمكن أن يكون في المستقبل';
    }
    
    return null;
  }

  String? validateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return 'تاريخ الميلاد مطلوب';
    }
    
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    
    if (age < 18) {
      return 'يجب أن يكون العمر 18 سنة على الأقل';
    }
    
    if (age > 100) {
      return 'العمر غير صحيح';
    }
    
    return null;
  }
}
