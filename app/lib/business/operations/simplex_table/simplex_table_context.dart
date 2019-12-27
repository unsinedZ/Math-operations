import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:flutter/foundation.dart';

class SimplexTableContext {
  static const int _NO_BASIS = -1;

  final SimplexTable simplexTable;
  final List<int> basisVariableIndices;
  final List<int> integerVariableIndices;
  final bool hasBasis;

  const SimplexTableContext._({
    this.simplexTable,
    this.basisVariableIndices,
    this.integerVariableIndices,
    this.hasBasis,
  });

  static SimplexTableContext create({
    @required SimplexTable simplexTable,
    List<int> integerVariableIndices = const <int>[],
  }) {
    var basisVariableIndices = simplexTable.rows.map((row) {
      for (int i = 0; i < row.coefficients.length; i++) {
        Fraction item = row[i];
        if (!item.equalsNumber(1)) {
          continue;
        }

        bool isBasis = simplexTable.rows
            .where((x) => x != row)
            .every((x) => x[i].equalsNumber(0));
        if (isBasis) {
          return i;
        }
      }

      return _NO_BASIS;
    }).toList();

    var hasBasis = !basisVariableIndices.contains(_NO_BASIS);
    return SimplexTableContext._(
      simplexTable: simplexTable,
      basisVariableIndices: basisVariableIndices,
      integerVariableIndices: integerVariableIndices,
      hasBasis: hasBasis,
    );
  }
}
