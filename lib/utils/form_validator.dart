import 'package:flutter/material.dart';
import 'validation_mixins.dart';

class FormValidator with ValidationMixin {
  static final FormValidator _instance = FormValidator._internal();
  factory FormValidator() => _instance;
  FormValidator._internal();

  static String? validateProductForm({
    required String? name,
    required String? wholesalePrice,
    required String? retailPrice,
  }) {
    final validator = FormValidator();
    
    // Validate name
    final nameError = validator.validateRequired(name, 'اسم المنتج');
    if (nameError != null) return nameError;
    
    final nameLengthError = validator.validateMinLength(name, 2, 'اسم المنتج');
    if (nameLengthError != null) return nameLengthError;
    
    final nameMaxLengthError = validator.validateMaxLength(name, 50, 'اسم المنتج');
    if (nameMaxLengthError != null) return nameMaxLengthError;
    
    // Validate wholesale price
    final wholesaleError = validator.validatePrice(wholesalePrice, 'سعر الجملة');
    if (wholesaleError != null) return wholesaleError;
    
    // Validate retail price
    final retailError = validator.validateRetailPrice(retailPrice, wholesalePrice);
    if (retailError != null) return retailError;
    
    return null;
  }

  static String? validateInventoryForm({
    required String? name,
    required String? wholesalePrice,
    required String? quantity,
  }) {
    final validator = FormValidator();
    
    // Validate name
    final nameError = validator.validateRequired(name, 'اسم السلعة');
    if (nameError != null) return nameError;
    
    final nameLengthError = validator.validateMinLength(name, 2, 'اسم السلعة');
    if (nameLengthError != null) return nameLengthError;
    
    final nameMaxLengthError = validator.validateMaxLength(name, 50, 'اسم السلعة');
    if (nameMaxLengthError != null) return nameMaxLengthError;
    
    // Validate wholesale price
    final wholesaleError = validator.validatePrice(wholesalePrice, 'سعر الجملة');
    if (wholesaleError != null) return wholesaleError;
    
    // Validate quantity
    final quantityError = validator.validateQuantity(quantity);
    if (quantityError != null) return quantityError;
    
    return null;
  }

  static String? validateUserForm({
    required String? name,
    required String? email,
    required String? phone,
  }) {
    final validator = FormValidator();
    
    // Validate name
    final nameError = validator.validateRequired(name, 'الاسم');
    if (nameError != null) return nameError;
    
    final nameLengthError = validator.validateMinLength(name, 2, 'الاسم');
    if (nameLengthError != null) return nameLengthError;
    
    // Validate email
    final emailError = validator.validateEmail(email);
    if (emailError != null) return emailError;
    
    // Validate phone
    final phoneError = validator.validatePhone(phone);
    if (phoneError != null) return phoneError;
    
    return null;
  }

  static String? validateLoginForm({
    required String? email,
    required String? password,
  }) {
    final validator = FormValidator();
    
    // Validate email
    final emailError = validator.validateEmail(email);
    if (emailError != null) return emailError;
    
    // Validate password
    final passwordError = validator.validatePassword(password);
    if (passwordError != null) return passwordError;
    
    return null;
  }

  static String? validateRegisterForm({
    required String? name,
    required String? email,
    required String? phone,
    required String? password,
    required String? confirmPassword,
  }) {
    final validator = FormValidator();
    
    // Validate name
    final nameError = validator.validateRequired(name, 'الاسم');
    if (nameError != null) return nameError;
    
    final nameLengthError = validator.validateMinLength(name, 2, 'الاسم');
    if (nameLengthError != null) return nameLengthError;
    
    // Validate email
    final emailError = validator.validateEmail(email);
    if (emailError != null) return emailError;
    
    // Validate phone
    final phoneError = validator.validatePhone(phone);
    if (phoneError != null) return phoneError;
    
    // Validate password
    final passwordError = validator.validatePassword(password);
    if (passwordError != null) return passwordError;
    
    // Validate confirm password
    final confirmPasswordError = validator.validateConfirmPassword(confirmPassword, password);
    if (confirmPasswordError != null) return confirmPasswordError;
    
    return null;
  }

  static bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  static void resetForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.reset();
  }

  static void saveForm(GlobalKey<FormState> formKey) {
    formKey.currentState?.save();
  }
}
