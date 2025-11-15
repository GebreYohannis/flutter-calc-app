import 'package:flutter/material.dart';
import "package:calculator/widgets/calculator_button.dart";

class CalculatorRowGrid extends StatelessWidget {
  final List<String> buttonTexts;
  final void Function(String text) onPressed;
  
  const CalculatorRowGrid({
    required this.buttonTexts,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...buttonTexts.map(
          (text) =>
              CalculatorButton(text: text, onPressed: () => onPressed(text)),
        ),
      ],
    );
  }
}
