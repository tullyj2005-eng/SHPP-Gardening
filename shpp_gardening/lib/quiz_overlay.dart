import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizOverlay extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String userRole;
  final String? quizId;
  final String? classCode;


  const QuizOverlay({
    super.key,
    required this.questions,
    required this.userRole,
    this.quizId,
    this.classCode,
  });

  @override
  State<QuizOverlay> createState() => _QuizOverlayState();
}

class _QuizOverlayState extends State<QuizOverlay> {
  int _currentIndex = 0;
  int _totalXP = 0;

  void _submitAnswer(int index) {
    if (index == widget.questions[_currentIndex]['correctIndex']) {
      _totalXP += widget.questions[_currentIndex]['xpValue'] as int;
    }

    setState(() {
      if (_currentIndex < widget.questions.length - 1) {
        _currentIndex++;
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() async {
    if (widget.userRole == 'Student') {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'xp': FieldValue.increment(_totalXP),
        });


        // delete the quiz from active quizzes once completed
        if (widget.classCode != null && widget.quizId != null) {
          await FirebaseFirestore.instance
              .collection('classes')
              .doc(widget.classCode)
              .collection('activeQuizzes')
              .doc(widget.quizId)
              .delete();
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Complete!"),
        content: Text("You earned $_totalXP XP!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close overlay
            },
            child: const Text("Done"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = widget.questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  LinearProgressIndicator(value: (_currentIndex + 1) / widget.questions.length),
                  const SizedBox(height: 20),
                  Text(currentQ['riddle'], 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), 
                    textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  Expanded(child: Image.asset('assets/Leaf (1).png')),
                  const SizedBox(height: 30),
                  ...List.generate(4, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _submitAnswer(index),
                        child: Text(currentQ['options'][index]),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//QUIZ STRUCTURE/SKELETON
/*
// 1. Define your 5 questions
List<Map<String, dynamic>> myQuizData = [
  {
    'riddle': "I like soft soil and produce fruit. What am I?",
    'options': ['Tomato', 'Oak', 'Mint', 'Rosemary'],
    'correctIndex': 0,
    'xpValue': 20,
  },
  // ... add 4 more here
];

// 2. Open the overlay
Navigator.push(
  context,
  MaterialPageRoute(
    fullscreenDialog: true, // This makes it cover the screen
    builder: (context) => QuizOverlay(
      questions: myQuizData,
      userRole: 'Student', // or 'Teacher'
    ),
  ),
);
*/