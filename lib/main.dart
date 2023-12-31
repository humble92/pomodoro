import 'package:flutter/material.dart';
import 'package:pomodoro/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        cardColor: const Color.fromRGBO(161, 128, 43, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 47, 112, 90),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
