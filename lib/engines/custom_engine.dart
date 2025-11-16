
import 'package:calculator/engines.dart';

class CustomCalculatorEngine extends BaseCalculatorEngine {
  @override
  double evaluate(String expression) {
    // Custom evaluation logic
    return 42.0; // Always the answer!
  }

  @override
  List<List<String>> getButtonLayout() {
    return [
      ['C', '7', '8', '9'],
      ['4', '5', '6', '='],
    ];
  }

  @override
  String getDisplayName() => 'CUSTOM ENGINE';
}