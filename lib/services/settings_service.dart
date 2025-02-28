import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _notificationsKey = 'notifications_enabled';
  static const String _darkModeKey = 'dark_mode_enabled';
  static const String _languageKey = 'selected_language';

  final SharedPreferences _prefs;

  bool _notificationsEnabled;
  bool _darkModeEnabled;
  String _selectedLanguage;

  SettingsService(this._prefs)
      : _notificationsEnabled = _prefs.getBool(_notificationsKey) ?? true,
        _darkModeEnabled = _prefs.getBool(_darkModeKey) ?? false,
        _selectedLanguage = _prefs.getString(_languageKey) ?? 'Magyar';

  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  String get selectedLanguage => _selectedLanguage;

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool(_notificationsKey, value);
    notifyListeners();
  }

  Future<void> setDarkModeEnabled(bool value) async {
    _darkModeEnabled = value;
    await _prefs.setBool(_darkModeKey, value);
    notifyListeners();
  }

  Future<void> setSelectedLanguage(String value) async {
    _selectedLanguage = value;
    await _prefs.setString(_languageKey, value);
    notifyListeners();
  }
} 