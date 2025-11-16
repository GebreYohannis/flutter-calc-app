import "package:flutter/material.dart";
import "package:calculator/config/calculator_config.dart";
import "package:calculator/core/calculator_controller.dart";
import "package:calculator/core/engine_registry.dart";
import 'package:calculator/widgets/calculator_text_input.dart';
import "package:calculator/widgets/calculator_column_view.dart";

class CalculatorScreen extends StatefulWidget {
  final CalculatorController? controller;
  final CalculatorEngineRegistry? registry;
  const CalculatorScreen({super.key, this.controller, this.registry});

  @override
  State<StatefulWidget> createState() => _CalculatorScreenState();
  
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late CalculatorController _controller;
  late CalculatorEngineRegistry _registry;
  @override
  void initState() {
    super.initState();
    _registry = CalculatorConfig.initializeRegistry();
    _controller =
        widget.controller ?? CalculatorConfig.createDefaultController();
  }

  void _onButtonPressed(String buttonText) {
    final response = _controller.handleButtonPress(buttonText);
    if (!response.success) {
      // do something ...
    }
    setState(() {});
  }

  void _switchMode(CalculatorMode mode) {
    final newEngine = _registry.getEngine(mode);
    _controller.switchEngine(newEngine);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.getDisplayName()),
        actions: [
          PopupMenuButton<CalculatorMode>(
            onSelected: _switchMode,
            itemBuilder: (BuildContext context) => _buildModeMenuItems(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CalculatorTextInput(text: state.display),
            Text(
              state.currentExpression,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.right,
            ),
            Expanded(
              child: CalculatorColumnView(
                buttonValues: _controller.getButtonLayout(),
                onPressed: _onButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<CalculatorMode>> _buildModeMenuItems() {
    return _registry.availableModes
        .map(
          (mode) => PopupMenuItem<CalculatorMode>(
            value: mode,
            child: Text(_registry.getEngine(mode).getDisplayName()),
          ),
        )
        .toList();
  }
}
