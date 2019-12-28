import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:quiver/iterables.dart';

class GreaterEqualRestrictionsAdjuster implements LinearTaskAdjuster {
  const GreaterEqualRestrictionsAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    List<int> additionalVariableRestrictionIndices = [];
    int index = 0;
    context.restrictions.forEach(
      (x) {
        int i = index++;
        if (x.comparison != ExpressionComparison.GreaterOrEqual) return x;

        additionalVariableRestrictionIndices.add(i);
        return null;
      },
    );
    if (additionalVariableRestrictionIndices.isEmpty) {
      return [];
    }

    index = 0;
    var adjustedRestrictions = context.restrictions.map(
      (x) {
        bool adjusted = false;
        int i = index++;
        return x
            .changeCoefficients(
              concat(
                [
                  x.coefficients,
                  additionalVariableRestrictionIndices.map(
                    (z) => Fraction.fromNumber(
                        z == i && (adjusted = true) ? -1 : 0),
                  ),
                ],
              ).toList(),
            )
            .changeComparison(
                adjusted ? ExpressionComparison.Equal : x.comparison);
      },
    ).toList();

    var adjustedFunction = context.targetFunction.changeCoefficients(
      concat(
        [
          context.targetFunction.coefficients,
          additionalVariableRestrictionIndices.map(
            (_) => Fraction.fromNumber(0),
          ),
        ],
      ).toList(),
    );

    var adjustedAdditionalVariableIndices = concat(
      [
        context.additionalVariableIndices,
        List.generate(
          additionalVariableRestrictionIndices.length,
          (x) => context.targetFunction.coefficients.length + x,
        ),
      ],
    ).toList();

    var adjustedContext = context
        .changeAdditionalVariableIndexes(adjustedAdditionalVariableIndices)
        .changeLinearTask(
          context.linearTask
              .changeTargetFunction(adjustedFunction)
              .changeRestrictions(adjustedRestrictions)
              .makeAdjusted("Adjusted `≥` restrictions."),
        );
    return [adjustedContext];
  }
}
