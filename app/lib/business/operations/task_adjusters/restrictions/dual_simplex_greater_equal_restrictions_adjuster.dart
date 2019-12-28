import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';

class DualSimplexGreaterEqualRestrictionsAdjuster
    implements LinearTaskAdjuster {
  const DualSimplexGreaterEqualRestrictionsAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    if (!context.restrictions
        .any((x) => x.comparison == ExpressionComparison.GreaterOrEqual)) {
      return [];
    }

    var adjusted = context.changeLinearTask(
      context.linearTask
          .changeRestrictions(
            context.restrictions.map(
              (x) {
                if (x.comparison != ExpressionComparison.GreaterOrEqual) {
                  return x;
                }

                var minusOne = Fraction.fromNumber(-1);
                return x
                    .changeFreeMember(x.freeMember * minusOne)
                    .changeCoefficients(
                      x.coefficients
                          .map(
                            (z) => z * minusOne,
                          )
                          .toList(),
                    )
                    .changeComparison(ExpressionComparison.LowerOrEqual);
              },
            ).toList(),
          )
          .makeAdjusted("Adjusted `≥` restrictions."),
    );
    return [adjusted];
  }
}
