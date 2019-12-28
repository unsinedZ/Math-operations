import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:quiver/iterables.dart';

class EqualRestrictionsAdjuster implements LinearTaskAdjuster {
  const EqualRestrictionsAdjuster();

  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) =>
      _generateAdjustmentSteps(context).toList();

  Iterable<LinearTaskContext> _generateAdjustmentSteps(
      LinearTaskContext context) sync* {
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
      bool shouldSetValue = !rowPresent;
      if (!shouldSetValue) {
        var present =
            restriction.coefficients[adjustedCandidateCoords[restriction]];
        var current = restriction.coefficients[cIndex];
        shouldSetValue = (present.isNegative() && current.isPositive()) ||
            (!present.equalsNumber(1) && current.equalsNumber(1));
      }

      if (shouldSetValue) {
        adjustedCandidateCoords[restriction] = cIndex;
      }
    }

    Restriction maxNegative;
    Fraction maxFreeMemberOfNegative;

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
          negativeCandidateRestrictions.add(x);
          if (maxNegative == null || x.freeMember > maxFreeMemberOfNegative) {
            maxFreeMemberOfNegative = x.freeMember;
            maxNegative = x;
          }
        }
      },
    );

    if (artificialVariableRestrictions.isEmpty &&
        adjustedCandidateCoords.isEmpty) {
      return;
    }

    var changedRestrictions = <Restriction, Restriction>{};
    context.restrictions.forEach(
      (x) {
        changedRestrictions[x] = artificialVariableRestrictions.isEmpty
            ? x
            : x.changeCoefficients(
                concat(
                  [
                    x.coefficients,
                    artificialVariableRestrictions.map(
                      (z) => Fraction.fromNumber(z == x ? 1 : 0),
                    ),
                  ],
                ).toList(),
              );
      },
    );

    if (artificialVariableRestrictions.isNotEmpty) {
      yield context.changeLinearTask(
        context.linearTask
            .changeRestrictions(
              changedRestrictions.values.toList(),
            )
            .makeAdjusted(
              "Added artificial variables for `=` restrictions.",
            ),
      );
    }

    if (adjustedCandidateCoords.containsKey(maxNegative)) {
      var divideBy = changedRestrictions[maxNegative]
          .coefficients[adjustedCandidateCoords[maxNegative]]
          .abs();
      if (!divideBy.equalsNumber(1)) {
        changedRestrictions[maxNegative] = _divideByValue(
          changedRestrictions[maxNegative],
          divideBy,
        );

        yield context.changeLinearTask(
          context.linearTask
              .changeRestrictions(
                changedRestrictions.values.toList(),
              )
              .makeAdjusted(
                "Adjusted incomplete `=` restriction with max free member.",
              ),
        );
      }
    }

    bool negativesWereAdjusted = false;
    changedRestrictions.keys.forEach(
      (x) {
        if (x == maxNegative) {
          return;
        }

        var changed = changedRestrictions[x];
        if (negativeCandidateRestrictions.contains(x)) {
          changed = _substract(
            changedRestrictions[maxNegative],
            changed,
          );
        }

        if (adjustedCandidateCoords.containsKey(x)) {
          changed = _divideByValue(
            changed,
            changed.coefficients[adjustedCandidateCoords[x]].abs(),
          );
        }

        negativesWereAdjusted = changedRestrictions[x] != changed;
        changedRestrictions[x] = changed;
      },
    );

    if (negativesWereAdjusted) {
      yield context.changeLinearTask(
        context.linearTask
            .changeRestrictions(
              changedRestrictions.values.toList(),
            )
            .makeAdjusted(
              "Adjusted some incomplete `=` restrictions.",
            ),
      );
    }

    artificialVariableRestrictions.add(maxNegative);
    changedRestrictions.keys.forEach(
      (x) {
        var restriction = changedRestrictions[x];
        changedRestrictions[x] = restriction.changeCoefficients(
          concat(
            [
              restriction.coefficients,
              [
                Fraction.fromNumber(x == maxNegative ? 1 : 0),
              ],
            ],
          ).toList(),
        );
      },
    );

    var adjustedRestrictions = changedRestrictions.values.toList();
    var adjustedFunction = context.targetFunction.changeCoefficients(
      concat(
        [
          context.targetFunction.coefficients,
          artificialVariableRestrictions.map(
            (_) => Fraction.undefined(
              Fraction.fromNumber(1),
            ),
          ),
        ],
      ).toList(),
    );
    var adjustedArtificialIndices = concat(
      [
        context.artificialVariableIndices,
        List.generate(
          artificialVariableRestrictions.length,
          (x) => x + context.targetFunction.coefficients.length,
        ),
      ],
    ).toList();
    var adjustedContext = context
        .changeArtificialVariableIndexes(adjustedArtificialIndices)
        .changeLinearTask(
          context.linearTask
              .changeRestrictions(adjustedRestrictions)
              .changeTargetFunction(adjustedFunction)
              .makeAdjusted("Adjusted `=` restrictions."),
        );
    yield adjustedContext;
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
