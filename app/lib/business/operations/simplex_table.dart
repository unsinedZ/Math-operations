import 'package:app/business/operations/solution_status.dart';
import 'package:flutter/foundation.dart';

import 'fraction.dart';

class SimplexTable {
  final List<SimplexTableRow> rows;
  final SimplexTableEstimations estimations;

  const SimplexTable({
    @required this.rows,
    @required this.estimations,
  });
}

class SimplexTableRow {
  final List<Fraction> coefficients;
  final Fraction freeMember;

  const SimplexTableRow({
    @required this.coefficients,
    @required this.freeMember,
  });

  SimplexTableRow operator /(Fraction value) {
    var newCoefficients = coefficients.map((x) => x / value);
    var newFreeMember = freeMember / value;
    return SimplexTableRow(
      coefficients: newCoefficients.toList(),
      freeMember: newFreeMember,
    );
  }

  Fraction operator [](int i) => coefficients[i];
}

class SimplexTableEstimations {
  final List<Fraction> variableEstimations;
  final Fraction functionValue;

  const SimplexTableEstimations({
    @required this.variableEstimations,
    @required this.functionValue,
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

class AdjustedSimplexTable extends SimplexTable {
  final String comment;
  final SolutionStatus solutionInfo;

  AdjustedSimplexTable({
    @required List<SimplexTableRow> rows,
    @required SimplexTableEstimations estimations,
    @required this.comment,
    @required this.solutionInfo,
  }) : super(
          estimations: estimations,
          rows: rows,
        );

  static AdjustedSimplexTable wrap(
      SimplexTable table, String comment, SolutionStatus solutionInfo) {
    return AdjustedSimplexTable(
      comment: comment,
      estimations: table.estimations,
      rows: table.rows,
      solutionInfo: solutionInfo,
    );
  }
}
