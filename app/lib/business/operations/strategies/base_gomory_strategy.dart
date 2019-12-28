import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/entities/solution_status.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:app/business/operations/strategies/base_clipping_method_strategy.dart';
import 'package:flutter/foundation.dart';

abstract class BaseGomoriStrategy extends BaseClippingMethodStrategy {
  const BaseGomoriStrategy();

  @override
  SimplexTableContext addClipping(SimplexTableContext context) {
    if (solve(context) != SolutionStatus.undefined) {
      throw Exception('Cannot add clipping. The task is solved.');
    }

    var solvingRow = findSolvingRow(context);
    var clipping = createClippingRow(solvingRow);
    var newRows = context.simplexTable.rows
        .map(
          (x) => x.changeCoefficients(
            List.from(x.coefficients)
              ..add(
                Fraction.fromNumber(0),
              ),
          ),
        )
        .toList()
          ..add(clipping);

    var estimationsAsRow = context.simplexTable.estimations.toRow();
    var newEstimations = SimplexTableEstimations.fromRow(
      estimationsAsRow.changeCoefficients(
        List.from(estimationsAsRow.coefficients)
          ..add(
            Fraction.fromNumber(0),
          ),
      ),
    );
    return SimplexTableContext.create(
      integerVariableIndices: context.integerVariableIndices,
      simplexTable: context.simplexTable
          .changeEstimations(newEstimations)
          .changeRows(newRows),
    );
  }

  @protected
  SimplexTableRow findSolvingRow(SimplexTableContext context);

  @protected
  SimplexTableRow createClippingRow(SimplexTableRow solvingRow);
}
