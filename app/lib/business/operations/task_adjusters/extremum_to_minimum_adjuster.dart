import 'package:app/business/operations/entities/extremum.dart';
import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/linear_task_context.dart';

import 'linear_task_adjuster.dart';

class ExtremumToMinimumAdjuster implements LinearTaskAdjuster {
  const ExtremumToMinimumAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    if (context.linearTask.extremum == Extremum.min) {
      return [];
    }

    Fraction minusOne = Fraction.fromNumber(-1);
    LinearTask adjusted =
        context.linearTask.changeExtremum(Extremum.min).changeTargetFunction(
              context.linearTask.targetFunction.changeCoefficients(
                context.linearTask.targetFunction.coefficients
                    .map((x) => x *= minusOne)
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
