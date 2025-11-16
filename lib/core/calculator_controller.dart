import "calculator_state.dart";
import "../engines.dart";

class CalculatorController {
  CalculatorEngine _engine;
  CalculatorState _state;

  CalculatorController(this._engine) : _state = const CalculatorState();

  CalculatorEngine get engine => _engine;
  CalculatorState get state => _state;

  void switchEngine(CalculatorEngine newEngine) {
    _engine = newEngine;
    _state = const CalculatorState();
  }

  CalculatorResponse handleButtonPress(String buttonText) {
    try {
      CalculatorState newState = _state;

      switch (buttonText) {
        case "C":
          newState = const CalculatorState();
          break;
        case "=":
          if (_state.currentExpression.isNotEmpty) {
            double result = _engine.evaluate(_state.currentExpression);
            String formattedResult = _engine.formatResult(result);
            newState = CalculatorState(
              display: formattedResult,
              currentExpression: formattedResult,
              shouldResetDisplay: true,
            );
          }
          break;
        case "⌫":
          String newExpression = _engine.handleBackspace(
            _state.currentExpression,
          );
          newState = _state.copyWith(
            currentExpression: newExpression,
            display: newExpression.isEmpty ? "0" : newExpression,
          );
          break;
        case "+/-":
          String toggledExpression = _engine.toggleSign(
            _state.currentExpression,
          );
          newState = _state.copyWith(
            currentExpression: toggledExpression,
            display: toggledExpression,
          );
          break;
        case "()":
          String newExpression = _engine.handleParentheses(
            _state.currentExpression,
          );
          newState = _state.copyWith(
            currentExpression: newExpression,
            display: newExpression,
          );
          break;
        default:
          String newExpression = _engine.appendToExpression(
            _state.currentExpression,
            buttonText,
            _state.shouldResetDisplay,
          );
          newState = _state.copyWith(
            currentExpression: newExpression,
            display: newExpression,
            shouldResetDisplay: false,
          );
          break;
      }

      _state = newState;
      return CalculatorResponse(state: newState);
    } catch (e) {
      final errorState = const CalculatorState(display: "Error");
      _state = errorState;
      return CalculatorResponse(
        state: errorState,
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  List<List<String>> getButtonLayout() {
    return _engine.getButtonLayout();
  }

  String getDisplayName() {
    return _engine.getDisplayName();
  }
}
