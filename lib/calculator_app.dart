import "package:flutter/material.dart";
import "package:calculator/screens/calculator_screen.dart";

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 72, 93, 129),
          title: Text("Calculator"),
        ),
        body: CalculatorScreen(),
      ),
    );
  }
}
