import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:forumapp/models/quiz_model.dart';

class QuizController extends GetxController {
  var questions = <QuizQuestion>[].obs;
  var currentQuestionIndex = 0.obs;
  var score = 0.obs;

  @override
  void onInit() {
    loadQuestions();
    super.onInit();
  }

  Future<void> loadQuestions() async {
    final String response =
        await rootBundle.loadString('assets/quiz_questions.json');
    final data = await json.decode(response) as List;
    questions.value =
        data.map((question) => QuizQuestion.fromJson(question)).toList();
  }

  void checkAnswer(String selectedAnswer) {
    if (questions[currentQuestionIndex.value].answer == selectedAnswer) {
      score.value++;
    }
    currentQuestionIndex.value++;
  }
}
