import "../engines.dart";
import "../core/calculator_controller.dart";

class CalculatorConfig {
  static CalculatorEngineRegistry initializeRegistry() {
    final registry = CalculatorEngineRegistry();

    // Register default engines
    registry.registerEngine(CalculatorMode.basic, SimpleCalculatorEngine());
    registry.registerEngine(
      CalculatorMode.scientific,
      ScientificCalculatorEngine(),
    );
    registry.registerEngine(
      CalculatorMode.complex,
      ComplexScientificCalculatorEngine(),
    );

    return registry;
  }

  static CalculatorController createDefaultController() {
    final registry = initializeRegistry();
    return CalculatorController(registry.getEngine(CalculatorMode.basic));
  }
}
