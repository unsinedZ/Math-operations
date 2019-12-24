import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/extremum_to_minimum_adjuster.dart';
import 'package:app/business/operations/task_adjusters/simplex_restrictions_to_equalities_adjuster.dart';

import 'linear_task_adjuster.dart';

class SimplexAdjuster implements LinearTaskAdjuster {
  const SimplexAdjuster();
  
  List<LinearTaskAdjuster> _getAdjusters() => [
        ExtremumToMinimumAdjuster(),
        SimplexRestrictionsToEqualitiesAdjuster(),
      ];

  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    return _generateAdjustmentSteps(context).toList();
  }

  Iterable<LinearTaskContext> _generateAdjustmentSteps(LinearTaskContext task) sync* {
    for (LinearTaskAdjuster adjuster in _getAdjusters()) {
      List<LinearTaskContext> adjusted = adjuster.getAdjustmentSteps(task);
      for (LinearTaskContext adjustedTask in adjusted) {
        yield adjustedTask;
      }
    }
  }
}
