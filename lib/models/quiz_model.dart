class QuizQuestion {
  final String question;
  final List<String> choices;
  final String answer;

  QuizQuestion(
      {required this.question, required this.choices, required this.answer});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
        question: json['question'],
        choices: List<String>.from(json['choices']),
        answer: json['answer']);
  }
}
