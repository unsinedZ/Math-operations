import 'fraction.dart';
import 'simplex_table.dart';

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
    var newSolvingRow =
        solvingRow / solvingRow.coefficients[solvingColumnIndex];
    var newRows = _transformRows(newSolvingRow);
    var newEstimations = SimplexTableEstimations.fromRow(_transformRow(simplexTable.estimations.toRow(), solvingRow));
    return SimplexTable(
      rows: newRows,
      estimations: newEstimations,
    );
  }

  List<SimplexTableRow> _transformRows(SimplexTableRow solvingRow) {
    return simplexTable.rows
      .map((x) => _transformRow(x, solvingRow))
      .toList();
  }

  SimplexTableRow _transformRow(
      SimplexTableRow row, SimplexTableRow solvingRow) {
    if (row == solvingRow) return row;

    Fraction rowMultiplier = -row.coefficients[solvingColumnIndex];
    int index = 0;
    var newCoefficients = row.coefficients
        .map((x) => solvingRow.coefficients[index++] * rowMultiplier + x)
        .toList();
    Fraction newFreeMember =
        solvingRow.freeMember * rowMultiplier + row.freeMember;
    return SimplexTableRow(
      coefficients: newCoefficients,
      freeMember: newFreeMember,
    );
  }
}
