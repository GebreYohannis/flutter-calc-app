import 'base_calculator_engine.dart';

class SimpleCalculatorEngine extends BaseCalculatorEngine {
  @override
  List<List<String>> getButtonLayout() {
    return [
      ['C', '()', '%', '/'],
      ['7', '8', '9', '*'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['+/-', '0', '.', '='],
    ];
  }

  @override
  String getDisplayName() => 'BASIC CALCULATOR';
}
