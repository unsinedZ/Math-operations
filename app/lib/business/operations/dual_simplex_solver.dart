import 'package:app/business/operations/dual_simplex_method_strategy.dart';
import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/simplex_table.dart';
import 'package:app/business/operations/simplex_table_context.dart';
import 'package:app/business/operations/solution_info.dart';

class DualSimplexSolver {
  static const DualSimplexMethodStrategy _Strategy =
      const DualSimplexMethodStrategy();

  List<SimplexTable> getSolutionSteps(LinearTask adjustedTask) {
    SimplexTable table = _createSimplexTable(adjustedTask);
    SimplexTableContext context = SimplexTableContext.create(
      simplexTable: table,
    );
    if (!_Strategy.canBeApplied(context)) {
      return [
        AdjustedSimplexTable.wrap(
          table,
          "Can not be solved using dual simplex method",
        )
      ].toList();
    }

    return _generateSolutionSteps(context).toList();
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

  Iterable<SimplexTable> _generateSolutionSteps(
    SimplexTableContext initialContext,
  ) sync* {
    while (true) {
      SolutionInfo info = _Strategy.solve(initialContext);
      SimplexTable table = AdjustedSimplexTable.wrap(
        initialContext.simplexTable,
        _getSolutionMessage(info),
      );

      yield table;

      if (info != SolutionInfo.undefined) {
        break;
      }

      initialContext = SimplexTableContext.create(
        simplexTable: _Strategy.getNextTable(initialContext),
      );
    }
  }

  String _getSolutionMessage(SolutionInfo info) {
    switch (info) {
      case SolutionInfo.hasRoot:
        return 'Found optimal solution';
      case SolutionInfo.noRoots:
        return 'Multiplicity of available solutions is empty';
      case SolutionInfo.undefined:
        return 'Solution is not optimal';
      default:
        throw Exception('Not supported');
    }
  }
}
