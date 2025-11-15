import 'dart:math' as math;

class SimpleCalculatorEngine {
  final Map<String, int> _precedence = {"+": 1, "-": 1, "*": 2, "/": 2};

  double evaluate(String expression) {
    List<String> tokens = _tokenize(expression);
    List<String> postfix = _infixToPostfix(tokens);
    return _evaluatePostfix(postfix);
  }

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
        stack.removeLast(); // Remove "("
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
      default:
        throw ArgumentError("Unknown operator: $op");
    }
  }

  bool _isDigit(String char) =>
      char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
  bool _isNumber(String token) => double.tryParse(token) != null;
  bool _isOperator(String token) => _precedence.containsKey(token);
}

class ScientificCalculatorEngine extends SimpleCalculatorEngine {
  static const Map<String, int> _scientificPrecedence = {
    '+': 1,
    '-': 1,
    '*': 2,
    '/': 2,
    '%': 2,
    '^': 3,
  };

  final Map<String, double> _constants = {'pi': math.pi, 'e': math.e};

  final Map<String, Function> _functions = {
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
      expression = _preprocessExpression(expression);
      return super.evaluate(expression);
    } catch (e) {
      rethrow;
    }
  }

  String _preprocessExpression(String expression) {
    // Replace constants with their values
    for (String constant in _constants.keys) {
      expression = expression.replaceAll(
        constant,
        _constants[constant]!.toString(),
      );
    }

    // Process function calls
    for (String function in _functions.keys) {
      expression = _replaceFunctionCalls(expression, function);
    }
    return expression;
  }

  String _replaceFunctionCalls(String expression, String functionName) {
    final pattern = RegExp('$functionName\\s*\\(([^()]+)\\)');

    while (expression.contains(pattern)) {
      expression = expression.replaceAllMapped(pattern, (match) {
        String args = match.group(1)!;
        // Evaluate arguments first using simple expression
        double result;
        try {
          result = super.evaluate(args);
        } catch (e) {
          // If evaluation fails, try with function processing
          result = evaluate(args);
        }
        return _applyFunction(functionName, [result]).toString();
      });
    }
    return expression;
  }

  double _applyFunction(String functionName, List<double> args) {
    if (!_functions.containsKey(functionName)) {
      throw ArgumentError('Unknown function: $functionName');
    }
    final function = _functions[functionName]!;
    return function(args);
  }

  @override
  double _applyOperator(double a, double b, String op) {
    switch (op) {
      case '^':
        return math.pow(a, b).toDouble();
      case '%':
        return a % b;
      default:
        return super._applyOperator(a, b, op);
    }
  }

  @override
  bool _isOperator(String token) {
    return _scientificPrecedence.containsKey(token) || super._isOperator(token);
  }
}

class ComplexScientificCalculatorEngine extends ScientificCalculatorEngine {
  final Map<String, double> _variables = {};
  final List<double> _memory = [];

  // Additional scientific functions
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
    // Merge advanced functions with parent functions
    _advancedFunctions.forEach((key, value) {
      _functions[key] = value;
    });
  }

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

  void memoryStore(double value) {
    _memory.add(value);
  }

  double memoryRecall() {
    if (_memory.isEmpty) throw StateError('Memory is empty');
    return _memory.last;
  }

  void memoryClear() {
    _memory.clear();
  }

  double memoryAdd(double value) {
    if (_memory.isEmpty) {
      _memory.add(value);
    } else {
      _memory[_memory.length - 1] += value;
    }
    return _memory.last;
  }

  @override
  String _preprocessExpression(String expression) {
    expression = super._preprocessExpression(expression);

    // Replace variables
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

  // Equation solver (linear)
  Map<String, double> solveLinearEquation(double a, double b, double c) {
    // ax + b = c
    if (a == 0) throw ArgumentError('Coefficient a cannot be zero');
    double x = (c - b) / a;
    return {'x': x};
  }

  // Quadratic equation solver
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
      throw ArgumentError('Factorial not defined for negative numbers');
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
        !_constants.containsKey(name) &&
        !_functions.containsKey(name);
  }
}
