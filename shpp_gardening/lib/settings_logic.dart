import 'package:flutter/material.dart';

class ThemeManager {
  // This handles the Light/Dark toggle
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  // ADD THIS LINE: This handles the Green/Red toggle
  static bool isRedMode = false; 

  static void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
  
  // Optional: Helper function to swap red mode
  static void setRedMode(bool value) {
    isRedMode = value;
    // We trigger a "fake" change to the notifier so main.dart rebuilds
    themeMode.notifyListeners(); 
  }
}