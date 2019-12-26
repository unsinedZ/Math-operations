import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';

class PositiveFreeMemberAdjuster implements LinearTaskAdjuster {
  const PositiveFreeMemberAdjuster();

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
      context.changeLinearTask(
        adjustedTask.makeAdjusted("Adjusted free members."),
      ),
    ];
  }
}
