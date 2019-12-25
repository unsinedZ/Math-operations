import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/simplex_table.dart';
import 'package:app/business/operations/simplex_table_builder.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:quiver/iterables.dart';

class DualSimplexBasisCreator implements LinearTaskAdjuster {
  const DualSimplexBasisCreator();
  
  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext task) {
    return _generateSteps(task).toList();
  }

  Iterable<LinearTaskContext> _generateSteps(LinearTaskContext context) sync* {
    // adding basis
    SimplexTable table =
        SimplexTableBuilder().createSimplexTable(context.linearTask);
    List<int> artificialVariableIndices = List<int>();
    Map<Restriction, Restriction> changedRestrictions = {};
    for (int rowIndex = 0; rowIndex < table.rows.length; rowIndex++) {
      SimplexTableRow row = table.rows[rowIndex];
      bool hasBasis = false;
      for (int coefficientIndex = 0;
          coefficientIndex < row.coefficients.length;
          coefficientIndex++) {
        Fraction item = row[coefficientIndex];
        hasBasis = table.rows
            .where((x) => x != row)
            .every((x) => x[coefficientIndex].equalsNumber(0));
        if (hasBasis) {
          if (!item.equalsNumber(1)) {
            Restriction correspondingRestriction =
                context.linearTask.restrictions[rowIndex];
            changedRestrictions[correspondingRestriction] =
                correspondingRestriction.changeCoefficients(
                    correspondingRestriction.coefficients
                        .map((x) => x / item)
                        .toList());
          }

          break;
        }
      }

      if (!hasBasis) {
        artificialVariableIndices.add(rowIndex);
      }
    }

    context =
        context.changeArtificialVariableIndexes(artificialVariableIndices);

    // restrictions with basis not equal to 1
    if (changedRestrictions.isNotEmpty) {
      yield context = context.changeLinearTask(
        AdjustedLinearTask.wrap(
          context.linearTask.changeRestrictions(
            context.linearTask.restrictions.map(
              (x) {
                if (changedRestrictions.containsKey(x))
                  return changedRestrictions[x];

                return x;
              },
            ).toList(),
          ),
          "Restrictions with basis ≠ 1 were normalized",
        ),
      );
    }

    // restrictions with artificial variables
    if (artificialVariableIndices.isNotEmpty) {
      int index = 0;
      yield context = context.changeLinearTask(
        AdjustedLinearTask.wrap(
          context.linearTask
              .changeRestrictions(
                context.linearTask.restrictions.map(
                  (x) {
                    int restrictionIndex = index++;
                    return x.changeCoefficients(
                      concat(
                        [
                          x.coefficients,
                          artificialVariableIndices.map(
                            (z) => Fraction.fromNumber(
                                z == restrictionIndex ? 1 : 0),
                          ),
                        ],
                      ).toList(),
                    );
                  },
                ).toList(),
              )
              .changeTargetFunction(
                context.linearTask.targetFunction.changeCoefficients(
                  concat(
                    [
                      context.linearTask.targetFunction.coefficients,
                      artificialVariableIndices.map(
                        (x) => Fraction.fromNumber(0),
                      ),
                    ],
                  ).toList(),
                ),
              ),
          "Added artificial variables",
          artificialVariableIndices,
        ),
      );
    }
  }
}
