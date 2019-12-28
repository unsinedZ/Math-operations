import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/entities/solution_status.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:app/business/operations/strategies/isolver.dart';

abstract class BaseSimplexMethodStrategy implements ISolver<SimplexTableContext> {
  bool canBeApplied(SimplexTableContext context);

  SolutionStatus solve(SimplexTableContext context);

  SimplexTable getNextTable(SimplexTableContext simplexTableContext);
}
