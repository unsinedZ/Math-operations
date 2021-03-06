import 'package:app/business/operations/entities/solution_status.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:app/business/operations/simplex_table/simplex_table_solution_extractor.dart';

import 'isolver.dart';

abstract class BaseClippingMethodStrategy implements ISolver<SimplexTableContext> {
  const BaseClippingMethodStrategy();

  bool get requiresAllIntegers;

  @override
  bool canBeApplied(SimplexTableContext context) => true;

  SimplexTableContext addClipping(SimplexTableContext context);

  SolutionStatus solve(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null) {
      throw Exception('Context is null.');
    }

    if (simplexTableContext.integerVariableIndices.isNotEmpty) {
      var solution =
          SimplexTableSolutionExtractor().extractSolution(simplexTableContext);
      for (int i = 0; i < solution.length; i++) {
        if (!solution[i].isInteger() &&
            simplexTableContext.integerVariableIndices.contains(i)) {
          return SolutionStatus.undefined;
        }
      }
    }

    return SolutionStatus.hasRoot;
  }
}
