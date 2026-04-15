
/*
class Quiz {
  final String id;
  final String title;
  final String question;
  final String type; // 'riddle' or 'multiple_choice'
  final String correctAnswer;
  final List<String> options;

  Quiz({
    required this.id, 
    required this.title, 
    required this.question, 
    required this.type,
    required this.correctAnswer,
    this.options = const [],
  });

  factory Quiz.fromFirestore(Map<String, dynamic> data, String id) {
    return Quiz(
      id: id,
      title: data['title'] ?? 'Untitled Quiz',
      question: data['question'] ?? '',
      type: data['type'] ?? 'multiple_choice',
      correctAnswer: data['correctAnswer'] ?? '',
      options: List<String>.from(data['options'] ?? []),
    );
  }
}
*/

// --MULTIQUESTION QUIZ MODEL--
class Quiz {
  final String id;
  final String title;
  final List<Question> questions; // This allows for multiple questions

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory Quiz.fromFirestore(Map<String, dynamic> data, String id) {
    // Maps the 'questions' array from Firestore into a List of Question objects
    var questionList = (data['questions'] as List? ?? [])
        .map((q) => Question.fromMap(q))
        .toList();

    return Quiz(
      id: id,
      title: data['title'] ?? 'New Quiz',
      questions: questionList,
    );
  }
}


// --DEFINING THE QUESTION AS ITS OWN MODEL ALLOWS FOR MULTIPLE QUESTIONS PER QUIZ--
class Question {
  final String questionText;
  final String type; // 'riddle' or 'multiple_choice'
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.questionText,
    required this.type,
    required this.correctAnswer,
    this.options = const [],
  });

  // Helper to convert from a Map (useful for Firestore sub-collections or arrays)
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionText: map['questionText'] ?? '',
      type: map['type'] ?? 'multiple_choice',
      correctAnswer: map['correctAnswer'] ?? '',
      options: List<String>.from(map['options'] ?? []),
    );
  }
}