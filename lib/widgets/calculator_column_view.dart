import 'package:flutter/material.dart';
import 'package:calculator/widgets/calculator_row_view.dart';

class CalculatorColumnView extends StatelessWidget {
  final List<List<String>> buttonValues;
  final void Function(String text) onPressed;

  const CalculatorColumnView({
    required this.buttonValues,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...buttonValues.map(
          (buttonTexts) => Expanded(
            child: CalculatorRowView(
              buttonTexts: buttonTexts,
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
