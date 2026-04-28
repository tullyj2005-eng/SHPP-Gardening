import 'package:flutter/material.dart';

class ThemeManager {
  // Handles the Light/Dark toggle
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  // Handles the Green/Red toggle
  static bool isRedMode = false;

  // Handles the music mute toggle
  static ValueNotifier<bool> isMuted = ValueNotifier(false);

  static void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static void setRedMode(bool value) {
    isRedMode = value;
    themeMode.notifyListeners();
  }

  static void setMuted(bool value) {
    isMuted.value = value;
  }
}