import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_overlay.dart';


class StudentQuizView extends StatelessWidget {
  final String classCode;

  const StudentQuizView({super.key, required this.classCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Quizzes"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('classes')
            .doc(classCode)
            .collection('activeQuizzes')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['title']),
                trailing: const Icon(Icons.play_arrow, color: Colors.green),
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => QuizOverlay(
        questions: List<Map<String, dynamic>>.from(doc['questions']),
        userRole: 'Student',
        quizId: doc.id,
        classCode: classCode,
      ),
    ),
  );
},
              );
            }).toList(),
          );
        },
      ),
    );
  }
}