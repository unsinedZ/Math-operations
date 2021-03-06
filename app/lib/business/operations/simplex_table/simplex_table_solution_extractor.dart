import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/simplex_table.dart';

import 'simplex_table_context.dart';

class SimplexTableSolutionExtractor {
  List<Fraction> extractSolution(SimplexTableContext context) {
    return _extractSolution(context).toList();
  }

  Iterable<Fraction> _extractSolution(SimplexTableContext context) sync* {
    List<SimplexTableRow> rows = context.simplexTable.rows;
    List<Fraction> estimations =
        context.simplexTable.estimations.variableEstimations;
    for (int i = 0; i < estimations.length; i++) {
      int basisIndex = context.basisVariableIndices.indexOf(i);
      if (basisIndex != -1)
        yield rows[basisIndex].freeMember;
      else
        yield Fraction.fromNumber(0);
    }
  }
}
