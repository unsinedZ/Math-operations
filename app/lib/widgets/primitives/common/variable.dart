import 'package:app/business/operations/fraction.dart';
import 'base_button.dart';
import 'package:flutter/material.dart';

class Variable extends StatelessWidget {
  final Fraction _value;
  final String _name;
  final VoidCallback _onPressed;

  Variable({
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
    return BaseButton(
      text: valueText + _name,
      onPressed: _onPressed,
    );
  }
}
