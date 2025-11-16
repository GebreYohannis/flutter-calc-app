// engines/scientific_calculator_engine.dart
import 'dart:math' as math;

import 'base_calculator_engine.dart';

class ScientificCalculatorEngine extends BaseCalculatorEngine {

  final Map<String, double> constants = {'pi': math.pi, 'e': math.e};

  final Map<String, Function> functions = {
    'sin': (List<double> args) => math.sin(args[0]),
    'cos': (List<double> args) => math.cos(args[0]),
    'tan': (List<double> args) => math.tan(args[0]),
    'asin': (List<double> args) => math.asin(args[0]),
    'acos': (List<double> args) => math.acos(args[0]),
    'atan': (List<double> args) => math.atan(args[0]),
    'sqrt': (List<double> args) => math.sqrt(args[0]),
    'log': (List<double> args) => math.log(args[0]),
    'ln': (List<double> args) => math.log(args[0]),
    'exp': (List<double> args) => math.exp(args[0]),
    'abs': (List<double> args) => args[0].abs(),
    'pow': (List<double> args) => math.pow(args[0], args[1]).toDouble(),
  };

  @override
  double evaluate(String expression) {
    try {
      expression = preprocessExpression(expression);
      return super.evaluate(expression);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String handleParentheses(String expression) {
    if (expression.isEmpty) return "(";

    for (String function in functions.keys) {
      if (expression.endsWith(function)) {
        return "$expression(";
      }
    }

    return super.handleParentheses(expression);
  }

  String preprocessExpression(String expression) {
    for (String constant in constants.keys) {
      expression = expression.replaceAll(
        constant,
        constants[constant]!.toString(),
      );
    }

    for (String function in functions.keys) {
      expression = _replaceFunctionCalls(expression, function);
    }
    return expression;
  }

  String _replaceFunctionCalls(String expression, String functionName) {
    final pattern = RegExp('$functionName\\s*\\(([^()]+)\\)');

    while (expression.contains(pattern)) {
      expression = expression.replaceAllMapped(pattern, (match) {
        String args = match.group(1)!;
        double result;
        try {
          result = super.evaluate(args);
        } catch (e) {
          result = evaluate(args);
        }
        return _applyFunction(functionName, [result]).toString();
      });
    }
    return expression;
  }

  double _applyFunction(String functionName, List<double> args) {
    if (!functions.containsKey(functionName)) {
      throw ArgumentError('Unknown function: $functionName');
    }
    final function = functions[functionName]!;
    return function(args);
  }

  @override
  List<List<String>> getButtonLayout() {
    return [
      ['C', '()', '%', '/', 'sin', 'cos'],
      ['7', '8', '9', '*', 'tan', '√'],
      ['4', '5', '6', '-', 'log', '^'],
      ['1', '2', '3', '+', 'ln', 'pi'],
      ['+/-', '0', '.', '=', 'e', '⌫'],
    ];
  }

  @override
  String getDisplayName() => 'SCIENTIFIC CALCULATOR';
}