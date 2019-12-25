import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/simplex_table.dart';

class SimplexTableTransformationContext {
  final SimplexTable simplexTable;
  final int solvingRowIndex;
  final int solvingColumnIndex;

  SimplexTableTransformationContext({
    this.simplexTable,
    this.solvingRowIndex,
    this.solvingColumnIndex,
  });

  SimplexTable transform() {
    SimplexTableRow solvingRow = simplexTable.rows[solvingRowIndex];
    var newSolvingRow = solvingRow / solvingRow[solvingColumnIndex];
    var newRows = _transformRows(newSolvingRow);
    var newEstimations = SimplexTableEstimations.fromRow(
        _transformRow(simplexTable.estimations.toRow(), newSolvingRow));
    return SimplexTable(
      rows: newRows,
      estimations: newEstimations,
    );
  }

  List<SimplexTableRow> _transformRows(SimplexTableRow solvingRow) {
    int index = 0;
    return simplexTable.rows
        .map((x) => index++ == solvingRowIndex
            ? solvingRow
            : _transformRow(x, solvingRow))
        .toList();
  }

  SimplexTableRow _transformRow(
      SimplexTableRow row, SimplexTableRow solvingRow) {
    if (row == solvingRow) {
      return row;
    }

    Fraction rowMultiplier = row[solvingColumnIndex] * Fraction.fromNumber(-1);
    int index = 0;
    var newCoefficients = row.coefficients
        .map((x) => solvingRow[index++] * rowMultiplier + x)
        .toList();
    Fraction newFreeMember =
        solvingRow.freeMember * rowMultiplier + row.freeMember;
    return SimplexTableRow(
      coefficients: newCoefficients,
      freeMember: newFreeMember,
    );
  }
}
