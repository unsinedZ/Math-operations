import 'entities/simplex_table.dart';

abstract class BaseSimplexTableSolver {
  List<SimplexTable> getSolutionSteps(SimplexTable simplexTable);
}
