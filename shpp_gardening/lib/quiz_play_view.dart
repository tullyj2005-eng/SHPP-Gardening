import 'package:flutter/material.dart';

class QuizPlayView extends StatefulWidget {
  final Map<String, dynamic> quizData;

  const QuizPlayView({super.key, required this.quizData});

  @override
  State<QuizPlayView> createState() => _QuizPlayViewState();
}

class _QuizPlayViewState extends State<QuizPlayView> {
  int _currentIndex = 0;
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final questions = widget.quizData['questions'] as List<dynamic>;
    final currentQ = questions[_currentIndex];
    bool isRiddle = widget.quizData['type'] == 'riddle';

    return Scaffold(
      appBar: AppBar(title: Text(widget.quizData['title'])),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Question ${_currentIndex + 1} of ${questions.length}", 
                 style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Text(currentQ['question'] ?? currentQ['q'], 
                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            if (isRiddle)
              TextField(
                controller: _answerController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Your answer..."),
              )
            else
              ...(currentQ['options'] as List<dynamic>).map((opt) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    onPressed: () => _nextQuestion(questions.length),
                    child: Text(opt),
                  ),
                ),
              ),
            
            const Spacer(),
            if (isRiddle)
              ElevatedButton(
                onPressed: () => _nextQuestion(questions.length),
                child: const Text("Submit Answer"),
              ),
          ],
        ),
      ),
    );
  }

  void _nextQuestion(int total) {
    if (_currentIndex < total - 1) {
      setState(() {
        _currentIndex++;
        _answerController.clear();
      });
    } else {
      Navigator.pop(context); // Quiz finished
    }
  }
}