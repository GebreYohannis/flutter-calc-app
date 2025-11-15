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
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(10),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(199, 0, 0, 0),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
