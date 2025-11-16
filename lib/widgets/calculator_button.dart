import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const CalculatorButton({
    required this.text,
    required this.onPressed,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10),
        foregroundColor: _getTextColor(text),
        backgroundColor: _getButtonColor(text),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      'sin',
      'cos',
      'tan',
      'asin',
      'acos',
      'atan',
      'sqrt',
      'log',
      'ln',
      'exp',
      'abs',
      'pi',
      'e',
    ].contains(text);
  }
}
