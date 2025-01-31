import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return _isDarkMode ? darkTheme : lightTheme;
  }

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold, color: Colors.black),
        bodySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey,
      secondary: Colors.orangeAccent,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold, color: Colors.white),
      bodySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
    ),
  );
}
