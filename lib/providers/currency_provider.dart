import 'package:flutter/material.dart';

class CurrencyProvider with ChangeNotifier {
  dynamic _selectedCurrencyIcon = '₱';

  dynamic get selectedCurrencyIcon => _selectedCurrencyIcon;

  void selectCurrency(dynamic icon) {
    _selectedCurrencyIcon = icon;
    notifyListeners();
  }
}
