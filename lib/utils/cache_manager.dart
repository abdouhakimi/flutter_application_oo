import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _productsKey = 'cached_products';
  static const String _inventoryKey = 'cached_inventory';
  static const String _settingsKey = 'app_settings';
  static const String _lastSyncKey = 'last_sync_time';

  static Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(products);
      await prefs.setString(_productsKey, jsonString);
    } catch (e) {
      print('Error caching products: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getCachedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_productsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error getting cached products: $e');
    }
    return [];
  }

  static Future<void> cacheInventory(List<Map<String, dynamic>> inventory) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(inventory);
      await prefs.setString(_inventoryKey, jsonString);
    } catch (e) {
      print('Error caching inventory: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getCachedInventory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_inventoryKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error getting cached inventory: $e');
    }
    return [];
  }

  static Future<void> setLastSyncTime(DateTime time) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSyncKey, time.toIso8601String());
    } catch (e) {
      print('Error setting last sync time: $e');
    }
  }

  static Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timeString = prefs.getString(_lastSyncKey);
      if (timeString != null) {
        return DateTime.parse(timeString);
      }
    } catch (e) {
      print('Error getting last sync time: $e');
    }
    return null;
  }

  static Future<void> cacheSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings);
      await prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      print('Error caching settings: $e');
    }
  }

  static Future<Map<String, dynamic>> getCachedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_settingsKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return jsonMap;
      }
    } catch (e) {
      print('Error getting cached settings: $e');
    }
    return {};
  }

  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_productsKey);
      await prefs.remove(_inventoryKey);
      await prefs.remove(_lastSyncKey);
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  static Future<bool> isCacheValid({Duration maxAge = const Duration(hours: 1)}) async {
    try {
      final lastSync = await getLastSyncTime();
      if (lastSync == null) return false;
      return DateTime.now().difference(lastSync) < maxAge;
    } catch (e) {
      print('Error checking cache validity: $e');
      return false;
    }
  }
}
