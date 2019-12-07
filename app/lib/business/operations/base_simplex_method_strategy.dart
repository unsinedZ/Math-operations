import 'simplex_table.dart';
import 'simplex_table_context.dart';
import 'solution_status.dart';

abstract class BaseSimplexMethodStrategy {
  bool canBeApplied(SimplexTableContext simplexTableContext);

  SolutionStatus solve(SimplexTableContext simplexTableContext);

  SimplexTable getNextTable(SimplexTableContext simplexTableContext);
}
