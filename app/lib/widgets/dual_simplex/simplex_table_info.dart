import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/simplex_table.dart';
import 'package:app/business/operations/simplex_table_context.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/editors/variable_editor.dart';
import 'package:flutter/material.dart';

import 'simplex_table_row_builder.dart';
import 'simplex_table_value.dart';
import 'simplex_variables_row_builder.dart';

class SimplexTableInfo extends StatelessWidget {
  final TargetFunction targetFunction;
  final SimplexTableContext simplexTableContext;

  SimplexTable get simplexTable => simplexTableContext.simplexTable;
  String get variableLetter => targetFunction.variableLetter;

  const SimplexTableInfo({
    Key key,
    @required this.targetFunction,
    @required this.simplexTableContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(
          width: 1,
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        defaultColumnWidth: IntrinsicColumnWidth(
          flex: 1,
        ),
        children: [
          SimplexVariablesRowBuilder(
            variableLetter: targetFunction.variableLetter,
            variablesCount: targetFunction.coefficients.length,
          ).build(),
          ...simplexTable.rows.map(
            (x) {
              SimplexTableRow row = simplexTable.rows[index];
              return SimplexTableRowBuilder(
                basisVariableName:
                    '$variableLetter${simplexTableContext.basisVariableIndices[index++]}',
                coefficients: row.coefficients,
                freeMember: row.freeMember,
              ).build();
            },
          ),
          SimplexTableRowBuilder(
            basisVariableName: targetFunction.functionLetter,
            coefficients: simplexTable.estimations.variableEstimations,
            freeMember: simplexTable.estimations.functionValue,
          ).build(),
        ],
      ),
    );
  }
}
