import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/entities/solution_status.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:app/business/operations/simplex_table/simplex_table_transformation_context.dart';

import 'base_simplex_method_strategy.dart';

class SimplexMethodStrategy implements BaseSimplexMethodStrategy {
  const SimplexMethodStrategy();

  bool canBeApplied(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null)
      throw Exception('Context can not be null.');

    if (simplexTableContext.simplexTable.rows
        .map((x) => x.freeMember)
        .any((x) => x.isNegative())) {
      return false;
    }

    return simplexTableContext.hasBasis;
  }

  SolutionStatus solve(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null)
      throw Exception('Context can not be null.');

    if (!canBeApplied(simplexTableContext))
      throw Exception('Strategy can not be applied for context.');

    List<Fraction> estimations =
        simplexTableContext.simplexTable.estimations.variableEstimations;
    if (estimations.every((x) => !x.isPositive())) {
      return SolutionStatus.hasRoot;
    }

    for (int i = 0; i < estimations.length; i++) {
      Fraction value = estimations[i];
      if (!value.isPositive()) {
        continue;
      }

      if (simplexTableContext.simplexTable.rows
          .map((x) => x[i])
          .every((x) => !x.isPositive())) return SolutionStatus.noRoots;
    }

    return SolutionStatus.undefined;
  }

  SimplexTable getNextTable(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null)
      throw Exception('Context can not be null.');

    if (!canBeApplied(simplexTableContext))
      throw Exception('Strategy can not be applied for context.');

    if (solve(simplexTableContext) != SolutionStatus.undefined)
      throw Exception('Cannot get next table. The task is solved.');

    SimplexTable table = simplexTableContext.simplexTable;
    int solvingColumnIndex = _findSolvingColumnIndex(table);
    return new SimplexTableTransformationContext(
      simplexTable: table,
      solvingRowIndex: _findSolvingRowIndex(table, solvingColumnIndex),
      solvingColumnIndex: solvingColumnIndex,
    ).transform();
  }

  int _findSolvingRowIndex(SimplexTable table, int solvingColumnIndex) {
    List<Fraction> solvingColumn = table.rows.map((x) => x[solvingColumnIndex]).toList();
    Fraction minimumQuotient;
    int minimumQuotientIndex = -1;
    for (int i = 0; i < solvingColumn.length; i++) {
      Fraction coefficient = solvingColumn[i];
      if (!coefficient.isPositive()) {
        continue;
      }

      Fraction quotient = table.rows[i].freeMember / coefficient;
      if (minimumQuotient == null || quotient < minimumQuotient) {
        minimumQuotientIndex = i;
        minimumQuotient = quotient;
      }
    }

    return minimumQuotientIndex;
  }

  int _findSolvingColumnIndex(SimplexTable table) {
    Fraction maximumEstimation = table.estimations.variableEstimations[0];
    int maximumEstimationIndex = 0;
    for (int i = 1; i < table.estimations.variableEstimations.length; i++) {
      Fraction estimation = table.estimations.variableEstimations[i];
      if (estimation > maximumEstimation) {
        maximumEstimationIndex = i;
        maximumEstimation = estimation;
      }
    }

    return maximumEstimationIndex;
  }
}
