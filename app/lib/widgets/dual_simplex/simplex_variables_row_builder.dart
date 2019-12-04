import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/editors/variable_editor.dart';
import 'package:flutter/material.dart';

import 'empty_table_cell.dart';

class SimplexVariablesRowBuilder {
  static const Fraction _1 = const Fraction.fromNumber(1);

  final int variablesCount;
  final String variableLetter;

  const SimplexVariablesRowBuilder({
    @required this.variablesCount,
    @required this.variableLetter,
  });

  TableRow build() {
    int index = 0;
    return TableRow(
      children: [
        EmptyTableCell(),
        ...List.filled(variablesCount, null).map(
          (x) => TableCell(
            child: VariableEditor(
              variable: Variable(
                name: '$variableLetter${++index}',
                value: _1,
              ),
              onChanged: null,
            ),
          ),
        ),
        EmptyTableCell(),
      ],
    );
  }
}
