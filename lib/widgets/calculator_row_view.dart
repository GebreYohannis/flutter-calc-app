import 'package:flutter/material.dart';
import "package:calculator/widgets/calculator_button.dart";

class CalculatorRowView extends StatelessWidget {
  final List<String> buttonTexts;
  final void Function(String text) onPressed;

  const CalculatorRowView({
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
          (text) => Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: CalculatorButton(
                text: text,
                onPressed: () => onPressed(text),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
