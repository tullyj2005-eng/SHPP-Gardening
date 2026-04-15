import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_logic.dart';
import 'quiz_play_view.dart';
import 'quiz_data.dart';
import 'quiz_model.dart';

class TeacherQuizView extends StatefulWidget {
  final String classCode;

  const TeacherQuizView({super.key, required this.classCode});

  @override
  State<TeacherQuizView> createState() => _TeacherQuizViewState();
}

class _TeacherQuizViewState extends State<TeacherQuizView> {
  
  // Posts a quiz containing multiple questions to the specific classroom
  void _postFromBank(Quiz quiz) async {
    // We must convert the Question objects into Maps for Firestore
    final List<Map<String, dynamic>> serializedQuestions = quiz.questions.map((q) {
      return {
        'questionText': q.questionText,
        'type': q.type,
        'correctAnswer': q.correctAnswer,
        'options': q.options,
      };
    }).toList();

    final quizData = {
      'title': quiz.title,
      'questions': serializedQuestions,
      'postedAt': FieldValue.serverTimestamp(),
    };
    
    try {
      await AccountLogic().postQuizToClass(widget.classCode, quizData);
      if (mounted) {
        Navigator.pop(context); // Close the selection dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully assigned '${quiz.title}'")),
        );
      }
    } catch (e) {
      debugPrint("Error posting quiz: $e");
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
                if (snapshot.hasError) return const Center(child: Text("Error loading quizzes"));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No active quizzes. Use the + button to assign one."),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final quizDoc = docs[index];
                    final data = quizDoc.data() as Map<String, dynamic>;
                    final List questionsList = data['questions'] ?? [];

                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.menu_book, color: Colors.white, size: 20),
                      ),
                      title: Text(data['title'] ?? 'Untitled Quiz'),
                      subtitle: Text("${questionsList.length} Questions • Tap to Preview"),
                      onTap: () {
                        // Pass the data to the Play View for teacher preview
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPlayView(quizData: data),
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

                if (results.isEmpty) return const Center(child: Text("No results submitted yet."));

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final res = results[index];
                    return ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(res['studentEmail'] ?? "Unknown Student"),
                      subtitle: Text("Quiz: ${res['quizTitle']}"),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          "Score: ${res['score']}", 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.grey.shade100,
      child: Text(
        title.toUpperCase(), 
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.grey.shade700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  void _showQuizBankDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Assign from Quiz Bank"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: quizBank.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final quiz = quizBank[index];
              return ListTile(
                title: Text(quiz.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text("${quiz.questions.length} Items"),
                trailing: const Icon(Icons.send, color: Colors.green, size: 20),
                onTap: () => _postFromBank(quiz),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}