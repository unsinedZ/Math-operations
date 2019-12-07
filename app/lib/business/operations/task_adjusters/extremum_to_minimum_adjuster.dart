import 'package:app/business/operations/extremum.dart';
import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/linear_task_context.dart';

import 'linear_task_adjuster.dart';

class ExtremumToMinimumAdjuster implements LinearTaskAdjuster {
  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    if (context.linearTask.extremum == Extremum.min) {
      return [];
    }

    LinearTask adjusted =
        context.linearTask.changeExtremum(Extremum.min).changeTargetFunction(
              context.linearTask.targetFunction.changeCoefficients(
                context.linearTask.targetFunction.coefficients
                    .map((x) => x *= Fraction.fromNumber(-1))
                    .toList(),
              ),
            );
    return [
      context.changeLinearTask(
        AdjustedLinearTask.wrap(
          adjusted,
          "Changed extremum to minimum",
        ),
      ),
    ];
  }
}
