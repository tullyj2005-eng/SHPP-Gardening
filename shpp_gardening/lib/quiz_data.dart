class QuizModel {
  final String title;
  final String type; // 'multiple_choice' or 'riddle'
  final List<Map<String, dynamic>> questions;

  QuizModel({required this.title, required this.type, required this.questions});
}

final List<QuizModel> quizBank = [
  // EXAMPLE 1: RIDDLE (Copy this block to add more riddles)
  QuizModel(
    title: "Nature's Riddle #1",
    type: "riddle",
    questions: [
      {
        "question": "I have no mouth but I always eat, I have no feet but I stand tall. What am I?",
        "answer": "tree" // Acceptable answers (case-insensitive)
      },
    ],
  ),

  // EXAMPLE 2: MULTIPLE CHOICE (Copy this block for standard quizzes)
  QuizModel(
    title: "Greek Soil Basics",
    type: "multiple_choice",
    questions: [
      {
        "question": "What is the primary soil type in southern Greece?", 
        "options": ["Clay", "Limestone/Rocky", "Sandy", "Peat"], 
        "answer": 1 // Index of 'Limestone/Rocky'
      },
    ],
  ),
];