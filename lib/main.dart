import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/bindings_app.dart';
import 'views/screen/quizScreen/quiz_screen.dart';
import 'views/screen/resultScreen/result_screen.dart';
import 'views/screen/welcomeScreen/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: BilndingsApp(),
        title: 'Quiz Test App',
        home: const WelcomeScreen(),
        getPages: [
          GetPage(name: WelcomeScreen.routeName, page: () => const WelcomeScreen()),
          GetPage(name: QuizScreen.routeName, page: () => const QuizScreen()),
          GetPage(name: ResultScreen.routeName, page: () => const ResultScreen()),
        ]);
  }
}
