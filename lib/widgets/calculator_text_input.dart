import 'package:flutter/material.dart';

class CalculatorTextInput extends StatelessWidget {
  final String text;
  const CalculatorTextInput({required this.text, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }
}
