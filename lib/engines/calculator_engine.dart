
abstract interface class CalculatorEngine {
  double evaluate(String expression);
  String formatResult(double result);
  bool isValidExpression(String expression);
  String handleBackspace(String expression);
  String handleParentheses(String expression);
  String appendToExpression(
    String currentExpression,
    String value,
    bool shouldReset,
  );
  String toggleSign(String expression);
  List<List<String>> getButtonLayout();
  String getDisplayName();
}