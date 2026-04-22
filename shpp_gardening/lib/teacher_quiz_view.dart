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
    // Convert Question objects into Maps for Firestore
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
          SnackBar(content: Text("Ολοκληρώθηκε η ανάθεση :'${quiz.title}'")),
        );
      }
    } catch (e) {
      debugPrint("Πρόβλημα στην ανάρτηση του κουίζ: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- THE GATEKEEPER ---
    // This prevents the "Invalid Argument" crash by checking the path before Firestore sees it.
    if (widget.classCode.trim().isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Σφάλμα Κωδικού")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  "Δεν βρέθηκε έγκυρος κωδικός τάξης.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Παρακαλώ επιστρέψτε στην αρχική και δημιουργήστε έναν κωδικό τάξης πριν ανοίξετε το Dashboard.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Επιστροφή"),
                )
              ],
            ),
          ),
        ),
      );
    }

    // --- MAIN DASHBOARD UI ---
    // This only runs if widget.classCode is a non-empty string.
    return Scaffold(
      appBar: AppBar(
        title: Text("Οθόνη δασκάλου: ${widget.classCode}"),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSectionHeader("Ενεργά Κουίζ στην τάξη αυτή τη στιγμή"),
          Expanded(
            flex: 2,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('classes')
                  .doc(widget.classCode)
                  .collection('activeQuizzes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Σφάλμα φόρτωσης κουίζ"));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Text("Κανένα ενεργό κουίζ. Πατήστε το κουμπί + για να αναθέσετε ένα."),
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
                      subtitle: Text("${questionsList.length} Ερωτήσεις • Πατήστε για λεπτομέρειες"),
                      onTap: () {
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

          _buildSectionHeader("Πρόοδος μαθητών"),
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: AccountLogic().getStudentResults(widget.classCode),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final results = snapshot.data!.docs;

                if (results.isEmpty) return const Center(child: Text("Κανένα αποτέλεσμα δεν έχει υποβληθεί ακόμα."));

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
                          "Βαθμολογία: ${res['score']}", 
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
        title: const Text("Αναθέστε κουίζ από την Τράπεζα Κουίζ"),
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
                subtitle: Text("${quiz.questions.length} Ερωτήσεις"),
                trailing: const Icon(Icons.send, color: Colors.green, size: 20),
                onTap: () => _postFromBank(quiz),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Ακύρωση"),
          ),
        ],
      ),
    );
  }
} //2,334 lines of code in the whole project at the time of this comment - niko geussed 2337