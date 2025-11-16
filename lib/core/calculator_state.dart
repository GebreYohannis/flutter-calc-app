class CalculatorState {
  final String display;
  final String currentExpression;
  final bool shouldResetDisplay;

  const CalculatorState({
    this.display = "0",
    this.currentExpression = "",
    this.shouldResetDisplay = false,
  });

  CalculatorState copyWith({
    String? display,
    String? currentExpression,
    bool? shouldResetDisplay,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      currentExpression: currentExpression ?? this.currentExpression,
      shouldResetDisplay: shouldResetDisplay ?? this.shouldResetDisplay,
    );
  }
}

class CalculatorResponse {
  final CalculatorState state;
  final bool success;
  final String? errorMessage;

  CalculatorResponse({
    required this.state,
    this.success = true,
    this.errorMessage,
  });
}