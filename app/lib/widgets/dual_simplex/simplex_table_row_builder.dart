import 'package:app/business/operations/fraction.dart';
import 'package:flutter/material.dart';

import 'simplex_table_value.dart';
import 'simplex_table_variable.dart';

class SimplexTableRowBuilder {
  final String basisVariableName;
  final List<Fraction> coefficients;
  final Fraction freeMember;

  SimplexTableRowBuilder({
    @required this.basisVariableName,
    @required this.coefficients,
    @required this.freeMember,
  });

  TableRow build() {
    return TableRow(
      children: [
        SimplexTableVariable(
          name: basisVariableName,
        ),
        ...coefficients.map(
          (x) => SimplexTableValue(
            value: x,
          ),
        ),
        SimplexTableValue(
          value: freeMember,
        ),
      ],
    );
  }
}
