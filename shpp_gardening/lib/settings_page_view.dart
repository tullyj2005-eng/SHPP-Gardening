import 'package:flutter/material.dart';
import 'settings_logic.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- THEME TOGGLE (DARK/LIGHT) ---
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeManager.themeMode,
            builder: (context, mode, child) {
              return Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
                    title: const Text("Dark Mode"),
                    value: mode == ThemeMode.dark,
                    onChanged: (bool value) => ThemeManager.toggleTheme(value),
                  ),
                  
                  // --- RED THEME TOGGLE ---
                  // Only show this option if we aren't in Dark Mode
                  if (mode != ThemeMode.dark)
                    SwitchListTile(
                      secondary: const Icon(Icons.palette, color: Colors.red),
                      title: const Text("Red Floral Theme"),
                      subtitle: const Text("Switch from green to red aesthetic"),
                      value: ThemeManager.isRedMode,
                      onChanged: (bool value) {
                        setState(() {
                          ThemeManager.setRedMode(value);
                        });
                      },
                    ),
                ],
              );
            },
          ),
          
          const Divider(),

          // --- HOW IT WORKS SECTION ---
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text("How it Works", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          _buildInfoStep(Icons.add_task, "Add Plants", "Use the 'Add' button to start tracking your real-life plants."),
          _buildInfoStep(Icons.opacity, "Monitor Thirst", "The Thirst Meter shows you how badly your plant needs water based on your specific settings."),
          _buildInfoStep(Icons.quiz, "Test Your Knowledge", "Teachers can post quizzes to class codes to help you learn better plant care."),
          _buildInfoStep(Icons.touch_app, "Care Guides", "Tap any plant in your garden to view detailed instructions on how to grow it effectively."),
          _buildInfoStep(Icons.info, "About", "To remove a plant from you garden, simply long press on it and confirm removal. This will not delete the plant from your library, so you can add it back anytime!"),
        ],
      ),
    );
  }

  Widget _buildInfoStep(IconData icon, String title, String desc) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1), 
        child: Icon(icon, color: Theme.of(context).primaryColor)
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(desc),
    );
  }
}