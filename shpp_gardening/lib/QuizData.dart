class QuizModel {
  final String title;
  final List<Map<String, dynamic>> questions;

  QuizModel({required this.title, required this.questions});
}

final List<QuizModel> quizBank = [
  QuizModel(
    title: "Plant Riddles #1",
    questions: [
      {
        'riddle': "I like soft soil and produce fruit. What am I?",
        'options': ['Tomato', 'Oak', 'Mint', 'Rosemary'],
        'correctIndex': 0,
        'xpValue': 20,
      },
      {
        'riddle': "I'm great in tea and mojitos!",
        'options': ['Lavender', 'Mint', 'Aloe', 'Basil'],
        'correctIndex': 1,
        'xpValue': 20,
      },
    ],
  ),

  // --- QUIZ 2 RIDDLE EXAMPLE ---
  QuizModel(
    title: "Plant Riddles #2",
    questions: [
      {
        'riddle': "Which plant can grow a big red fruit?",
        'options': ['Cactus', 'Rosemary', 'Tomato', 'Rose'],
        'correctIndex': 2,
        'xpValue': 20,
      },
      {
        'riddle': "I can grow very tall and provide shade. What am I?",
        'options': ['Sunflower', 'Oak', 'Bamboo', 'Pine'],
        'correctIndex': 1,
        'xpValue': 20,
      },
    ],
  ),

  // --- QUIZ 3 RIDDLE EXAMPLE ---
  QuizModel(
    title: "Plant Riddles #3",
    questions: [
      {
        'riddle': "I have thorns but I'm not a cactus. What am I?",
        'options': ['Rose', 'Cactus', 'Mint', 'Aloe'],
        'correctIndex': 0,
        'xpValue': 20,
      },
      {
        'riddle': "I can be used in cooking and have a strong aroma. What am I?",
        'options': ['Basil', 'Oak', 'Sunflower', 'Pine'],
        'correctIndex': 0,
        'xpValue': 20,
      },
    ],
  ),
];