import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:quiver/iterables.dart';

class EqualRestrictionsAdjuster implements LinearTaskAdjuster {
  const EqualRestrictionsAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    var uniqueCandidateIndices = List.generate(
      context.linearTask.targetFunction.coefficients.length,
      (x) => x,
    )
        .map(
          (x) => [_getUniqueCandidateRestriction(x, context.restrictions), x],
        )
        .where((x) => x[0] != null)
        .toList();
    var adjustedCandidateCoords = <Restriction, int>{};
    for (int i = 0; i < uniqueCandidateIndices.length; i++) {
      var candidate = uniqueCandidateIndices[i];
      Restriction restriction = candidate[0];
      int cIndex = candidate[1];

      bool rowPresent = adjustedCandidateCoords.containsKey(restriction);
      bool shouldSetValue = !rowPresent ||
          (restriction.coefficients[adjustedCandidateCoords[restriction]]
                  .isNegative() &&
              restriction.coefficients[cIndex].isPositive());
      // if not present in adjusted or the one, that is present, is negative, and current is positive
      if (shouldSetValue) {
        adjustedCandidateCoords[restriction] = cIndex;
      }
    }

    List<Restriction> artificialVariableRestrictions = <Restriction>[];
    List<Restriction> negativeCandidateRestrictions = <Restriction>[];
    context.restrictions.forEach(
      (x) {
        if (!adjustedCandidateCoords.containsKey(x)) {
          artificialVariableRestrictions.add(x);
          return;
        }

        int cIndex = adjustedCandidateCoords[x];
        Fraction coefficient = x.coefficients[cIndex];
        if (coefficient.equalsNumber(1)) {
          adjustedCandidateCoords.remove(x);
        } else if (coefficient.isNegative()) {
          artificialVariableRestrictions.add(x);
          negativeCandidateRestrictions.add(x);
        }
      },
    );

    if (artificialVariableRestrictions.isEmpty &&
        adjustedCandidateCoords.isEmpty) {
      return [];
    }

    var restrictionChanges = <Restriction, Restriction Function(Restriction)>{};
    Restriction max;
    Fraction maxFreeMember;
    context.restrictions
        .where(
      (x) => adjustedCandidateCoords.containsKey(x),
    )
        .forEach(
      (x) {
        restrictionChanges[x] = (x) => x;
        if ((max == null || x.freeMember > maxFreeMember) &&
            negativeCandidateRestrictions.contains(x)) {
          maxFreeMember = x.freeMember;
          max = x;
        }
      },
    );

    restrictionChanges.keys.forEach(
      (x) {
        if (x == max) {
          return;
        }

        var adjustedRestriction = restrictionChanges[x];
        if (negativeCandidateRestrictions.contains(x)) {
          var nested = adjustedRestriction;
          adjustedRestriction = (z) => _substract(max, nested(z));
        }

        restrictionChanges[x] = (z) => _divideByValue(
          adjustedRestriction(z),
          x.coefficients[adjustedCandidateCoords[x]],
        );
      },
    );

    var adjustedRestrictions = context.restrictions.map(
      (x) {
        var adjustedRestriction = x.changeCoefficients(
          concat(
            [
              x.coefficients,
              artificialVariableRestrictions.map(
                (z) => Fraction.fromNumber(z == x ? 1 : 0),
              ),
            ],
          ).toList(),
        );
        if (restrictionChanges.containsKey(x)) {
          adjustedRestriction = restrictionChanges[x](adjustedRestriction);
        }

        return adjustedRestriction;
      },
    ).toList();
    var adjustedFunction = context.targetFunction.changeCoefficients(
      concat(
        [
          context.targetFunction.coefficients,
          artificialVariableRestrictions.map((_) => Fraction.fromNumber(0)),
        ],
      ).toList(),
    );
    var adjustedArtificialIndices = concat(
      [
        context.additionalVariableIndices,
        List.generate(
          artificialVariableRestrictions.length,
          (x) => x + context.targetFunction.coefficients.length,
        ),
      ],
    ).toList();
    var adjustedContext = context
        .changeArtificialVariableIndexes(adjustedArtificialIndices)
        .changeLinearTask(
          AdjustedLinearTask.wrap(
            context.linearTask
                .changeRestrictions(adjustedRestrictions)
                .changeTargetFunction(adjustedFunction),
            "Adjusted `=` restrictions.",
          ),
        );
    return [adjustedContext];
  }

  Restriction _getUniqueCandidateRestriction(
      int coefficientIndex, List<Restriction> restrictions) {
    int positiveCount = 0;
    int negativeCount = 0;
    Restriction restriction;

    restrictions.forEach(
      (x) {
        var coefficient = x.coefficients[coefficientIndex];
        if (coefficient.isPositive()) {
          positiveCount++;
          restriction = x;
        } else if (coefficient.isNegative()) {
          negativeCount++;
          restriction = x;
        }
      },
    );

    return negativeCount + positiveCount == 1 ? restriction : null;
  }

  Restriction _substract(Restriction from, Restriction value) {
    if (from.comparison != value.comparison) {
      throw Exception('Invalid operation with restrictions.');
    }

    int index = 0;
    return from
        .changeFreeMember(from.freeMember - value.freeMember)
        .changeCoefficients(
          from.coefficients
              .map(
                (x) => x - value.coefficients[index++],
              )
              .toList(),
        );
  }

  Restriction _divideByValue(Restriction restriction, Fraction value) {
    if (value.equalsNumber(1)) {
      return restriction;
    }

    return restriction
        .changeFreeMember(restriction.freeMember / value)
        .changeCoefficients(
          restriction.coefficients
              .map(
                (x) => x / value,
              )
              .toList(),
        );
  }
}
