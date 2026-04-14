import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_logic.dart';
import 'student_quiz_view.dart';
import 'quiz_play_view.dart'; //
import 'quiz_data.dart'; //

class TeacherQuizView extends StatefulWidget {
  final String classCode;

  const TeacherQuizView({super.key, required this.classCode});

  @override
  State<TeacherQuizView> createState() => _TeacherQuizViewState();
}

class _TeacherQuizViewState extends State<TeacherQuizView> {
  
  // Posts a quiz from the central bank to this specific class
  void _postFromBank(QuizModel quiz) async {
    final quizData = {
      'title': quiz.title,
      'type': quiz.type,
      'questions': quiz.questions,
    };
    
    await AccountLogic().postQuizToClass(widget.classCode, quizData);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Posted ${quiz.title} to class!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Dashboard: ${widget.classCode}"),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSectionHeader("Quizzes Currently in Classroom"),
          Expanded(
            flex: 2,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('classes')
                  .doc(widget.classCode)
                  .collection('activeQuizzes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;

                if (docs.isEmpty) return const Center(child: Text("No active quizzes. Use the + button to assign one."));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final quizDoc = docs[index];
                    final data = quizDoc.data() as Map<String, dynamic>;
                    bool isRiddle = data['type'] == 'riddle';

                    return ListTile(
                      leading: Icon(
                        isRiddle ? Icons.help_outline : Icons.quiz, 
                        color: Colors.green
                      ),
                      title: Text(data['title'] ?? 'Untitled Quiz'),
                      subtitle: const Text("Tap to Preview Quiz Content"),
                      onTap: () {
                        // FIX: Directly open the Play/View screen for the teacher
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPlayView(
                              quizData: data,
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => quizDoc.reference.delete(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          const Divider(thickness: 2),

          _buildSectionHeader("Student Progress"),
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: AccountLogic().getStudentResults(widget.classCode),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final results = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final res = results[index];
                    return ListTile(
                      title: Text(res['studentEmail'] ?? "Unknown Student"),
                      subtitle: Text("Quiz: ${res['quizTitle']}"),
                      trailing: Text("Score: ${res['score']}", 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: _showQuizBankDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey.shade100,
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  void _showQuizBankDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Assign from Quiz Bank"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: quizBank.length, //
            itemBuilder: (context, index) {
              final quiz = quizBank[index];
              return Card(
                child: ListTile(
                  title: Text(quiz.title),
                  subtitle: Text(quiz.type == 'riddle' ? "Riddle" : "Multiple Choice"),
                  trailing: const Icon(Icons.send, color: Colors.green),
                  onTap: () => _postFromBank(quiz),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ],
      ),
    );
  }
}