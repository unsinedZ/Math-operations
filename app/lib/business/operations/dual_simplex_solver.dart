import 'package:app/business/operations/dual_simplex_adjuster.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:quiver/iterables.dart';

class DualSimplexSolver {
  List<LinearTask> getSolutionSteps(LinearTask initialTask) {
    DualSimplexAdjuster adjuster = DualSimplexAdjuster();
    return concat([
      adjuster.getAdjustionSteps(initialTask),
    ]).toList();
  }
}
