import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';    
import 'account_logic.dart';

class QuizPlayView extends StatefulWidget {
  final Map<String, dynamic> quizData;

  const QuizPlayView({super.key, required this.quizData});

  @override
  State<QuizPlayView> createState() => _QuizPlayViewState();
}

class _QuizPlayViewState extends State<QuizPlayView> {
  int _currentIndex = 0;
  int _score = 0; 
  bool _isWrong = false; 
  final TextEditingController _answerController = TextEditingController();
  final AccountLogic _account = AccountLogic();

  void _nextQuestion(int total, Map<String, dynamic> currentQ, {String? selectedAnswer}) {
    String correct = currentQ['correctAnswer'] ?? "";
    String userResponse = selectedAnswer ?? _answerController.text.trim();

    if (userResponse.toLowerCase() == correct.toLowerCase()) {
      _score++;
    } else {
      // Trigger the red flash
      setState(() => _isWrong = true);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _isWrong = false);
      });
    }

    if (_currentIndex < total - 1) {
      setState(() {
        _currentIndex++;
        _answerController.clear();
      });
    } else {
      _showResults(total);
    }
  }

  void _showResults(int total) async {
    int xpGained = _score * 10;
    await _account.addExperience(xpGained);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Complete!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("You got $_score out of $total correct."),
            const SizedBox(height: 10),
            Text("+$xpGained XP", 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              final quizTitle = widget.quizData['title'];

              if (user != null && quizTitle != null) {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({
                    'completedQuizzes': FieldValue.arrayUnion([quizTitle])
                  });
                } catch (e) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .set({
                    'completedQuizzes': [quizTitle]
                  }, SetOptions(merge: true));
                }
              }

              if (mounted) {
                Navigator.pop(context); 
                Navigator.pop(context); 
              }
            },
            child: const Text("Finish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.quizData['questions'] as List<dynamic>;
    final currentQ = questions[_currentIndex] as Map<String, dynamic>;
    String type = currentQ['type'] ?? 'multiple_choice';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizData['title'] ?? "Quiz"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      // --- WRAPPED BODY IN ANIMATED CONTAINER FOR FLASH ---
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _isWrong ? Colors.red.withOpacity(0.4) : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / questions.length,
                backgroundColor: Colors.grey.shade200,
                color: Colors.green,
              ),
              const SizedBox(height: 10),
              Text("Question ${_currentIndex + 1} of ${questions.length}", 
                   style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant, 
                    fontWeight: FontWeight.w500
                    )
                  ),
              const SizedBox(height: 30),
              Text(
                currentQ['questionText'] ?? "No Question text found", 
                   style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  )),
              const SizedBox(height: 30),
              if (type == 'riddle') ...[
                TextField(
                  controller: _answerController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Your Answer",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _nextQuestion(questions.length, currentQ),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text("Έτοιμοι!"),
                  ),
                )
              ] else ...[
                ...(currentQ['options'] as List<dynamic>? ?? []).map((opt) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        side: BorderSide(color: Colors.green.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _nextQuestion(questions.length, currentQ, selectedAnswer: opt.toString()),
                      child: Text(opt.toString(), style: const TextStyle(fontSize: 16)), //atempt fix black button text
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}