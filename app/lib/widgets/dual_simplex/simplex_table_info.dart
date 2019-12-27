import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:flutter/material.dart';

import 'comment_info.dart';
import 'simplex_table_row_builder.dart';
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
    AdjustedSimplexTable adjustedTable = simplexTable is AdjustedSimplexTable
        ? simplexTable as AdjustedSimplexTable
        : null;
    String comment = adjustedTable?.comment;
    int index = 0;
    return Column(
      children: <Widget>[
        SingleChildScrollView(
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
                  return SimplexTableRowBuilder(
                    basisVariableName:
                        '$variableLetter${simplexTableContext.basisVariableIndices[index++] + 1}',
                    coefficients: x.coefficients,
                    freeMember: x.freeMember,
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
        ),
        CommentInfo(
          comment: comment,
        ),
      ],
    );
  }
}
