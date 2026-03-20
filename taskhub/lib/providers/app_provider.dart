import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _language = 'pt';
  bool _isOnline = true;

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get isOnline => _isOnline;

  // Methods
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void setOnlineStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      notifyListeners();
    }
  }

  void reset() {
    _isDarkMode = false;
    _language = 'pt';
    _isOnline = true;
    notifyListeners();
  }
}
