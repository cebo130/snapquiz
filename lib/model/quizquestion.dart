class QuizQuestion {
  String questionText;
  Map<String, String> options;
  String correctOption;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOption,
  });
}
