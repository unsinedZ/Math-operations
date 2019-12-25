import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:app/business/operations/restriction.dart';

class SimplexRestrictionsFreeMemberAdjuster implements LinearTaskAdjuster {
  const SimplexRestrictionsFreeMemberAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    Fraction minusOne = const Fraction.fromNumber(-1);

    var restrictions = context.linearTask.restrictions;
    if (restrictions.every((x) => !x.freeMember.isNegative())) {
      return [];
    }

    var adjustedTask = context.linearTask.changeRestrictions(
      context.linearTask.restrictions
          .map(
            (x) => x.freeMember.isNegative()
                ? x
                    .changeFreeMember(x.freeMember * minusOne)
                    .changeComparison(x.comparison.invert())
                    .changeCoefficients(
                      x.coefficients.map((z) => z * minusOne).toList(),
                    )
                : x,
          )
          .toList(),
    );
    return [
      context.changeLinearTask(AdjustedLinearTask.wrap(
        adjustedTask,
        "Adjusted free members.",
      )),
    ];
  }
}
