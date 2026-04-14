import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_play_view.dart'; // Ensure this file exists and handles the quizData

class StudentQuizView extends StatelessWidget {
  final String classCode;
  final List<String> completedTitles; // List of titles the student already finished

  const StudentQuizView({
    super.key, 
    required this.classCode, 
    this.completedTitles = const []
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Quizzes"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('classes')
            .doc(classCode)
            .collection('activeQuizzes')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          // FILTER LOGIC: Only show quizzes NOT in the completed list
          // Note: For Teachers, completedTitles is passed as [] so nothing is filtered out
          final availableQuizzes = snapshot.data!.docs.where((doc) {
            return !completedTitles.contains(doc.get('title'));
          }).toList();

          if (availableQuizzes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "No quizzes available at the moment!",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: availableQuizzes.length,
            itemBuilder: (context, index) {
              final doc = availableQuizzes[index];
              final data = doc.data() as Map<String, dynamic>;
              bool isRiddle = data['type'] == 'riddle';

              return ListTile(
                leading: Icon(
                  isRiddle ? Icons.help_outline : Icons.quiz, 
                  color: Colors.green
                ),
                title: Text(data['title'] ?? 'Untitled Quiz'),
                subtitle: Text(isRiddle ? "Type: Riddle" : "Type: Multiple Choice"),
                trailing: const Icon(Icons.play_arrow, color: Colors.green),
                onTap: () {
                  // CORRECTED: Navigates to the play view with the document data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPlayView(
                        quizData: {
                          'title': data['title'],
                          'type': data['type'],
                          'questions': data['questions'],
                        },
                      ),
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