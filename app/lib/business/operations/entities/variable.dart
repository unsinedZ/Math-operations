import 'fraction.dart';
import 'package:flutter/foundation.dart';

class Variable {
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

  final String name;
  final Fraction value;

  Variable({
    @required String name,
    @required Fraction value,
  })  : this.name = _transformName(name),
        this.value = value;

  Variable changeValue(Fraction newValue) {
    return Variable(
      name: name,
      value: newValue,
    );
  }

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
}
