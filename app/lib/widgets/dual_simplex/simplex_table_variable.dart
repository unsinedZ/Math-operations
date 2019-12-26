import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/editors/variable_editor.dart';
import 'package:flutter/material.dart';

class SimplexTableVariable extends StatelessWidget {
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
          value: const Fraction.fromNumber(1),
        ),
        onChanged: null,
      ),
    );
  }
}
