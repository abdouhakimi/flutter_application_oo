import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';

class ErrorHandler {
  static final Logger _logger = Logger('ErrorHandler');

  static String getErrorMessage(dynamic error) {
    if (error is FirebaseException) {
      return _handleFirebaseError(error);
    }
    
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    
    return 'حدث خطأ غير متوقع';
  }

  static String _handleFirebaseError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'ليس لديك صلاحية للوصول إلى هذه البيانات';
      case 'unavailable':
        return 'الخدمة غير متاحة حالياً، يرجى المحاولة لاحقاً';
      case 'network-request-failed':
        return 'فشل في الاتصال بالشبكة';
      case 'quota-exceeded':
        return 'تم تجاوز الحد المسموح للاستخدام';
      default:
        _logger.severe('Firebase Error: ${error.code} - ${error.message}');
        return 'حدث خطأ في قاعدة البيانات';
    }
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    _logger.warning('Showing error to user: $message');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'إغلاق',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    _logger.info('Success: $message');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    _logger.info('Info: $message');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}