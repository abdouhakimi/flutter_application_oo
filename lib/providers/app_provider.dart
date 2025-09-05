import 'package:flutter/material.dart';
import '../utils/theme_config.dart';

class AppProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _language = 'ar';
  bool _isFirstLaunch = true;
  Map<String, dynamic> _settings = {};

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get isFirstLaunch => _isFirstLaunch;
  Map<String, dynamic> get settings => _settings;

  ThemeData get currentTheme => _isDarkMode ? ThemeConfig.darkTheme : ThemeConfig.lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void setFirstLaunch(bool isFirst) {
    _isFirstLaunch = isFirst;
    notifyListeners();
  }

  void updateSettings(Map<String, dynamic> newSettings) {
    _settings = {..._settings, ...newSettings};
    notifyListeners();
  }

  void setSetting(String key, dynamic value) {
    _settings[key] = value;
    notifyListeners();
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settings[key] as T? ?? defaultValue;
  }

  void clearSettings() {
    _settings.clear();
    notifyListeners();
  }

  void resetToDefaults() {
    _isDarkMode = false;
    _language = 'ar';
    _isFirstLaunch = true;
    _settings.clear();
    notifyListeners();
  }
}
