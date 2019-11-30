import 'package:app/business/operations/fraction.dart';
import 'package:flutter/material.dart';

class FunctionVariable extends StatelessWidget {
  final Fraction value;
  final String name;
  final VoidCallback onPressed;
  
  const FunctionVariable({
    this.value,
    this.name,
    this.onPressed
  });
  
  @override
  Widget build(BuildContext context) {
    String valueText = value == Fraction.fromNumber(1)
      ? ''
      : '$value*';
    return FlatButton(
      child: Text(valueText + name),
      onPressed: onPressed,
    );
  }
}