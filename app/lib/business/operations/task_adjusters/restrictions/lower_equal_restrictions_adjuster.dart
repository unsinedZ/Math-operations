import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:quiver/iterables.dart';

class LowerEqualRestrictionsAdjuster implements LinearTaskAdjuster {
  const LowerEqualRestrictionsAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    List<int> additionalVariableRestrictionIndices = [];
    int index = 0;
    context.restrictions.forEach(
      (x) {
        int i = index++;
        if (x.comparison == ExpressionComparison.LowerOrEqual) {
          additionalVariableRestrictionIndices.add(i);
        }
      },
    );
    if (additionalVariableRestrictionIndices.isEmpty) {
      return [];
    }

    index = 0;
    var adjustedRestrictions = context.restrictions.map(
      (x) {
        int i = index++;
        return x
            .changeCoefficients(
              concat(
                [
                  x.coefficients,
                  additionalVariableRestrictionIndices.map(
                    (z) => Fraction.fromNumber(z == i ? 1 : 0),
                  ),
                ],
              ),
            )
            .changeComparison(ExpressionComparison.Equal);
      },
    );

    var adjustedFunction = context.targetFunction.changeCoefficients(
      concat(
        [
          context.targetFunction.coefficients,
          additionalVariableRestrictionIndices
              .map((x) => Fraction.fromNumber(0)),
        ],
      ),
    );

    var adjustedAdditionalVariableIndices = concat(
      [
        context.additionalVariableIndices,
        List.generate(
          additionalVariableRestrictionIndices.length,
          (x) => context.targetFunction.coefficients.length + x,
        ),
      ],
    );

    var adjustedContext = context
        .changeAdditionalVariableIndexes(adjustedAdditionalVariableIndices)
        .changeLinearTask(
          AdjustedLinearTask.wrap(
            context.linearTask
                .changeTargetFunction(adjustedFunction)
                .changeRestrictions(adjustedRestrictions),
            "Adjusted `≤` restrictions.",
          ),
        );
    return [adjustedContext];
  }
}
