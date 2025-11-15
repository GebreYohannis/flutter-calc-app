import 'package:flutter/material.dart';
import 'package:calculator/widgets/calculator_row_grid.dart';

class CalculatorColumnGird extends StatelessWidget {
  final List<List<String>> buttonValues;
  final void Function(String text) onPressed;

  const CalculatorColumnGird({
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
          (buttonTexts) =>
              CalculatorRowGrid(buttonTexts: buttonTexts, onPressed: onPressed),
        ),
      ],
    );
  }
}
