import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'quiz_play_view.dart';

class StudentQuizView extends StatelessWidget {
  final String classCode;

  const StudentQuizView({
    super.key, 
    required this.classCode,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Διαθέσιμα Κουίζ"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) return Center(child: Text("Error: ${userSnapshot.error}"));
          if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());

          final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
          List<dynamic> completedTitles = userData != null && userData.containsKey('completedQuizzes')
              ? userData['completedQuizzes']
              : [];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('classes')
                .doc(classCode)
                .collection('activeQuizzes')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

              final availableQuizzes = snapshot.data!.docs.where((doc) {
                String quizTitle = doc.get('title') ?? "";
                return !completedTitles.contains(quizTitle);
              }).toList();

              if (availableQuizzes.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                      SizedBox(height: 16),
                      Text(
                        "ΌΛΑ ΤΑ ΚΟΥΙΖ ΟΛΟΚΛΗΡΩΘΗΚΑΝ!",
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Έλα ξανά αργότερα για νέες προκλήσεις!", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: availableQuizzes.length,
                itemBuilder: (context, index) {
                  final doc = availableQuizzes[index];
                  final data = doc.data() as Map<String, dynamic>;
                  bool isRiddle = data['type'] == 'riddle';

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.withOpacity(0.1),
                        child: Icon(
                          isRiddle ? Icons.help_outline : Icons.quiz, 
                          color: Colors.green
                        ),
                      ),
                      title: Text(data['title'] ?? 'Untitled Quiz', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(isRiddle ? "Πρόκληση γρίφου" : "Πολλαπλής επιλογής"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPlayView(
                              quizData: {
                                'id': doc.id,
                                'title': data['title'],
                                'type': data['type'],
                                'questions': data['questions'],
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}