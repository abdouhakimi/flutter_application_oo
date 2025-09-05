import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ar', ''),
    Locale('en', ''),
  ];

  // App Info
  String get appName => _localizedValues[locale.languageCode]!['appName']!;
  String get appVersion => _localizedValues[locale.languageCode]!['appVersion']!;

  // Navigation
  String get addProduct => _localizedValues[locale.languageCode]!['addProduct']!;
  String get viewProducts => _localizedValues[locale.languageCode]!['viewProducts']!;
  String get inventory => _localizedValues[locale.languageCode]!['inventory']!;
  String get viewInventory => _localizedValues[locale.languageCode]!['viewInventory']!;

  // Product Form
  String get productName => _localizedValues[locale.languageCode]!['productName']!;
  String get wholesalePrice => _localizedValues[locale.languageCode]!['wholesalePrice']!;
  String get retailPrice => _localizedValues[locale.languageCode]!['retailPrice']!;
  String get profit => _localizedValues[locale.languageCode]!['profit']!;
  String get profitPercentage => _localizedValues[locale.languageCode]!['profitPercentage']!;

  // Inventory Form
  String get itemName => _localizedValues[locale.languageCode]!['itemName']!;
  String get quantity => _localizedValues[locale.languageCode]!['quantity']!;
  String get originalQuantity => _localizedValues[locale.languageCode]!['originalQuantity']!;
  String get stockPercentage => _localizedValues[locale.languageCode]!['stockPercentage']!;

  // Actions
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get filter => _localizedValues[locale.languageCode]!['filter']!;
  String get reset => _localizedValues[locale.languageCode]!['reset']!;

  // Messages
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get warning => _localizedValues[locale.languageCode]!['warning']!;
  String get info => _localizedValues[locale.languageCode]!['info']!;

  // Validation Messages
  String get required => _localizedValues[locale.languageCode]!['required']!;
  String get invalidEmail => _localizedValues[locale.languageCode]!['invalidEmail']!;
  String get invalidPhone => _localizedValues[locale.languageCode]!['invalidPhone']!;
  String get invalidPrice => _localizedValues[locale.languageCode]!['invalidPrice']!;
  String get invalidQuantity => _localizedValues[locale.languageCode]!['invalidQuantity']!;

  // Status
  String get outOfStock => _localizedValues[locale.languageCode]!['outOfStock']!;
  String get lowStock => _localizedValues[locale.languageCode]!['lowStock']!;
  String get inStock => _localizedValues[locale.languageCode]!['inStock']!;

  // Dates
  String get date => _localizedValues[locale.languageCode]!['date']!;
  String get time => _localizedValues[locale.languageCode]!['time']!;
  String get today => _localizedValues[locale.languageCode]!['today']!;
  String get yesterday => _localizedValues[locale.languageCode]!['yesterday']!;
  String get thisWeek => _localizedValues[locale.languageCode]!['thisWeek']!;
  String get thisMonth => _localizedValues[locale.languageCode]!['thisMonth']!;

  // Settings
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get lightMode => _localizedValues[locale.languageCode]!['lightMode']!;

  // Confirmation Dialogs
  String get confirmDelete => _localizedValues[locale.languageCode]!['confirmDelete']!;
  String get confirmExit => _localizedValues[locale.languageCode]!['confirmExit']!;
  String get yes => _localizedValues[locale.languageCode]!['yes']!;
  String get no => _localizedValues[locale.languageCode]!['no']!;

  // Empty States
  String get noProducts => _localizedValues[locale.languageCode]!['noProducts']!;
  String get noInventory => _localizedValues[locale.languageCode]!['noInventory']!;
  String get noResults => _localizedValues[locale.languageCode]!['noResults']!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'appName': 'حاسبة الأرباح',
      'appVersion': 'الإصدار 1.0.0',
      'addProduct': 'إضافة منتج',
      'viewProducts': 'عرض المنتجات',
      'inventory': 'الكمية',
      'viewInventory': 'عرض الكمية',
      'productName': 'اسم المنتج',
      'wholesalePrice': 'سعر الجملة',
      'retailPrice': 'سعر التجزئة',
      'profit': 'الربح',
      'profitPercentage': 'نسبة الربح',
      'itemName': 'اسم السلعة',
      'quantity': 'الكمية',
      'originalQuantity': 'الكمية الأصلية',
      'stockPercentage': 'نسبة المخزون',
      'add': 'إضافة',
      'edit': 'تعديل',
      'delete': 'حذف',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'search': 'بحث',
      'filter': 'تصفية',
      'reset': 'إعادة تعيين',
      'success': 'نجح',
      'error': 'خطأ',
      'warning': 'تحذير',
      'info': 'معلومات',
      'required': 'مطلوب',
      'invalidEmail': 'البريد الإلكتروني غير صحيح',
      'invalidPhone': 'رقم الهاتف غير صحيح',
      'invalidPrice': 'السعر غير صحيح',
      'invalidQuantity': 'الكمية غير صحيحة',
      'outOfStock': 'نفدت الكمية',
      'lowStock': 'كمية قليلة',
      'inStock': 'متوفر',
      'date': 'التاريخ',
      'time': 'الوقت',
      'today': 'اليوم',
      'yesterday': 'أمس',
      'thisWeek': 'هذا الأسبوع',
      'thisMonth': 'هذا الشهر',
      'settings': 'الإعدادات',
      'theme': 'المظهر',
      'language': 'اللغة',
      'darkMode': 'الوضع المظلم',
      'lightMode': 'الوضع المضيء',
      'confirmDelete': 'تأكيد الحذف',
      'confirmExit': 'تأكيد الخروج',
      'yes': 'نعم',
      'no': 'لا',
      'noProducts': 'لا توجد منتجات',
      'noInventory': 'لا توجد عناصر في المخزون',
      'noResults': 'لا توجد نتائج',
    },
    'en': {
      'appName': 'Profit Calculator',
      'appVersion': 'Version 1.0.0',
      'addProduct': 'Add Product',
      'viewProducts': 'View Products',
      'inventory': 'Inventory',
      'viewInventory': 'View Inventory',
      'productName': 'Product Name',
      'wholesalePrice': 'Wholesale Price',
      'retailPrice': 'Retail Price',
      'profit': 'Profit',
      'profitPercentage': 'Profit Percentage',
      'itemName': 'Item Name',
      'quantity': 'Quantity',
      'originalQuantity': 'Original Quantity',
      'stockPercentage': 'Stock Percentage',
      'add': 'Add',
      'edit': 'Edit',
      'delete': 'Delete',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'search': 'Search',
      'filter': 'Filter',
      'reset': 'Reset',
      'success': 'Success',
      'error': 'Error',
      'warning': 'Warning',
      'info': 'Info',
      'required': 'Required',
      'invalidEmail': 'Invalid email',
      'invalidPhone': 'Invalid phone number',
      'invalidPrice': 'Invalid price',
      'invalidQuantity': 'Invalid quantity',
      'outOfStock': 'Out of Stock',
      'lowStock': 'Low Stock',
      'inStock': 'In Stock',
      'date': 'Date',
      'time': 'Time',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'thisWeek': 'This Week',
      'thisMonth': 'This Month',
      'settings': 'Settings',
      'theme': 'Theme',
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'confirmDelete': 'Confirm Delete',
      'confirmExit': 'Confirm Exit',
      'yes': 'Yes',
      'no': 'No',
      'noProducts': 'No Products',
      'noInventory': 'No Inventory Items',
      'noResults': 'No Results',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
