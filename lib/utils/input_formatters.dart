import 'package:flutter/services.dart';

class InputFormatters {
  static List<TextInputFormatter> get priceFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(7),
  ];

  static List<TextInputFormatter> get quantityFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(5),
  ];

  static List<TextInputFormatter> get productNameFormatters => [
    LengthLimitingTextInputFormatter(50),
  ];

  static List<TextInputFormatter> get phoneFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  static List<TextInputFormatter> get emailFormatters => [
    FilteringTextInputFormatter.deny(RegExp(r'[^\w@.-]')),
  ];

  static List<TextInputFormatter> get arabicTextFormatters => [
    FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FF\s]')),
  ];

  static List<TextInputFormatter> get alphanumericFormatters => [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\u0600-\u06FF\s]')),
  ];

  static List<TextInputFormatter> get decimalFormatters => [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    DecimalTextInputFormatter(decimalDigits: 2),
  ];

  static List<TextInputFormatter> get integerFormatters => [
    FilteringTextInputFormatter.digitsOnly,
  ];
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalTextInputFormatter({required this.decimalDigits});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    // Allow only one decimal point
    if (newText.split('.').length > 2) {
      return oldValue;
    }

    // Limit decimal places
    if (newText.contains('.')) {
      List<String> parts = newText.split('.');
      if (parts.length == 2 && parts[1].length > decimalDigits) {
        return oldValue;
      }
    }

    return newValue;
  }
}

class CurrencyTextInputFormatter extends TextInputFormatter {
  final String currencySymbol;
  final int decimalDigits;

  CurrencyTextInputFormatter({
    this.currencySymbol = 'DZ',
    this.decimalDigits = 2,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    // Remove currency symbol if present
    newText = newText.replaceAll(currencySymbol, '').trim();

    // Allow only digits and decimal point
    if (!RegExp(r'^[0-9]*\.?[0-9]*$').hasMatch(newText)) {
      return oldValue;
    }

    // Limit decimal places
    if (newText.contains('.')) {
      List<String> parts = newText.split('.');
      if (parts.length == 2 && parts[1].length > decimalDigits) {
        return oldValue;
      }
    }

    return newValue;
  }
}
