import 'package:app/business/operations/extremum.dart';
import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/simplex_table.dart';
import 'package:quiver/iterables.dart';

class DualSimplexAdjuster {
  List<LinearTask> getAdjustionSteps(LinearTask task) {
    return _generateAdjustionSteps(task).toList();
  }

  Iterable<LinearTask> _generateAdjustionSteps(LinearTask task) sync* {
    // extremum = min
    if (task.extremum != Extremum.min) {
      yield task = _adjusted(
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

    // all restrictions are equalities
    if (task.restrictions
        .any((x) => x.comparison != ExpressionComparison.Equal)) {
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

      yield task = _adjusted(
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
    Map<int, Restriction> indexedChangedRestrictions = {};
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
            indexedChangedRestrictions[index] =
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
    if (indexedChangedRestrictions.isNotEmpty) {
      index = 0;
      yield task = _adjusted(
        task.changeRestrictions(
          task.restrictions.map(
            (x) {
              int i = index++;
              if (indexedChangedRestrictions.containsKey(i))
                return indexedChangedRestrictions[i];

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
      yield task = _adjusted(
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
  }

  AdjustedLinearTask _adjusted(LinearTask task, String comment) {
    return AdjustedLinearTask.wrap(task, comment);
  }
}
