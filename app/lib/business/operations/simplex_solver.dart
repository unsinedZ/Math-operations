import 'base_simplex_table_solver.dart';
import 'entities/simplex_table.dart';
import 'entities/solution_status.dart';
import 'simplex_table/simplex_table_context.dart';
import 'strategies/base_simplex_method_strategy.dart';

class SimplexSolver implements BaseSimplexTableSolver {
  final BaseSimplexMethodStrategy strategy;

  const SimplexSolver(this.strategy);

  List<SimplexTable> getSolutionSteps(SimplexTable table) {
    SimplexTableContext context = SimplexTableContext.create(
      simplexTable: table,
    );
    if (!strategy.canBeApplied(context)) {
      return [
        AdjustedSimplexTable.wrap(
          table,
          "Can not be solved using dual simplex method",
          SolutionStatus.undefined,
        )
      ].toList();
    }

    return _generateSolutionSteps(context).toList();
  }

  Iterable<SimplexTable> _generateSolutionSteps(
    SimplexTableContext initialContext,
  ) sync* {
    while (true) {
      SolutionStatus info = strategy.solve(initialContext);
      SimplexTable table = AdjustedSimplexTable.wrap(
        initialContext.simplexTable,
        _getSolutionMessage(info),
        info,
      );

      yield table;

      if (info != SolutionStatus.undefined) {
        break;
      }

      initialContext = SimplexTableContext.create(
        simplexTable: strategy.getNextTable(initialContext),
      );
    }
  }

  String _getSolutionMessage(SolutionStatus info) {
    switch (info) {
      case SolutionStatus.hasRoot:
        return 'Found optimal solution';
      case SolutionStatus.noRoots:
        return 'Multiplicity of available solutions is empty';
      case SolutionStatus.undefined:
        return 'Solution is not optimal';
      default:
        throw Exception('Not supported');
    }
  }
}
