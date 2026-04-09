import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  // Here you would navigate to a 'TakingQuizView' 
                  // passing the doc['questions'] and doc['title']
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}