import "package:flutter/material.dart";

import 'package:calculator/widgets/calculator_text_input.dart';
import "package:calculator/widgets/calculator_column_gird.dart";

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CalculatorScreenState();
  }
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = "0";
  String _currentInput = "";
  String _operator = "";
  double _firstNumber = 0;
  bool _shouldResetDisplay = false;

  @override
  void initState() {
    super.initState();
    _display = "0";
    _currentInput = "";
    _operator = "";
    _firstNumber = 0;
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        // Clear everything
        _display = "0";
        _currentInput = "";
        _operator = "";
        _firstNumber = 0;
        _shouldResetDisplay = false;
      } else if (buttonText == "=") {
        // Perform calculation
        if (_operator.isNotEmpty && _currentInput.isNotEmpty) {
          double secondNumber = double.parse(_currentInput);
          double result = _calculate(_firstNumber, secondNumber, _operator);
          _display = _formatResult(result);
          _currentInput = result.toString();
          _operator = "";
          _shouldResetDisplay = true;
        }
      } else if (["+", "-", "X", "%"].contains(buttonText)) {
        // Handle operators
        if (_currentInput.isNotEmpty) {
          _firstNumber = double.parse(_currentInput);
          _operator = buttonText == "X" ? "*" : buttonText;
          _shouldResetDisplay = true;
        }
      } else if (buttonText == "+/-") {
        // Toggle positive/negative
        if (_currentInput.isNotEmpty) {
          double number = double.parse(_currentInput);
          number = -number;
          _currentInput = number.toString();
          _display = _currentInput;
        }
      } else if (buttonText == ".") {
        // Handle decimal point
        if (!_currentInput.contains(".")) {
          _currentInput += _currentInput.isEmpty ? "0." : ".";
          _display = _currentInput;
        }
      } else if (buttonText == "()") {
        // Handle numbers
      } else {
        // Handle numbers
        if (_shouldResetDisplay) {
          _currentInput = "";
          _shouldResetDisplay = false;
        }

        if (_currentInput == "0") {
          _currentInput = buttonText;
        } else {
          _currentInput += buttonText;
        }
        _display = _currentInput;
      }
    });
  }

  double _calculate(double first, double second, String operator) {
    switch (operator) {
      case "+":
        return first + second;
      case "-":
        return first - second;
      case "*":
        return first * second;
      case "%":
        return first % second;
      default:
        return second;
    }
  }

  String _formatResult(double result) {
    if (result == result.truncateToDouble()) {
      return result.truncate().toString();
    } else {
      return result.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    const buttonValues = [
      ['C', '()', '%', "%"],
      ["7", "8", "9", "X"],
      ["4", "5", "6", "-"],
      ["1", "2", "3", "+"],
      ["+/-", ".", "0", "="],
    ];

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CalculatorTextInput(text: _display),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              CalculatorColumnGird(
                buttonValues: buttonValues,
                onPressed: _onButtonPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
