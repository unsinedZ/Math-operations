import 'package:app/business/operations/fraction.dart';
import 'package:flutter/material.dart';

class FunctionVariable extends StatelessWidget {
  static final Map<String, String> _subScript = {
    '0': '₀',
    '1': '₁',
    '2': '₂',
    '3': '₃',
    '4': '₄',
    '5': '₅',
    '6': '₆',
    '7': '₇',
    '8': '₈',
    '9': '₉',
  };

  final Fraction _value;
  final String _name;
  final VoidCallback _onPressed;

  FunctionVariable(
      {@required Fraction value,
      @required String name,
      @required VoidCallback onPressed})
      : this._value = value,
        this._name = _transformName(name),
        this._onPressed = onPressed;

  static String _transformName(String name) {
    StringBuffer sb = new StringBuffer();
    name.runes.forEach((int rune) {
      String char = String.fromCharCode(rune);
      if (_subScript.containsKey(char))
        sb.write(_subScript[char]);
      else
        sb.write(char);
    });

    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    String valueText = _value == Fraction.fromNumber(1) ? '' : '$_value*';
    return FlatButton(
      child: Text(valueText + _name),
      onPressed: _onPressed,
    );
  }
}
