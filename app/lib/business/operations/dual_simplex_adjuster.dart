import 'package:app/business/operations/extremum.dart';
import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/simplex_table.dart';
import 'package:quiver/iterables.dart';

typedef LinearTask _AdjustTask(LinearTask task);

class DualSimplexAdjuster {
  List<_AdjustTask> _getAdjustmentMethods() => [
        _adjustExtremum,
        _adjustRestrictionsToBeEqualities,
        _adjustBasisToBePresent,
      ];

  List<LinearTask> getAdjustmentSteps(LinearTask task) {
    return _generateAdjustmentSteps(task).toList();
  }

  Iterable<LinearTask> _generateAdjustmentSteps(LinearTask task) sync* {
    for (_AdjustTask adjust in _getAdjustmentMethods()) {
      LinearTask adjusted = adjust(task);
      if (adjusted != null) {
        yield task = adjusted;
      }
    }
  }

  LinearTask _adjustExtremum(LinearTask task) {
    if (task.extremum == Extremum.min) {
      return null;
    }

    return task = _adjusted(
      task.changeExtremum(Extremum.min).changeTargetFunction(
            task.targetFunction.changeCoefficients(
              task.targetFunction.coefficients
                  .map((x) => x *= Fraction.fromNumber(-1))
                  .toList(),
            ),
          ),
      "Changed extremum to minimum",
    );
  }

  LinearTask _adjustRestrictionsToBeEqualities(LinearTask task) {
    if (!task.restrictions
        .any((x) => x.comparison != ExpressionComparison.Equal)) {
      return null;
    }

    List<int> additionalVariableIndices = List<int>();
    int index = 0;
    for (Restriction restriction in task.restrictions) {
      if (restriction.comparison != ExpressionComparison.Equal) {
        additionalVariableIndices.add(index);
      }

      index++;
    }

    index = 0;
    List<Restriction> newRestrictions =
        List<Restriction>(task.restrictions.length);
    for (Restriction restriction in task.restrictions) {
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
        int coefficient = i == index ? 1 : 0;
        newCoefficients.add(Fraction.fromNumber(coefficient));
      }

      newRestrictions[index] = restriction
          .changeCoefficients(newCoefficients)
          .changeComparison(ExpressionComparison.Equal);
      index++;
    }

    return task = _adjusted(
      task.changeRestrictions(newRestrictions).changeTargetFunction(
            task.targetFunction.changeCoefficients(
              concat([
                task.targetFunction.coefficients,
                additionalVariableIndices.map((x) => Fraction.fromNumber(0)),
              ]).toList(),
            ),
          ),
      "All restrictions became equalities",
    );
  }

  LinearTask _adjustBasisToBePresent(LinearTask task) {
    // adding basis
    SimplexTable table = SimplexTable(
      rows: task.restrictions
          .map(
            (x) => SimplexTableRow(
              coefficients: x.coefficients,
              freeMember: x.freeMember,
            ),
          )
          .toList(),
      estimations: SimplexTableEstimations(
        variableEstimations: task.targetFunction.coefficients
            .map(
              (x) => x * Fraction.fromNumber(-1),
            )
            .toList(),
        functionValue: task.targetFunction.freeMember,
      ),
    );
    List<int> artificialVariableIndices = List<int>();
    Map<int, Restriction> changedRestrictions = {};
    int index = 0;
    for (SimplexTableRow row in table.rows) {
      bool hasBasis = false;
      for (int i = 0; i < row.coefficients.length; i++) {
        Fraction item = row[i];
        hasBasis = table.rows
            .where((x) => x != row)
            .every((x) => x[i].equalsNumber(0));
        if (hasBasis) {
          if (!item.equalsNumber(1)) {
            Restriction correspondingRestriction = task.restrictions[index];
            changedRestrictions[index] =
                correspondingRestriction.changeCoefficients(
              correspondingRestriction.coefficients
                  .map(
                    (x) => x / item,
                  )
                  .toList(),
            );
          }

          break;
        }
      }

      if (!hasBasis) {
        artificialVariableIndices.add(index);
      }

      index++;
    }

    // restrictions with basis not equal to 1
    if (changedRestrictions.isNotEmpty) {
      index = 0;
      task = _adjusted(
        task.changeRestrictions(
          task.restrictions.map(
            (x) {
              int i = index++;
              if (changedRestrictions.containsKey(i))
                return changedRestrictions[i];

              return x;
            },
          ).toList(),
        ),
        "Restrictions with basis ≠ 1 were normalized",
      );
    }

    // restrictions with artificial variables
    if (artificialVariableIndices.isNotEmpty) {
      index = 0;
      task = _adjusted(
        task
            .changeRestrictions(
              task.restrictions.map(
                (x) {
                  return x.changeCoefficients(concat(
                    [
                      x.coefficients,
                      artificialVariableIndices.map(
                        (z) => Fraction.fromNumber(z == index ? 1 : 0),
                      ),
                    ],
                  ).toList());
                },
              ).toList(),
            )
            .changeTargetFunction(
              task.targetFunction.changeCoefficients(
                concat(
                  [
                    task.targetFunction.coefficients,
                    artificialVariableIndices.map(
                      (x) => Fraction.fromNumber(0),
                    ),
                  ],
                ).toList(),
              ),
            ),
        "Added artificial variables",
      );
    }

    return task;
  }

  AdjustedLinearTask _adjusted(LinearTask task, String comment) {
    return AdjustedLinearTask.wrap(task, comment);
  }
}
