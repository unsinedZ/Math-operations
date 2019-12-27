import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:app/business/operations/simplex_table/simplex_table_solution_extractor.dart';
import 'base_gomory_strategy.dart';

class GomoriFirstStrategy extends BaseGomoriStrategy {
  const GomoriFirstStrategy();

  @override
  bool get requiresAllIntegers => true;

  @override
  SimplexTableRow findSolvingRow(SimplexTableContext context) {
    var solution = SimplexTableSolutionExtractor().extractSolution(context);
    List<int> checkIndices = <int>[];
    for (int i = 0; i < solution.length; i++) {
      var value = solution[i];
      if (!value.isInteger() && context.integerVariableIndices.contains(i)) {
        checkIndices.add(i);
      }
    }

    List<int> matchingIndices = <int>[];
    if (checkIndices.length > 1) {
      checkIndices.reduce(
        (x, y) {
          if (matchingIndices.isEmpty) {
            matchingIndices.add(x);
          }

          var current = solution[matchingIndices[0]].fractionalPart();
          var candidate = solution[y].fractionalPart();
          if (candidate > current) {
            matchingIndices.clear();
            matchingIndices.add(y);
            return y;
          }

          if (candidate == current) {
            matchingIndices.add(y);
            return y;
          }

          return x;
        },
      );
    } else {
      matchingIndices = checkIndices;
    }

    if (matchingIndices.length == 0) {
      throw Exception('Tanos - nevozmozhno!');
    }

    var matchingRows = Map.fromIterable(
      matchingIndices,
      key: (i) => i,
      value: (i) => context.simplexTable.rows.firstWhere(
        (x) => !x[i].equalsNumber(0),
      ),
    );

    var rates = <SimplexTableRow, Fraction>{};
    var resultIndex = matchingIndices.reduce(
      (x, y) {
        var xRow = matchingRows[x];
        var xRatio = rates.putIfAbsent(
          xRow,
          () =>
              xRow.freeMember.fractionalPart() /
              xRow.coefficients.reduce(
                (a, b) => a.fractionalPart() + b.fractionalPart(),
              ),
        );

        var yRow = matchingRows[y];
        var yRatio = rates.putIfAbsent(
          yRow,
          () =>
              yRow.freeMember.fractionalPart() /
              yRow.coefficients.reduce(
                (a, b) => a.fractionalPart() + b.fractionalPart(),
              ),
        );

        if (yRatio > xRatio) {
          return y;
        }

        return x;
      },
    );

    return matchingRows[resultIndex];
  }

  @override
  SimplexTableRow createClippingRow(SimplexTableRow solvingRow) {
    Fraction minusOne = Fraction.fromNumber(-1);
    return SimplexTableRow(
      freeMember: solvingRow.freeMember.fractionalPart() * minusOne,
      coefficients: solvingRow.coefficients
          .map(
            (x) => x.fractionalPart() * minusOne,
          )
          .toList()
            ..add(
              Fraction.fromNumber(1),
            ),
    );
  }
}
