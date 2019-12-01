import 'package:app/business/operations/fraction.dart';
import 'package:app/widgets/primitives/function_button.dart';
import 'package:flutter/material.dart';

class FunctionVariable extends StatelessWidget {
  final Fraction _value;
  final String _name;
  final VoidCallback _onPressed;

  FunctionVariable({
    Key key,
    @required String name,
    @required Fraction value,
    @required VoidCallback onPressed,
  })  : this._value = value,
        this._name = name,
        this._onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String valueText = _value == Fraction.fromNumber(1) ? '' : '$_value*';
    return FunctionButton(
      text: valueText + _name,
      onPressed: _onPressed,
    );
  }
}
