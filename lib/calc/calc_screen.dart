import "package:flutter/material.dart";
import 'package:calculator/calc/calc_grid.dart';
import 'package:calculator/parsers/calculator_engine.dart';

class CalculatorScreen extends StatefulWidget {
  final CalculatorMode mode;

  const CalculatorScreen({super.key, this.mode = CalculatorMode.basic});

  @override
  State<StatefulWidget> createState() {
    return _CalculatorScreenState();
  }
}

enum CalculatorMode { basic, scientific, complex }

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = "0";
  String _currentExpression = "";
  bool _shouldResetDisplay = false;
  late dynamic _calculatorEngine;
  CalculatorMode _currentMode = CalculatorMode.basic;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _initializeEngine();
  }

  void _initializeEngine() {
    switch (_currentMode) {
      case CalculatorMode.basic:
        _calculatorEngine = SimpleCalculatorEngine();
        break;
      case CalculatorMode.scientific:
        _calculatorEngine = ScientificCalculatorEngine();
        break;
      case CalculatorMode.complex:
        _calculatorEngine = ComplexScientificCalculatorEngine();
        break;
    }
  }

  void _switchMode(CalculatorMode newMode) {
    setState(() {
      _currentMode = newMode;
      _initializeEngine();
      _display = "0";
      _currentExpression = "";
      _shouldResetDisplay = false;
    });
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        // Clear everything
        _display = "0";
        _currentExpression = "";
        _shouldResetDisplay = false;
      } else if (buttonText == "=") {
        // Perform calculation using the engine
        if (_currentExpression.isNotEmpty) {
          try {
            double result = _calculatorEngine.evaluate(_currentExpression);
            _display = _formatResult(result);
            _currentExpression = _display;
            _shouldResetDisplay = true;
          } catch (e) {
            _display = "Error";
            _currentExpression = "";
          }
        }
      } else if (buttonText == "⌫") {
        // Backspace
        if (_currentExpression.isNotEmpty) {
          _currentExpression = _currentExpression.substring(
            0,
            _currentExpression.length - 1,
          );
          _display = _currentExpression.isEmpty ? "0" : _currentExpression;
        }
      } else if (["+", "-", "*", "/", "%", "^"].contains(buttonText)) {
        // Handle operators
        _appendToExpression(buttonText);
      } else if (buttonText == "+/-") {
        // Toggle positive/negative
        if (_currentExpression.isNotEmpty) {
          try {
            double result = _calculatorEngine.evaluate(_currentExpression);
            result = -result;
            _currentExpression = result.toString();
            _display = _currentExpression;
          } catch (e) {
            _display = "Error";
          }
        }
      } else if (buttonText == ".") {
        // Handle decimal point
        _appendToExpression(buttonText);
      } else if (buttonText == "()") {
        // Handle parentheses
        _handleParentheses();
      } else {
        // Handle numbers and other inputs
        _appendToExpression(buttonText);
      }
    });
  }

  void _appendToExpression(String value) {
    if (_shouldResetDisplay) {
      _currentExpression = "";
      _shouldResetDisplay = false;
    }

    if (_currentExpression == "0" && value != ".") {
      _currentExpression = value;
    } else {
      _currentExpression += value;
    }
    _display = _currentExpression;
  }

  void _handleParentheses() {
    if (_shouldResetDisplay) {
      _currentExpression = "";
      _shouldResetDisplay = false;
    }

    // Simple parentheses handling - you can make this smarter
    if (_currentExpression.isEmpty ||
        _currentExpression.endsWith("(") ||
        _isOperator(_currentExpression[_currentExpression.length - 1])) {
      _currentExpression += "(";
    } else {
      // Count open parentheses to decide whether to add open or close
      int openCount = "(".allMatches(_currentExpression).length;
      int closeCount = ")".allMatches(_currentExpression).length;

      if (openCount > closeCount) {
        _currentExpression += ")";
      } else {
        _currentExpression += "(";
      }
    }
    _display = _currentExpression;
  }

  bool _isOperator(String char) {
    return ["+", "-", "*", "/", "%", "^"].contains(char);
  }

  String _formatResult(double result) {
    if (result == result.truncateToDouble()) {
      return result.truncate().toString();
    } else {
      // Format to avoid floating point precision issues
      String formatted = result.toStringAsFixed(8);
      // Remove trailing zeros and decimal point if needed
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      return formatted;
    }
  }

  List<List<String>> _getButtonLayout() {
    switch (_currentMode) {
      case CalculatorMode.basic:
        return [
          ['C', '()', '%', '/'],
          ['7', '8', '9', '*'],
          ['4', '5', '6', '-'],
          ['1', '2', '3', '+'],
          ['+/-', '0', '.', '='],
        ];
      case CalculatorMode.scientific:
        return [
          ['C', '()', '%', '/', 'sin', 'cos'],
          ['7', '8', '9', '*', 'tan', '√'],
          ['4', '5', '6', '-', 'log', '^'],
          ['1', '2', '3', '+', 'ln', 'pi'],
          ['+/-', '0', '.', '=', 'e', '⌫'],
        ];
      case CalculatorMode.complex:
        return [
          ['C', '()', '%', '/', 'sin', 'cos', 'tan'],
          ['7', '8', '9', '*', 'asin', 'acos', 'atan'],
          ['4', '5', '6', '-', 'log', 'ln', 'exp'],
          ['1', '2', '3', '+', 'sqrt', '^', 'abs'],
          ['+/-', '0', '.', '=', 'pi', 'e', '⌫'],
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_currentMode.toString().split('.').last.toUpperCase()} Calculator',
        ),
        actions: [
          PopupMenuButton<CalculatorMode>(
            onSelected: _switchMode,
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<CalculatorMode>>[
                  const PopupMenuItem<CalculatorMode>(
                    value: CalculatorMode.basic,
                    child: Text('Basic Calculator'),
                  ),
                  const PopupMenuItem<CalculatorMode>(
                    value: CalculatorMode.scientific,
                    child: Text('Scientific Calculator'),
                  ),
                  const PopupMenuItem<CalculatorMode>(
                    value: CalculatorMode.complex,
                    child: Text('Complex Scientific'),
                  ),
                ],
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Display
            CalculatorTextInput(text: _display),
            const SizedBox(height: 20),

            // Expression preview
            Text(
              _currentExpression,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),

            // Buttons
            Expanded(
              child: CalculatorColumnGird(
                buttonValues: _getButtonLayout(),
                onPressed: _onButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
