import 'dart:math' as math;
import 'calculator_engine.dart';

abstract class BaseCalculatorEngine implements CalculatorEngine {
  final Map<String, int> _precedence = {
    '+': 1,
    '-': 1,
    '*': 2,
    '/': 2,
    '%': 2,
    '^': 3,
  };

  @override
  String formatResult(double result) {
    if (result == result.truncateToDouble()) {
      return result.truncate().toString();
    } else {
      String formatted = result.toStringAsFixed(8);
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      return formatted;
    }
  }

  @override
  bool isValidExpression(String expression) {
    if (expression.isEmpty) return false;
    try {
      evaluate(expression);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  String handleBackspace(String expression) {
    if (expression.isNotEmpty) {
      return expression.substring(0, expression.length - 1);
    }
    return "";
  }

  @override
  String handleParentheses(String expression) {
    if (expression.isEmpty ||
        expression.endsWith("(") ||
        _isOperator(expression[expression.length - 1])) {
      return "$expression(";
    } else {
      int openCount = "(".allMatches(expression).length;
      int closeCount = ")".allMatches(expression).length;

      if (openCount > closeCount) {
        return "$expression)";
      } else {
        return "$expression(";
      }
    }
  }

  @override
  String appendToExpression(
    String currentExpression,
    String value,
    bool shouldReset,
  ) {
    if (shouldReset) {
      currentExpression = "";
    }

    if (currentExpression == "0" && value != ".") {
      return value;
    } else {
      return currentExpression + value;
    }
  }

  @override
  String toggleSign(String expression) {
    if (expression.isNotEmpty) {
      try {
        double result = evaluate(expression);
        result = -result;
        return result.toString();
      } catch (e) {
        throw ArgumentError("Cannot toggle sign of invalid expression");
      }
    }
    return expression;
  }

  @override
  double evaluate(String expression) {
    List<String> tokens = _tokenize(expression);
    List<String> postfix = _infixToPostfix(tokens);
    return _evaluatePostfix(postfix);
  }

  // Tokenization and parsing methods
  List<String> _tokenize(String expression) {
    expression = expression.replaceAll(" ", "");
    List<String> tokens = [];
    StringBuffer numberBuffer = StringBuffer();

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (_isDigit(char) || char == ".") {
        numberBuffer.write(char);
      } else {
        if (numberBuffer.isNotEmpty) {
          tokens.add(numberBuffer.toString());
          numberBuffer.clear();
        }
        tokens.add(char);
      }
    }
    if (numberBuffer.isNotEmpty) {
      tokens.add(numberBuffer.toString());
    }
    return tokens;
  }

  List<String> _infixToPostfix(List<String> tokens) {
    List<String> output = [];
    List<String> stack = [];
    for (String token in tokens) {
      if (_isNumber(token)) {
        output.add(token);
      } else if (token == "(") {
        stack.add(token);
      } else if (token == ")") {
        while (stack.isNotEmpty && stack.last != "(") {
          output.add(stack.removeLast());
        }
        if (stack.isEmpty || stack.last != "(") {
          throw FormatException("Mismatched parentheses");
        }
        stack.removeLast();
      } else if (_isOperator(token)) {
        while (stack.isNotEmpty &&
            _isOperator(stack.last) &&
            _precedence[token]! <= _precedence[stack.last]!) {
          output.add(stack.removeLast());
        }
        stack.add(token);
      }
    }
    while (stack.isNotEmpty) {
      output.add(stack.removeLast());
    }
    return output;
  }

  double _evaluatePostfix(List<String> postfix) {
    List<double> stack = [];
    for (String token in postfix) {
      if (_isNumber(token)) {
        stack.add(double.parse(token));
      } else if (_isOperator(token)) {
        if (stack.length < 2) throw FormatException("Invalid expression");
        double b = stack.removeLast();
        double a = stack.removeLast();
        stack.add(_applyOperator(a, b, token));
      }
    }
    if (stack.length != 1) throw FormatException("Invalid expression");
    return stack.first;
  }

  double _applyOperator(double a, double b, String op) {
    switch (op) {
      case "+":
        return a + b;
      case "-":
        return a - b;
      case "*":
        return a * b;
      case "/":
        if (b == 0) throw ArgumentError("Division by zero");
        return a / b;
      case '^':
        return math.pow(a, b).toDouble();
      case '%':
        return a % b;
      default:
        throw ArgumentError("Unknown operator: $op");
    }
  }

  // Utility methods
  bool _isDigit(String char) =>
      char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;

  bool _isNumber(String token) => double.tryParse(token) != null;

  bool _isOperator(String char) {
    return ["+", "-", "*", "/", "%", "^"].contains(char);
  }
}
