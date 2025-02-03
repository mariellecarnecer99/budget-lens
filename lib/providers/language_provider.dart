import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'en';

  String get selectedLanguage => _selectedLanguage;

  void selectLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }
}