import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/entities/simplex_table.dart';

class SimplexTableBuilder {
  SimplexTable createSimplexTable(LinearTask task) {
    const Fraction minusOne = const Fraction.fromNumber(-1);

    var basisIndices = _findBasisIndices(task.restrictions);
    var variableEstimations = <Fraction>[];
    for (int i = 0; i < task.targetFunction.coefficients.length; i++) {
      var initial = task.targetFunction.coefficients[i] * minusOne;
      for (int j = 0; j < task.restrictions.length; j++) {
        initial += task.restrictions[j].coefficients[i] *
            task.targetFunction.coefficients[basisIndices[j]];
      }

      variableEstimations.add(initial);
    }

    return SimplexTable(
      rows: task.restrictions
          .map(
            (x) => SimplexTableRow(
              coefficients: x.coefficients,
              freeMember: x.freeMember,
            ),
          )
          .toList(),
      estimations: SimplexTableEstimations(
        variableEstimations: variableEstimations,
        functionValue: task.targetFunction.freeMember,
      ),
    );
  }

  List<int> _findBasisIndices(List<Restriction> restrictions) {
    return restrictions.map((r) {
      for (int i = 0; i < r.coefficients.length; i++) {
        Fraction item = r.coefficients[i];
        if (!item.equalsNumber(1)) {
          continue;
        }

        bool isBasis = restrictions
            .where((x) => x != r)
            .every((x) => x.coefficients[i].equalsNumber(0));
        if (isBasis) {
          return i;
        }
      }

      return -1;
    }).toList();
  }
}
