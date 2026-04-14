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