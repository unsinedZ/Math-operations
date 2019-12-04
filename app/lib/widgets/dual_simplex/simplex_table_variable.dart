import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/editors/variable_editor.dart';
import 'package:flutter/material.dart';

class SimplexTableVariable extends StatelessWidget {
  static const Fraction _1 = const Fraction.fromNumber(1);

  final String name;

  const SimplexTableVariable({
    Key key,
    @required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: VariableEditor(
        variable: Variable(
          name: name,
          value: _1,
        ),
        onChanged: null,
      ),
    );
  }
}
