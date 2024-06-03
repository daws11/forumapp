import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';

class QuizPage extends StatelessWidget {
  final QuizController quizController = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Obx(() {
        if (quizController.currentQuestionIndex.value <
            quizController.questions.length) {
          var question = quizController
              .questions[quizController.currentQuestionIndex.value];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${quizController.currentQuestionIndex.value + 1} of ${quizController.questions.length}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    question.question,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 20),
                  ...question.choices.map((choice) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 13, 13, 14),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          textStyle: TextStyle(fontSize: 14.0),
                        ),
                        onPressed: () {
                          quizController.checkAnswer(choice);
                        },
                        child: Text(choice),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quiz Completed!',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Your score is ${quizController.score.value} out of ${quizController.questions.length}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Back to Home'),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
