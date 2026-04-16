import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart'; 
import 'login_page.dart'; 
import 'teacher_quiz_view.dart';
import 'student_quiz_view.dart';
import 'account_logic.dart';
import 'plant_detail_view.dart'; 
import 'settings_page_view.dart';
import 'settings_logic.dart'; 

class HomeScreen extends StatefulWidget {
  final List<TrackedPlant> tracked;
  final String? userRole;

  const HomeScreen({super.key, required this.tracked, this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AccountLogic _account = AccountLogic();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, TrackedPlant plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Plant?"),
        content: Text("Are you sure you want to stop tracking ${plant.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _account.removePlantFromGarden(plant.name);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openQuiz(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.userRole == null) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return;

    String? code = widget.userRole == 'Teacher' 
        ? userDoc.get('myClassCode') 
        : userDoc.get('classCode');

    if (code == null || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please join a classroom first to access quizzes!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget.userRole == 'Teacher'
              ? TeacherQuizView(classCode: code)
              : StudentQuizView(classCode: code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // --- LEFT SIDEBAR PANEL ---
          Container(
            width: 210,
            // UPDATED: Logic to handle Deep Red Sidebar
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : (ThemeManager.isRedMode 
                    ? const Color.fromARGB(255, 120, 10, 0) // Deep Red
                    : const Color(0xFFE8F5E9)),           // Standard Green/Tan
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (user == null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                    // UPDATED: Logic to handle Header Color
                    color: ThemeManager.isRedMode 
                        ? const Color.fromARGB(255, 161, 16, 3) // Brighter Red
                        : const Color(0xFF2E7D32),             // Original Green
                    width: double.infinity,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person, 
                            size: 40, 
                            // UPDATED: Icon color matches theme
                            color: ThemeManager.isRedMode 
                                ? const Color.fromARGB(255, 161, 16, 3) 
                                : const Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user == null ? "Sign In" : "Active User",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        if (user != null) ...[
                          Text(
                            user.email ?? "",
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 15),
                          StreamBuilder<int>(
                            stream: _account.getUserXP(),
                            builder: (context, snapshot) {
                              final xp = snapshot.data ?? 0;
                              final progress = LevelCalculator.getLevelProgress(xp);
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 6,
                                      backgroundColor: Colors.white24,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Growth Progress", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 9)),
                                ],
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                if (user != null) ...[
                  ListTile(
                    leading: const Icon(Icons.quiz_outlined, color: Colors.orange),
                    // UPDATED: Text color for readability on dark red
                    title: Text("Garden Quiz", 
                      style: TextStyle(
                        fontSize: 14, 
                        color: ThemeManager.isRedMode ? Colors.white : null
                      )
                    ),
                    onTap: () => _openQuiz(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.blueGrey),
                    title: Text("Settings", 
                      style: TextStyle(
                        fontSize: 14, 
                        color: ThemeManager.isRedMode ? Colors.white : null
                      )
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: Text("Logout", 
                      style: TextStyle(
                        fontSize: 14, 
                        color: ThemeManager.isRedMode ? Colors.white : null
                      )
                    ),
                    onTap: () => FirebaseAuth.instance.signOut(),
                  ),
                ],
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("v1.0.0", style: TextStyle(color: Colors.grey, fontSize: 10)),
                ),
              ],
            ),
          ),

          // --- MAIN CONTENT AREA (RIGHT) ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("My Garden", 
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
                      if (user != null)
                        StreamBuilder<int>(
                          stream: _account.getUserXP(),
                          builder: (context, snapshot) {
                            final level = LevelCalculator.getLevel(snapshot.data ?? 0);
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: Text("LVL $level", 
                                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                if (user != null && widget.userRole != null)
                  _buildClassroomSlot(context),

                Expanded(
                  child: widget.tracked.isEmpty
                      ? const Center(child: Text("Add a plant to start tracking!"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: widget.tracked.length,
                          itemBuilder: (context, index) {
                            final plant = widget.tracked[index];
                            int thirstMeter = (100 - (plant.waterProgress * 100)).toInt();

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor, 
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlantDetailView(plantName: plant.name),
                                    ),
                                  );
                                },
                                onLongPress: () => _confirmDelete(context, plant),
                                title: Text(plant.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text("Thirst Meter: $thirstMeter%"),
                                trailing: const Icon(Icons.water_drop, color: Colors.blue),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassroomSlot(BuildContext context) {
    bool isTeacher = widget.userRole == 'Teacher';
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Container(
        width: 350,
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light 
              ? const Color(0xFFC8E6C9) 
              : Colors.green.withOpacity(0.1), 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              isTeacher ? "Teacher Dashboard" : "Join a Classroom", 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 12),
            if (isTeacher)
              ElevatedButton.icon(
                onPressed: () {}, 
                icon: const Icon(Icons.vpn_key_outlined, size: 18),
                label: const Text("Generate New Class Code"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: "Enter Code",
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_codeController.text.isNotEmpty && user != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'classCode': _codeController.text.trim()});
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Classroom joined successfully!")),
                          );
                          _codeController.clear();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Submit"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}