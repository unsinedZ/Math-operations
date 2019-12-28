import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/widgets/primitives/base_button.dart';
import 'package:flutter/material.dart';

class VariableInfo extends StatelessWidget {
  final Fraction value;
  final String name;
  final VoidCallback onPressed;

  VariableInfo({
    Key key,
    @required this.name,
    @required this.value,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String valueText = name.isNotEmpty && value.equalsNumber(1) ? '' : '${value.toString()}';
    return BaseButton(
      text: valueText + name,
      onPressed: onPressed,
    );
  }
}
