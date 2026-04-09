import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; 
import 'LoginPage.dart'; 
import 'TeacherQuizView.dart';
import 'StudentQuizView.dart';
import 'AccountLogic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final List<TrackedPlant> tracked;
  final String? userRole; 

  const HomeScreen({super.key, required this.tracked, this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // We move the controller here so it persists during rebuilds
  final TextEditingController _codeController = TextEditingController();
  bool _isProcessing = false;

  // Helper to fetch the code and open the correct view
  void _openQuiz(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.userRole == null) return;

    // 1. Fetch the user's document to get their specific code
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return;

    // 2. Get the code based on role
    // Teachers use 'myClassCode', Students use 'classCode'
    String code = widget.userRole == 'Teacher' 
        ? userDoc.get('myClassCode') ?? "" 
        : userDoc.get('classCode') ?? "";

    if (code.isEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please generate or join a class first!")),
      );
      return;
    }

    // 3. Navigate and pass the required 'classCode'
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
  void dispose() {
    _codeController.dispose(); // Always clean up controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          body: Row(
            children: [
              // --- SIDEBAR ---
              Container(
                width: 200,
                color: Colors.green.shade50,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (user == null) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        }
                      },
                      child: UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.green.shade800),
                        currentAccountPicture: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: Colors.green),
                        ),
                        accountName: Text(user == null ? "Guest" : "Active User"),
                        accountEmail: Text(user?.email ?? "Tap to Sign In"),
                      ),
                    ),
                    if (user != null)
                      ListTile(
                        leading: const Icon(Icons.quiz, color: Colors.orange),
                        title: const Text('Garden Quiz'),
                        onTap: () => _openQuiz(context),
                      ),
                    const Divider(),
                    if (user != null)
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.redAccent),
                        title: const Text('Logout'),
                        onTap: () => FirebaseAuth.instance.signOut(),
                      ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("v1.0.0", style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),

              // --- GARDEN CONTENT + CLASSROOM SLOT ---
              Expanded(
                child: Scaffold(
                  appBar: AppBar(title: const Text("My Garden"), elevation: 0),
                  body: Column(
                    children: [
                      if (user != null && widget.userRole != null)
                        _buildClassroomSlot(context),

                      Expanded(
                        child: widget.tracked.isEmpty
                            ? const Center(child: Text("No plants being tracked yet."))
                            : ListView.builder(
                                itemCount: widget.tracked.length,
                                itemBuilder: (context, index) {
                                  final plant = widget.tracked[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                                    child: InkWell(
                                      onTap: () {
                                        // Specific logic for Rosemary
                                        if (plant.name == 'Rosemary') {
                                          rosemary(context, () {}); // Passing empty callback since already tracked
                                        }
                                        else if(plant.name.contains("Mint")) {
                                          mint(context, () {});
                                        }
                                        else if (plant.name.contains("Oregano")) {
                                          oregano(context, () {});
                                        }
                                      },
                                      child: ListTile(
                                        title: Text(plant.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        subtitle: Text("Progress: ${(plant.waterProgress * 100).toInt()}%"),
                                        trailing: const Icon(Icons.water_drop, color: Colors.blue),
                                      ),
=======
=======
>>>>>>> parent of 98040659 (Added features)
=======
>>>>>>> parent of 98040659 (Added features)
                                    child: ListTile(
                                      title: Text(plant.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      subtitle: Text("Progress: ${(plant.waterProgress * 100).toInt()}%"),
                                      trailing: const Icon(Icons.water_drop, color: Colors.blue),
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> parent of 98040659 (Added features)
=======
>>>>>>> parent of 98040659 (Added features)
=======
>>>>>>> parent of 98040659 (Added features)
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassroomSlot(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: widget.userRole == 'Teacher'
          ? Column(
              children: [
                const Text("Class Management", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _isProcessing 
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: () async {
                        setState(() => _isProcessing = true);
                        try {
                          String code = await AccountLogic().createClass();
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Share this Code"),
                                content: SelectableText(code, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
                              ),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isProcessing = false);
                        }
                      },
                      icon: const Icon(Icons.add_link),
                      label: const Text("Generate New Class Code"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
                    ),
              ],
            )
          : Column(
              children: [
                const Text("Join Your Teacher's Class", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        enabled: !_isProcessing,
                        decoration: const InputDecoration(
                          hintText: "Enter Code",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _isProcessing 
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_codeController.text.isEmpty) return;
                            
                            setState(() => _isProcessing = true);
                            try {
                              bool success = await AccountLogic().joinClass(_codeController.text.trim());
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(success ? "Joined Class!" : "Invalid Code")),
                                );
                                if (success) _codeController.clear();
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error joining: $e")),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _isProcessing = false);
                            }
                          },
                          child: const Text("Join"),
                        ),
                  ],
                ),
              ],
            ),
    );
  }
}