// core/engine_registry.dart
import '../engines/calculator_engine.dart';
import '../engines/simple_calculator_engine.dart';
import '../engines/scientific_calculator_engine.dart';
import '../engines/complex_scientific_calculator_engine.dart';

enum CalculatorMode { basic, scientific, complex }

class CalculatorEngineRegistry {
  final Map<CalculatorMode, CalculatorEngine> _engines = {};
  final Map<String, CalculatorEngine> _customEngines = {};

  CalculatorEngineRegistry() {
    _registerDefaultEngines();
  }

  void _registerDefaultEngines() {
    registerEngine(CalculatorMode.basic, SimpleCalculatorEngine());
    registerEngine(CalculatorMode.scientific, ScientificCalculatorEngine());
    registerEngine(CalculatorMode.complex, ComplexScientificCalculatorEngine());
  }

  void registerEngine(CalculatorMode mode, CalculatorEngine engine) {
    _engines[mode] = engine;
  }

  void registerCustomEngine(String name, CalculatorEngine engine) {
    _customEngines[name] = engine;
  }

  CalculatorEngine getEngine(CalculatorMode mode) {
    if (!_engines.containsKey(mode)) {
      throw ArgumentError('No engine registered for mode: $mode');
    }
    return _engines[mode]!;
  }

  CalculatorEngine? getCustomEngine(String name) {
    return _customEngines[name];
  }

  List<CalculatorMode> get availableModes => _engines.keys.toList();
  List<String> get availableCustomEngines => _customEngines.keys.toList();
}
