import 'dart:math' as math;

import 'scientific_calculator_engine.dart';

class ComplexScientificCalculatorEngine extends ScientificCalculatorEngine {
  final Map<String, double> _variables = {};
  final List<double> _memory = [];

  final Map<String, Function> _advancedFunctions = {
    'rad': (List<double> args) => args[0] * (math.pi / 180),
    'deg': (List<double> args) => args[0] * (180 / math.pi),
    'fact': (List<double> args) => _factorial(args[0].toInt()),
    'hypot': (List<double> args) =>
        math.sqrt(args[0] * args[0] + args[1] * args[1]),
    'round': (List<double> args) => args[0].roundToDouble(),
    'ceil': (List<double> args) => args[0].ceilToDouble(),
    'floor': (List<double> args) => args[0].floorToDouble(),
  };

  ComplexScientificCalculatorEngine() {
    _advancedFunctions.forEach((key, value) {
      functions[key] = value;
    });
  }

  // Variable management
  void setVariable(String name, double value) {
    if (!_isValidVariableName(name)) {
      throw ArgumentError('Invalid variable name: $name');
    }
    _variables[name] = value;
  }

  double getVariable(String name) {
    if (!_variables.containsKey(name)) {
      throw ArgumentError('Undefined variable: $name');
    }
    return _variables[name]!;
  }

  // Memory operations
  void memoryStore(double value) => _memory.add(value);

  double memoryRecall() {
    if (_memory.isEmpty) throw StateError('Memory is empty');
    return _memory.last;
  }

  void memoryClear() => _memory.clear();

  double memoryAdd(double value) {
    if (_memory.isEmpty) {
      _memory.add(value);
    } else {
      _memory[_memory.length - 1] += value;
    }
    return _memory.last;
  }

  @override
  String preprocessExpression(String expression) {
    expression = super.preprocessExpression(expression);

    for (var variable in _variables.keys) {
      expression = expression.replaceAll(
        variable,
        _variables[variable]!.toString(),
      );
    }

    return expression;
  }

  // Statistical functions
  double mean(List<double> numbers) {
    if (numbers.isEmpty) throw ArgumentError('List cannot be empty');
    return numbers.reduce((a, b) => a + b) / numbers.length;
  }

  double standardDeviation(List<double> numbers) {
    if (numbers.isEmpty) throw ArgumentError('List cannot be empty');
    double meanValue = mean(numbers);
    double variance =
        numbers.map((x) => math.pow(x - meanValue, 2)).reduce((a, b) => a + b) /
        numbers.length;
    return math.sqrt(variance);
  }

  // Equation solvers
  Map<String, double> solveLinearEquation(double a, double b, double c) {
    if (a == 0) throw ArgumentError('Coefficient a cannot be zero');
    double x = (c - b) / a;
    return {'x': x};
  }

  Map<String, dynamic> solveQuadraticEquation(double a, double b, double c) {
    if (a == 0) throw ArgumentError('Coefficient a cannot be zero');

    double discriminant = b * b - 4 * a * c;

    if (discriminant > 0) {
      double x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      double x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      return {'x1': x1, 'x2': x2, 'type': 'real'};
    } else if (discriminant == 0) {
      double x = -b / (2 * a);
      return {'x': x, 'type': 'real'};
    } else {
      double realPart = -b / (2 * a);
      double imaginaryPart = math.sqrt(-discriminant) / (2 * a);
      return {
        'x1': '$realPart + ${imaginaryPart}i',
        'x2': '$realPart - ${imaginaryPart}i',
        'type': 'complex',
      };
    }
  }

  static double _factorial(int n) {
    if (n < 0) {
      throw ArgumentError('Bad Expression!');
    }
    if (n == 0 || n == 1) return 1;
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  bool _isValidVariableName(String name) {
    return RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name) &&
        !constants.containsKey(name) &&
        !functions.containsKey(name);
  }

  @override
  List<List<String>> getButtonLayout() {
    return [
      ['C', '()', '%', '/', 'sin', 'cos', 'tan'],
      ['7', '8', '9', '*', 'asin', 'acos', 'atan'],
      ['4', '5', '6', '-', 'log', 'ln', 'exp'],
      ['1', '2', '3', '+', 'sqrt', '^', 'abs'],
      ['+/-', '0', '.', '=', 'pi', 'e', '⌫'],
    ];
  }

  @override
  String getDisplayName() => 'COMPLEX SCIENTIFIC';
}
