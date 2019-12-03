import 'package:app/business/operations/dual_simplex_adjuster.dart';
import 'package:app/business/operations/dual_simplex_method_strategy.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/simplex_table.dart';
import 'package:app/business/operations/simplex_table_context.dart';
import 'package:quiver/iterables.dart';

class DualSimplexSolver {
  List<LinearTask> getSolutionSteps(LinearTask initialTask) {
    DualSimplexAdjuster adjuster = DualSimplexAdjuster();
    var adjusted = adjuster.getAdjustionSteps(initialTask);
    SimplexTable table = _createSimplexTable(adjusted.last ?? initialTask);
    SimplexTableContext context = SimplexTableContext.create(
      simplexTable: table,
    );
    DualSimplexMethodStrategy strategy = DualSimplexMethodStrategy();
    if (!strategy.canBeApplied(context)) {
      return [
        AdjustedLinearTask.wrap(
          initialTask,
          "Can not be solved using dual simplex method",
        )
      ].toList();
    }

    return concat([
      adjusted,
    ]).toList();
  }

  SimplexTable _createSimplexTable(LinearTask task) {
    return SimplexTable(
      rows: task.restrictions.map(
        (x) => SimplexTableRow(
          coefficients: x.coefficients,
          freeMember: x.freeMember,
        ),
      ).toList(),
      estimations: SimplexTableEstimations(
        variableEstimations: task.targetFunction.coefficients,
        functionValue: task.targetFunction.freeMember,
      ),
    );
  }
}
