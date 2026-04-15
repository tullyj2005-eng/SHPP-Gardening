import 'package:flutter/material.dart';
import 'account_logic.dart';

class QuizPlayView extends StatefulWidget {
  final Map<String, dynamic> quizData;

  const QuizPlayView({super.key, required this.quizData});

  @override
  State<QuizPlayView> createState() => _QuizPlayViewState();
}

class _QuizPlayViewState extends State<QuizPlayView> {
  int _currentIndex = 0;
  int _score = 0; // Tracks correct answers
  final TextEditingController _answerController = TextEditingController();
  final AccountLogic _account = AccountLogic();

  void _nextQuestion(int total, Map<String, dynamic> currentQ, {String? selectedAnswer}) {
    // 1. Check Answer
    String correct = currentQ['correctAnswer'] ?? "";
    String userResponse = selectedAnswer ?? _answerController.text.trim();

    if (userResponse.toLowerCase() == correct.toLowerCase()) {
      _score++;
    }

    // 2. Navigation Logic
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
    // Award 10 XP per correct answer
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
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to Garden Home
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
    
    // Check type of current question
    String type = currentQ['type'] ?? 'multiple_choice';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizData['title'] ?? "Quiz"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Header
            LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            Text("Question ${_currentIndex + 1} of ${questions.length}", 
                 style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            
            const SizedBox(height: 30),
            
            // Question Text
            Text(currentQ['questionText'] ?? "No Question text found", 
                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 30),
            
            // Input Area
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
                  child: const Text("Submit Answer"),
                ),
              )
            ] else ...[
              // Multiple Choice Options
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
                    child: Text(opt.toString(), style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}