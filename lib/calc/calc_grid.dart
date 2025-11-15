import 'package:flutter/material.dart';

class CalculatorColumnGird extends StatelessWidget {
  final List<List<String>> buttonValues;
  final Function(String) onPressed;

  const CalculatorColumnGird({
    super.key,
    required this.buttonValues,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buttonValues.map((row) {
        return Expanded(
          child: Row(
            children: row.map((buttonText) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CalculatorButton(
                    text: buttonText,
                    onPressed: () => onPressed(buttonText),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getButtonColor(text),
        foregroundColor: _getTextColor(text),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: _getFontSize(text),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getButtonColor(String text) {
    if (text == "=") return Colors.orange;
    if (["C", "⌫"].contains(text)) return Colors.red;
    if (_isOperator(text)) return Colors.blue.shade200;
    if (_isFunction(text)) return Colors.green.shade200;
    return Colors.grey.shade300;
  }

  Color _getTextColor(String text) {
    if (text == "=") return Colors.white;
    if (["C", "⌫"].contains(text)) return Colors.white;
    return Colors.black;
  }

  double _getFontSize(String text) {
    if (text.length > 3) return 14;
    return 18;
  }

  bool _isOperator(String text) {
    return ["+", "-", "*", "/", "%", "^", "="].contains(text);
  }

  bool _isFunction(String text) {
    return [
      'sin', 'cos', 'tan', 'asin', 'acos', 'atan', 
      'sqrt', 'log', 'ln', 'exp', 'abs', 'pi', 'e'
    ].contains(text);
  }
}

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
