import 'fraction.dart';

class SimplexTable {
  final List<SimplexTableRow> rows;
  final SimplexTableEstimations estimations;

  const SimplexTable({
    this.rows,
    this.estimations,
  });
}

class SimplexTableRow {
  final List<Fraction> coefficients;
  final Fraction freeMember;

  const SimplexTableRow({
    this.coefficients,
    this.freeMember,
  });

  SimplexTableRow operator /(Fraction value) {
    var newCoefficients = coefficients
      .map((x) => x / value);
    var newFreeMember = freeMember / value;
    return SimplexTableRow(
      coefficients: newCoefficients.toList(),
      freeMember: newFreeMember,
    );
  }
}

class SimplexTableEstimations {
  final List<Fraction> variableEstimations;
  final Fraction functionValue;

  const SimplexTableEstimations({
    this.variableEstimations,
    this.functionValue,
  });

  SimplexTableEstimations.fromRow(SimplexTableRow row)
    : variableEstimations = row.coefficients,
      functionValue = row.freeMember;

  SimplexTableRow toRow() {
    return SimplexTableRow(
      coefficients: variableEstimations,
      freeMember: functionValue,
    );
  }
}