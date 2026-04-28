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

          // --- MUSIC TOGGLE ---
          ValueListenableBuilder<bool>(
            valueListenable: ThemeManager.isMuted,
            builder: (context, muted, child) {
              return SwitchListTile(
                secondary: Icon(muted ? Icons.music_off : Icons.music_note,
                    color: muted ? Colors.grey : Colors.green),
                title: const Text("Μουσική υπόκρουση"),
                subtitle: Text(muted ? "Σίγαση" : "Ενεργή"),
                value: !muted,
                onChanged: (bool value) => ThemeManager.setMuted(!value),
              );
            },
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text("Τρόπος λειτουργίας", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          _buildInfoStep(Icons.add_task, "Προσθήκη φυτού", "Χρησιμοποιήστε το κουμπί 'Προσθήκη φυτού' για να ξεκινήσετε την παρακολούθηση του φυτού σας."),
          _buildInfoStep(Icons.opacity, "Μετρητής νερού", "Ο μετρητής νερού δείχνει πόσο νερό χρειάζεται το φυτό σας, βάσει των ρυθμίσεων σας."),
          _buildInfoStep(Icons.quiz, "Τεστ γνώσεων", "Οι δάσκαλοι μπορούν να δημοσιεύσουν τεστ στους κωδικούς τάξης για να σας βοηθήσουν να μάθετε καλύτερα τη φροντίδα των φυτών."),
          _buildInfoStep(Icons.touch_app, "Οδηγός φροντίδας", "Διαλέξτε οποιοδήποτε φυτό για να δείτε λεπτομερείς οδηγίες για την καλύτερη ανάπτυξή τους."),
          _buildInfoStep(Icons.info, "Αφαίρεση", "Για να αφαιρέσετε ένα φυτό από τον κήπο σας, απλώς πατήστε συνεχόμενα επάνω και επιβεβαιώστε τη διαγραφή. Το φυτό σας δε θα διαγραφεί από τη βιβλιοθήκη σας, οπότε μπορείτε να το προσθέσετε ξανά οποιαδήποτε στιγμή!"),
        ]
      ),
    );
  }

  Widget _buildInfoStep(IconData icon, String title, String desc) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isRed = ThemeManager.isRedMode;
    final Color iconColor = (isDark || isRed) ? Colors.white : Theme.of(context).primaryColor;
    final Color avatarBg = isDark
        ? Colors.white12
        : (isRed ? Colors.red.shade700 : Theme.of(context).primaryColor.withOpacity(0.1));

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: avatarBg,
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(desc),
    );
  }
}