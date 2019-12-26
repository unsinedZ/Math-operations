import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/entities/solution_status.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';

abstract class BaseSimplexMethodStrategy {
  bool canBeApplied(SimplexTableContext simplexTableContext);

  SolutionStatus solve(SimplexTableContext simplexTableContext);

  SimplexTable getNextTable(SimplexTableContext simplexTableContext);
}
