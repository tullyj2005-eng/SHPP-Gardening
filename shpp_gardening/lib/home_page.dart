import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; 
import 'main.dart'; 
import 'settings_logic.dart'; 
import 'plants.dart';
import 'settings_page_view.dart';
import 'teacher_quiz_view.dart';
import 'student_quiz_view.dart';
import 'account_logic.dart';

class HomeScreen extends StatefulWidget {
  final List<TrackedPlant> tracked;
  final String? userRole;

  const HomeScreen({super.key, required this.tracked, this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _codeController = TextEditingController();

  // Maps each tracked plant name to its description and care text (mirrors plants.dart)
  static const Map<String, Map<String, String>> _plantInfoMap = {
    'Μέντα': {
      'description': "Η άγρια μέντα (Mentha aquatica), όπως σχεδόν όλα τα είδη μέντας, είναι πολυετές φυτό. Ξεχωρίζει για το έντονο άρωμά της και τα ροζ-μωβ άνθη που παράγει την άνοιξη και το καλοκαίρι. Αγαπά τα πλούσια, υγρά εδάφη και τις ηλιόλουστες τοποθεσίες, ενώ χρειάζεται προστασία από τον παγετό. Το έντονο άρωμα των φύλλων της την καθιστά ιδανική για αφέψημα και παραγωγή αιθέριου ελαίου.",
      'howTo': "Τα φυτά της οικογένειας της μέντας προτιμούν πλούσια, υγρά εδάφη με θέσεις με ήλιο ή ημισκιά. Χρειάζονται περισσότερο πότισμα κατά τις περιόδους ξηρασίας και καύσωμα, ενώ έχουν μέτριες απαιτήσεις σε νερό καθ' όλη τη διάρκεια του έτους.",
    },
    'Δεντρολίβανο': {
      'description': "Το έρπον δενδρολίβανο (Rosmarinus officinalis prostratus) είναι ένα αειθαλές, πολυετές φυτό, το οποίο εξελίσσεται σε έναν μεγάλο, πυκνό θάμνο. Την άνοιξη και το φθινόπωρο παράγει μικρά λευκά άνθη. Προτιμά ηλιόλουστα, ξηρά περιβάλλοντα.",
      'howTo': "Προτιμά ηλιόλουστο, ξηρό και ζεστό περιβάλλον. Είναι ανθεκτικό στον παγετό και τις χαμηλές θερμοκρασίες. Έχει χαμηλές έως ελάχιστες απαιτήσεις σε πότισμα. Τα ώριμα φυτά μπορούν να βασιστούν μόνο στη βροχόπτωση.",
    },
    'Δίκταμο': {
      'description': "Το δίκταμο (Origanum dictamnus), γνωστό και ως «δίκταμο της Κρήτης», είναι ένας μικρός αρωματικός θάμνος με στρογγυλά φύλλα και όμορφα ροζ/μωβ άνθη το καλοκαίρι. Αγαπά τις ηλιόλουστες τοποθεσίες και χρειάζεται λίγο πότισμα.",
      'howTo': "Χρειάζεται άφθονο ηλιακό φως και σχετικά υψηλές θερμοκρασίες. Χρειάζεται πότισμα κάθε 10 με 15 ημέρες εάν δεν βρέχει τον χειμώνα και πιο τακτικά το καλοκαίρι. Απαιτεί υψόμετρο μεγαλύτερο των 300 μέτρων.",
    },
    'Θυμάρι': {
      'description': "Το θυμάρι (Thymus Vulgaris) είναι ένα πολυετές φυτό με χαμηλές απαιτήσεις σε νερό και υψηλές απαιτήσεις σε ηλιακό φως. Ευδοκιμεί σε φτωχά εδάφη. Χρησιμοποιείται ευρέως στη μαγειρική, ιδιαίτερα στα ψητά και στις μαρινάδες.",
      'howTo': "Απαιτεί πλήρη έκθεση στον ήλιο και καλή αποστράγγιση. Είναι ανθεκτικό στην ξηρασία, με χαμηλές ανάγκες σε νερό. Ευδοκιμεί ικανοποιητικά σε φτωχά εδάφη.",
    },
    'Ρίγανη': {
      'description': "Η νησιωτική ρίγανη (Origanum onites) είναι ένα ιδιαίτερο είδος ρίγανης με δυνατό και γλυκό άρωμα. Είναι ένα ξηροφυτικό είδος, που δεν χρειάζεται πολύ νερό και ευδοκιμεί με τον ήλιο. Κατάλληλη για φύτευση σε γλάστρα στο μπαλκόνι.",
      'howTo': "Ξηροφυτικό είδος χωρίς ιδιαίτερες ανάγκες σε νερό. Απαιτεί μερική ή πλήρη έκθεση στο φως του ήλιου. Δεν υπάρχουν ιδιαίτερες απαιτήσεις ως προς το έδαφος, αρκεί να υπάρχει καλή αποστράγγιση.",
    },
  };

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // --- NAVIGATION LOGIC ---
  void _openQuiz(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = userDoc.data() as Map<String, dynamic>?;
      String finalCode = (data?['myClassCode'] ?? data?['classCode']) ?? "";
      if (mounted) {
        if (widget.userRole == 'Teacher') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherQuizView(classCode: finalCode)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StudentQuizView(classCode: finalCode)));
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isRed = ThemeManager.isRedMode;
    // Red mode has a LIGHT scaffold - main content text must be dark, not white.
    // Only dark mode needs white text in the main content area.
    Color dynamicTextColor = isDark ? Colors.white : (isRed ? Colors.red.shade900 : Colors.black);
    Color subTextColor = isDark ? Colors.white70 : (isRed ? Colors.red.shade700 : Colors.grey.shade700);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // --- SIDEBAR (NAVBAR) ---
          Container(
            width: 200,
            color: isDark 
                ? const Color(0xFF1A1C1E) 
                : (ThemeManager.isRedMode ? const Color.fromARGB(255, 120, 10, 0) : Colors.green.shade50),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.account_circle, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                _buildSidebarItem(Icons.quiz_outlined, "Κουίζ", () => _openQuiz(context)),
                _buildSidebarItem(Icons.settings, "Ρυθμίσεις", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                }),
                _buildSidebarItem(Icons.logout, "Αποσύνδεση", () => FirebaseAuth.instance.signOut()),
                const Spacer(),
                Text("v1.0.0", style: TextStyle(color: subTextColor, fontSize: 10)),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // --- MAIN CONTENT AREA ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- THE FIX: LIVE XP STREAM ---
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return Text("Error loading XP", style: TextStyle(color: Colors.red));
                      if (!snapshot.hasData || snapshot.data?.data() == null) {
                        return const LinearProgressIndicator(value: 0);
                      }
                      
                      final userData = snapshot.data!.data() as Map<String, dynamic>;
                      // Hardening the data type to ensure it's always an int
                      int currentXP = (userData['totalXP'] ?? 0).toInt(); 
                      
                      int level = LevelCalculator.getLevel(currentXP);
                      double progress = LevelCalculator.getLevelProgress(currentXP);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Level $level", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: dynamicTextColor)),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                              color: isRed ? Colors.red.shade400 : Colors.green,
                              minHeight: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("${LevelCalculator.xpUntilNextLevel(currentXP)} XP για το επόμενο επίπεδο", 
                               style: TextStyle(color: subTextColor, fontSize: 12)),
                        ],
                      );
                    }
                  ),
                  
                  const SizedBox(height: 40),
                  Text("Το Περιβόλι μου", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: dynamicTextColor)),
                  const SizedBox(height: 20),

                  // --- GARDEN GRID ---
                  Expanded(
                    child: widget.tracked.isEmpty
                        ? Center(child: Text("Δεν υπάρχουν φυτά.", style: TextStyle(color: subTextColor)))
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 180,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: widget.tracked.length,
                            itemBuilder: (context, index) {
                              final plant = widget.tracked[index];
                              double waterVal = plant.waterProgress;

                              // Look up this plant's info data from plants.dart
                              final info = _plantInfoMap[plant.name];

                              return GestureDetector(
                                onTap: () {
                                  if (info != null) {
                                    showPlantDetails(
                                      context,
                                      plant.name,
                                      info['description']!,
                                      info['howTo']!,
                                      () {}, // already tracked, no-op
                                    );
                                  }
                                },
                                onLongPress: () => _confirmDelete(plant),
                                child: Card(
                                  elevation: 2,
                                  color: isDark ? Colors.grey[850] : Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.local_florist, color: waterVal > 0.8 ? Colors.red : Colors.green, size: 32),
                                        const SizedBox(height: 8),
                                        Text(plant.name, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                                        const Spacer(),
                                        LinearProgressIndicator(
                                          value: 1.0 - waterVal,
                                          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                                          color: waterVal > 0.8 ? Colors.red : Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  
                  const Divider(height: 40),
                  _buildClassroomSlot(dynamicTextColor, subTextColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(TrackedPlant plant) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Διαγραφή"),
        content: Text("Αφαίρεση του φυτού '${plant.name}';"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Όχι")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Ναι", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      var snap = await FirebaseFirestore.instance.collection('users').doc(uid).collection('myGarden').where('name', isEqualTo: plant.name).get();
      for (var d in snap.docs) { await d.reference.delete(); }
    }
  }

  Widget _buildSidebarItem(IconData icon, String label, VoidCallback onTap) {
    bool isRed = ThemeManager.isRedMode;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Sidebar is dark-coloured in both dark and red mode, so always use white text/icons there
    final Color itemColor = (isDark || isRed) ? Colors.white : Colors.green;
    final Color labelColor = (isDark || isRed) ? Colors.white : Colors.black;
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(label, style: TextStyle(color: labelColor)),
      onTap: onTap,
    );
  }

  Widget _buildClassroomSlot(Color txt, Color sub) {
    bool isTeacher = widget.userRole == 'Teacher';
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isRed = ThemeManager.isRedMode;
    // This container is dark in red and dark mode, so its internal text must always be white
    Color containerText = (isDark || isRed) ? Colors.white : txt;
    Color containerSub  = (isDark || isRed) ? Colors.white70 : sub;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRed ? Colors.red.shade900 : (isDark ? Colors.grey[900] : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isTeacher ? "Κωδικός Τάξης:" : "Σύνδεση με Τάξη:", style: TextStyle(fontWeight: FontWeight.bold, color: containerText)),
          const SizedBox(height: 10),
          isTeacher ? _teacherView() : _studentView(containerText, containerSub),
        ],
      ),
    );
  }

  Widget _teacherView() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
      builder: (context, snap) {
        final code = (snap.data?.data() as Map<String, dynamic>?)?['myClassCode'] ?? "---";
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(code, style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () async {
                final newCode = await AccountLogic().createClass();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Νέος κωδικός: $newCode")),
                  );
                }
              },
              child: Text(code == "---" ? "Δημιουργία" : "Refresh"),
            ),
          ],
        );
      }
    );
  }

  Widget _studentView(Color txt, Color sub) {
    return Row(
      children: [
        Expanded(child: TextField(controller: _codeController, style: TextStyle(color: txt), decoration: InputDecoration(hintText: "Κωδικός", hintStyle: TextStyle(color: sub)))),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            final code = _codeController.text.trim().toUpperCase();
            if (code.isEmpty) return;
            final success = await AccountLogic().joinClass(code);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(success ? "Εγγραφή στην τάξη $code!" : "Ο κωδικός δεν βρέθηκε.")),
              );
              if (success) _codeController.clear();
            }
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}