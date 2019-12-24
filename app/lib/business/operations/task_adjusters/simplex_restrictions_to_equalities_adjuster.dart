import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:quiver/iterables.dart';

class SimplexRestrictionsToEqualitiesAdjuster implements LinearTaskAdjuster {
  const SimplexRestrictionsToEqualitiesAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    if (context.linearTask.restrictions
        .every((x) => x.comparison == ExpressionComparison.Equal)) {
      return [];
    }

    return _generateAdjustmentSteps(context).toList();
  }

  Iterable<LinearTaskContext> _generateAdjustmentSteps(
      LinearTaskContext context) sync* {
    if (context.linearTask.restrictions
        .any((x) => x.comparison == ExpressionComparison.GreaterOrEqual)) {
      yield _adjustGreaterEqualRestrictions(context);
    }

    if (context.linearTask.restrictions
        .any((x) => x.comparison == ExpressionComparison.LowerOrEqual)) {
      yield _adjustLowerEqualRestrictions(context);
    }
  }

  LinearTaskContext _adjustGreaterEqualRestrictions(LinearTaskContext context) {
    #error TODO: Fraction expressions for artificial variable estimations
    TODO: >= and (>= + = restrictions)
    return null;
  }

  LinearTaskContext _adjustLowerEqualRestrictions(LinearTaskContext context) {
    List<int> additionalVariableIndices = List<int>();
    int index = 0;
    context.linearTask.restrictions.forEach((x) {
      int i = index++;
      if (x.comparison == ExpressionComparison.LowerOrEqual) {
        additionalVariableIndices.add(i);
      }
    });

    index = 0;
    return context
        .changeLinearTask(
          context.linearTask.changeRestrictions(
            context.linearTask.restrictions.map((x) {
              int i = index++;
              Restriction changed = x.changeCoefficients(
                concat(
                  [
                    x.coefficients,
                    additionalVariableIndices.map((v) => Fraction.fromNumber(
                        additionalVariableIndices.contains(i) ? 1 : 0)),
                  ],
                ),
              );
              if (x.comparison == ExpressionComparison.LowerOrEqual)
                changed = changed.changeComparison(ExpressionComparison.Equal);

              return changed;
            }).toList(),
          ),
        )
        .changeAdditionalVariableIndexes(additionalVariableIndices);
  }
}
