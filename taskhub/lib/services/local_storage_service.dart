import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_constants.dart';

class LocalStorageService {
  late SharedPreferences _prefs;

  LocalStorageService();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  Future<bool> saveToken(String token) {
    return _prefs.setString(AppConstants.tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(AppConstants.tokenKey);
  }

  Future<bool> saveRefreshToken(String token) {
    return _prefs.setString(AppConstants.refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(AppConstants.refreshTokenKey);
  }

  Future<bool> clearTokens() async {
    await _prefs.remove(AppConstants.tokenKey);
    await _prefs.remove(AppConstants.refreshTokenKey);
    return true;
  }

  // User data management
  Future<bool> saveUserData(String userData) {
    return _prefs.setString(AppConstants.userKey, userData);
  }

  String? getUserData() {
    return _prefs.getString(AppConstants.userKey);
  }

  Future<bool> clearUserData() {
    return _prefs.remove(AppConstants.userKey);
  }

  // Theme management
  Future<bool> saveThemePreference(String theme) {
    return _prefs.setString(AppConstants.themeKey, theme);
  }

  String? getThemePreference() {
    return _prefs.getString(AppConstants.themeKey);
  }

  // Language management
  Future<bool> saveLanguagePreference(String language) {
    return _prefs.setString(AppConstants.languageKey, language);
  }

  String? getLanguagePreference() {
    return _prefs.getString(AppConstants.languageKey);
  }

  // Generic methods
  Future<bool> saveData(String key, dynamic value) {
    if (value is String) {
      return _prefs.setString(key, value);
    } else if (value is int) {
      return _prefs.setInt(key, value);
    } else if (value is double) {
      return _prefs.setDouble(key, value);
    } else if (value is bool) {
      return _prefs.setBool(key, value);
    } else if (value is List<String>) {
      return _prefs.setStringList(key, value);
    }
    return Future.value(false);
  }

  dynamic getData(String key) {
    return _prefs.get(key);
  }

  Future<bool> removeData(String key) {
    return _prefs.remove(key);
  }

  Future<bool> clearAll() {
    return _prefs.clear();
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }
}
