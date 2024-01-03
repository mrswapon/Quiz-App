import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_test/models/questions.dart';
import 'package:quiz_test/views/screen/resultScreen/result_screen.dart';
import 'package:quiz_test/views/screen/welcomeScreen/welcome_screen.dart';

class QuizController extends GetxController {
  String name = '';
  int get countOfQuestion => _questionList.length;
  final List<Questions> _questionList = [
    Questions(
        id: 1,
        answer: 2,
        question:
            '1. Who developed the Flutter Framework and continues to maintain it today?',
        options: ['Facebook', 'Oracle', 'Google', 'Microsoft']),
    Questions(
        id: 2,
        answer: 1,
        question:
            '2. Which programming language is used to build Flutter applications?',
        options: ['Kotlin', 'Dart', 'Java', 'Go']),
    Questions(
        id: 3,
        answer: 0,
        question: '3. How many types of widgets are there in Flutter?',
        options: ['2', '4', '6', '7']),
    Questions(
        id: 4,
        answer: 1,
        question:
            '4. What widget would you use for repeating content in Flutter?',
        options: ['ExpandedView', 'ListView', 'Stack', 'ArrayView']),
    Questions(
        id: 5,
        answer: 2,
        question: '5. A sequence of asynchronous Flutter events is known as a:',
        options: ['Flow', 'Current', 'Stream', 'Series']),
    Questions(
        id: 6,
        answer: 1,
        question:
            '6. Access to a cloud database through Flutter is available through which service?',
        options: ['SQLite', 'Firebase Database', 'NOSQL', 'MYSQL']),
    Questions(
        id: 7,
        answer: 1,
        question:
            '7. What element is used as an identifier for components when programming in Flutter?',
        options: ['Widgets', 'Keys', 'Elements', 'Serial']),
    Questions(
        id: 8,
        answer: 1,
        question:
            '8. What type of test can examine your code as a complete system?',
        options: ['Widget tests', 'Integration Tests']),
    Questions(
        id: 9,
        answer: 0,
        question:
            '9. What is the key configuration file used when building a Flutter project?',
        options: ['pubspec.yaml', 'pubspec.xml', 'config.html', 'root.xml']),
    Questions(
        id: 10,
        answer: 0,
        question:
            '10. Flutter boasts improved runtime performance over most application frameworks?',
        options: ['True', 'False']),
  ];

  List<Questions> get questionsList => [..._questionList];

  bool _isPressed = false;

  bool get isPressed => _isPressed; //To check if the answer is pressed

  double _numberOfQuestion = 1;

  double get numberOfQuestion => _numberOfQuestion;

  int? _selectAnswer;

  int? get selectAnswer => _selectAnswer;

  int? _correctAnswer;

  int _countOfCorrectAnswers = 0;

  int get countOfCorrectAnswers => _countOfCorrectAnswers;

  //map for check if the question has been answered
  final Map<int, bool> _questionIsAnswered = {};

  //page view controller
  late PageController pageController;

  //timer
  Timer? _timer;

  final maxSec = 15;

  final RxInt _sec = 15.obs;

  RxInt get sec => _sec;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    resetAnswer();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  //==================================> Get Final score <==============================

  double get scoreResult {
    return _countOfCorrectAnswers * 100 / _questionList.length;
  }
  //================================> Check Answer Method <=============================

  void checkAnswer(Questions questions, int selectAnswer) {
    _isPressed = true;

    _selectAnswer = selectAnswer;
    _correctAnswer = questions.answer;

    if (_correctAnswer == _selectAnswer) {
      _countOfCorrectAnswers++;
    }
    stopTimer();
    _questionIsAnswered.update(questions.id, (value) => true);
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => nextQuestion());
    update();
  }

  //============================> Check if the question has been answered Method <=========================

  bool checkIsQuestionAnswered(int quesId) {
    return _questionIsAnswered.entries
        .firstWhere((element) => element.key == quesId)
        .value;
  }

  //=======================================> Next Question Method <================================

  void nextQuestion() {
    if (_timer != null || _timer!.isActive) {
      stopTimer();
    }

    if (pageController.page == _questionList.length - 1) {
      Get.offAndToNamed(ResultScreen.routeName);
    } else {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);

      startTimer();
    }
    _numberOfQuestion = pageController.page! + 2;
    update();
  }

  //=======================================> Reset Answer Method <================================
  void resetAnswer() {
    for (var element in _questionList) {
      _questionIsAnswered.addAll({element.id: false});
    }
    update();
  }

  //====================================> Right and Wrong Color Method <=============================

  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green.shade700;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Colors.red.shade700;
      }
    }
    return Colors.white;
  }

  //===================================> Right and Wrong Icon Method <==============================

  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }
  //=======================================> Start Timer Method <================================

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec.value > 0) {
        _sec.value--;
      } else {
        stopTimer();
        nextQuestion();
      }
    });
  }
  //=======================================> Rest Timer Method <================================

  void resetTimer() => _sec.value = maxSec;

  //=======================================> Stop Timer Method <================================

  void stopTimer() => _timer!.cancel();

  //=======================================> Start Again Method <================================
  void startAgain() {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    resetAnswer();
    _selectAnswer = null;
    Get.offAllNamed(WelcomeScreen.routeName);
  }
}
