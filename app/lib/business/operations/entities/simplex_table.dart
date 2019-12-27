import 'package:flutter/foundation.dart';

import 'fraction.dart';
import 'solution_status.dart';

class SimplexTable {
  final List<SimplexTableRow> rows;
  final SimplexTableEstimations estimations;

  List<Fraction> get freeMembers => rows.map((x) => x.freeMember).toList();

  const SimplexTable({
    @required this.rows,
    @required this.estimations,
  });

  SimplexTable changeRows(List<SimplexTableRow> newRows) {
    return SimplexTable(
      estimations: this.estimations,
      rows: newRows,
    );
  }

  SimplexTable changeEstimations(SimplexTableEstimations newEstimations) {
    return SimplexTable(
      estimations: newEstimations,
      rows: this.rows,
    );
  }
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

  SimplexTableRow changeCoefficients(List<Fraction> newCoefficients) {
    return SimplexTableRow(
      freeMember: this.freeMember,
      coefficients: newCoefficients,
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
}

extension SimplextableExtensions on SimplexTable {
  AdjustedSimplexTable makeAdjusted(String comment, SolutionStatus solutionInfo) {
    return AdjustedSimplexTable(
      comment: comment,
      estimations: this.estimations,
      rows: this.rows,
      solutionInfo: solutionInfo,
    );
  }
}
