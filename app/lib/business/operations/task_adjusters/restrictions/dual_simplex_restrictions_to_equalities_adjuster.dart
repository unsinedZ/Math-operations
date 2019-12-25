import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:quiver/iterables.dart';

typedef bool _HasAdditionalVariable(int index);

class DualSimplexRestrictionsToEqualitiesAdjuster
    implements LinearTaskAdjuster {
  const DualSimplexRestrictionsToEqualitiesAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    if (context.linearTask.restrictions
        .every((x) => x.comparison == ExpressionComparison.Equal)) {
      return [];
    }

    List<int> additionalVariableIndices =
        _getAdditionalVariableIndices(context.linearTask.restrictions);

    List<Restriction> newRestrictions =
        List<Restriction>(context.linearTask.restrictions.length);
    for (int i = 0; i < context.linearTask.restrictions.length; i++) {
      newRestrictions[i] = _adjustRestriction(
        context.linearTask.restrictions[i],
        additionalVariableIndices,
        (index) => i == index,
      );
    }

    return [
      context
          .changeLinearTask(
            AdjustedLinearTask.wrap(
              context.linearTask
                  .changeRestrictions(newRestrictions)
                  .changeTargetFunction(
                    context.linearTask.targetFunction.changeCoefficients(
                      concat([
                        context.linearTask.targetFunction.coefficients,
                        additionalVariableIndices
                            .map((x) => Fraction.fromNumber(0)),
                      ]).toList(),
                    ),
                  ),
              "All restrictions became equalities",
            ),
          )
          .changeAdditionalVariableIndexes(additionalVariableIndices),
    ];
  }

  Restriction _adjustRestriction(
    Restriction restriction,
    List<int> additionalVariableIndices,
    _HasAdditionalVariable isAdditionalVariablePresent,
  ) {
    bool shouldInvertSign =
        restriction.comparison == ExpressionComparison.GreaterOrEqual;
    List<Fraction> newCoefficients = List<Fraction>.from(
      shouldInvertSign
          ? restriction.coefficients.map(
              (x) => x *= Fraction.fromNumber(-1),
            )
          : restriction.coefficients,
    );
    for (int i in additionalVariableIndices) {
      int coefficient = isAdditionalVariablePresent(i) ? 1 : 0;
      newCoefficients.add(Fraction.fromNumber(coefficient));
    }

    return restriction
        .changeCoefficients(newCoefficients)
        .changeComparison(ExpressionComparison.Equal);
  }

  List<int> _getAdditionalVariableIndices(List<Restriction> restrictions) {
    List<int> additionalVariableIndices = List<int>();
    for (int i = 0; i < restrictions.length; i++) {
      if (restrictions[i].comparison != ExpressionComparison.Equal) {
        additionalVariableIndices.add(i);
      }
    }

    return additionalVariableIndices;
  }
}
