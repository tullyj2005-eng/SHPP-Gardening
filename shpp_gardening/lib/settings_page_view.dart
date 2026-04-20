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
      appBar: AppBar(title: const Text("Ρυθμίσεις")),
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
                    title: const Text("Σκούρα εμφάνιση"),
                    value: mode == ThemeMode.dark,
                    onChanged: (bool value) => ThemeManager.toggleTheme(value),
                  ),
                  
                  // --- RED THEME TOGGLE ---
                  // Only show this option if we aren't in Dark Mode
                  if (mode != ThemeMode.dark)
                    SwitchListTile(
                      secondary: const Icon(Icons.palette, color: Colors.red),
                      title: const Text("Κόκκινη εμφάνιση"),
                      subtitle: const Text("Αλλαγή από πράσινη σε κόκκινη εμφάνιση"),
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
            child: Text("Τρόπος λειτουργίας", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          _buildInfoStep(Icons.add_task, "Προσθήκη φυτού", "Χρησιμοποιήστε το κουμπί 'Προσθήκη φυτού' για να ξεκινήσετε την παρακολούθηση του φυτού σας."),
          _buildInfoStep(Icons.opacity, "Μετρητής νερού", "Ο μετρητής νερού δείχνει πόσο νερό χρειάζεται το φυτό σας, βάσει των ρυθμίσεων σας."),
          _buildInfoStep(Icons.quiz, "Τεστ γνώσεων", "Οι δάσκαλοι μπορούν να δημοσιεύσουν τεστ στους κωδικούς τάξης για να σας βοηθήσουν να μάθετε καλύτερα τη φροντίδα των φυτών."),
          _buildInfoStep(Icons.touch_app, "Οδηγός φροντίδας", "Διαλέξτε οποιοδήποτε φυτό για να δείτε λεπτομερείς οδηγίες για την καλύτερη ανάπτυξή τους."),
          _buildInfoStep(Icons.info, "Αφαίρεση", "To remove a plant from you garden, simply long press on it and confirm removal. This will not delete the plant from your library, so you can add it back anytime!"),
        ]
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