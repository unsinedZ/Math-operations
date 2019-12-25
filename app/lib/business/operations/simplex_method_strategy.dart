import 'fraction.dart';
import 'base_simplex_method_strategy.dart';
import 'simplex_table.dart';
import 'simplex_table_context.dart';
import 'simplex_table_transformation_context.dart';
import 'solution_status.dart';

class SimplexMethodStrategy implements BaseSimplexMethodStrategy {
  const SimplexMethodStrategy();

  bool canBeApplied(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null)
      throw Exception('Context can not be null.');

    Fraction zero = const Fraction.fromNumber(0);
    if (simplexTableContext.simplexTable.rows
        .map((x) => x.freeMember)
        .any((x) => x < zero)) {
      return false;
    }

    return simplexTableContext.hasBasis;
  }

  SolutionStatus solve(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null)
      throw Exception('Context can not be null.');

    if (!canBeApplied(simplexTableContext))
      throw Exception('Strategy can not be applied for context.');

    Fraction zero = const Fraction.fromNumber(0);
    List<Fraction> estimations =
        simplexTableContext.simplexTable.estimations.variableEstimations;
    if (estimations.every((x) => x <= zero)) return SolutionStatus.hasRoot;

    for (int i = 0; i < estimations.length; i++) {
      Fraction value = estimations[i];
      if (value <= zero) {
        continue;
      }

      if (simplexTableContext.simplexTable.rows
          .map((x) => x[i])
          .every((x) => x <= zero)) return SolutionStatus.noRoots;
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
    const Fraction _0 = const Fraction.fromNumber(0);
    List<Fraction> solvingColumn = table.rows.map((x) => x[solvingColumnIndex]);
    Fraction minimumQuotient;
    int minimumQuotientIndex = -1;
    for (int i = 1; i < solvingColumn.length; i++) {
      Fraction coefficient = solvingColumn[i];
      if (coefficient <= _0) continue;

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
