import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AccountLogic.dart';
import 'QuizData.dart';
import 'quiz_overlay.dart';

class TeacherQuizView extends StatelessWidget {
  final String classCode; // Pass this from HomeScreen

  const TeacherQuizView({super.key, required this.classCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Dashboard: $classCode"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Go back to Home
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Quiz Bank", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          // List of Premade Quizzes
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: quizBank.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        // Under your "Send to Class" button or as an IconButton at the top
IconButton(
  icon: const Icon(Icons.play_circle_fill, color: Colors.green),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => QuizOverlay(
          questions: quizBank[index].questions,
          userRole: 'Teacher',
        ),
      ),
    );
  },
),
                        Text(quizBank[index].title, textAlign: TextAlign.center),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => AccountLogic().postQuizToClass(classCode, {
                            'title': quizBank[index].title,
                            'questions': quizBank[index].questions,
                          }),
                          child: const Text("Send to Class"),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          const Text("Student Results", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: AccountLogic().getStudentResults(classCode),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(doc['studentEmail']),
                      subtitle: Text("Quiz: ${doc['quizTitle']}"),
                      trailing: Text("${doc['score']}/${doc['total']}", 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}