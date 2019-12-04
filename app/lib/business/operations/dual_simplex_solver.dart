import 'package:app/business/operations/dual_simplex_method_strategy.dart';
import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/simplex_table.dart';
import 'package:app/business/operations/simplex_table_context.dart';

class DualSimplexSolver {
  List<SimplexTable> getSolutionSteps(LinearTask adjustedTask) {
    SimplexTable table = _createSimplexTable(adjustedTask);
    SimplexTableContext context = SimplexTableContext.create(
      simplexTable: table,
    );
    DualSimplexMethodStrategy strategy = DualSimplexMethodStrategy();
    if (!strategy.canBeApplied(context)) {
      return [
        AdjustedSimplexTable.wrap(
          table,
          "Can not be solved using dual simplex method",
        )
      ].toList();
    }

    return [
      table,
    ].toList();
  }

  SimplexTable _createSimplexTable(LinearTask task) {
    return SimplexTable(
      rows: task.restrictions
          .map(
            (x) => SimplexTableRow(
              coefficients: x.coefficients,
              freeMember: x.freeMember,
            ),
          )
          .toList(),
      estimations: SimplexTableEstimations(
        variableEstimations: task.targetFunction.coefficients
            .map(
              (x) => x * Fraction.fromNumber(-1),
            )
            .toList(),
        functionValue: task.targetFunction.freeMember,
      ),
    );
  }
}
