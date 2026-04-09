class QuizModel {
  final String title;
  final List<Map<String, dynamic>> questions;

  QuizModel({required this.title, required this.questions});
}

final List<QuizModel> quizBank = [
  QuizModel(
    title: "Greek Soil Basics",
    questions: [
      {"question": "What is the primary soil type in southern Greece?", "options": ["Clay", "Limestone/Rocky", "Sandy", "Peat"], "answer": 1},
      {"question": "Does lavender prefer well-draining soil?", "options": ["Yes", "No"], "answer": 0},
    ],
  ),
  QuizModel(
    title: "Watering Schedule",
    questions: [
      {"question": "How often should you water Olive trees in pots?", "options": ["Every day", "Once a month", "When the top inch is dry", "Never"], "answer": 2},
    ],
  ),
];