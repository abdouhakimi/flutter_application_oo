import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsUtils {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      print('Error logging analytics event: $e');
    }
  }

  static Future<void> logProductAdded(String productName, int price) async {
    await logEvent('product_added', parameters: {
      'product_name': productName,
      'price': price,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> logProductDeleted(String productName) async {
    await logEvent('product_deleted', parameters: {
      'product_name': productName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> logInventoryAdded(String itemName, int quantity) async {
    await logEvent('inventory_added', parameters: {
      'item_name': itemName,
      'quantity': quantity,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> logInventoryUpdated(String itemName, int newQuantity) async {
    await logEvent('inventory_updated', parameters: {
      'item_name': itemName,
      'new_quantity': newQuantity,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', parameters: {
      'screen_name': screenName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> logError(String error, String stackTrace) async {
    await logEvent('error_occurred', parameters: {
      'error': error,
      'stack_trace': stackTrace,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> logUserAction(String action, {Map<String, dynamic>? parameters}) async {
    await logEvent('user_action', parameters: {
      'action': action,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?parameters,
    });
  }

  static Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      print('Error setting user property: $e');
    }
  }

  static Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      print('Error setting user ID: $e');
    }
  }
}
