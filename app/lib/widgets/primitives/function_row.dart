import 'package:app/business/entities/variable.dart';
import 'package:app/business/operations/fraction.dart';
import 'package:app/widgets/primitives/function_letter.dart';
import 'package:flutter/material.dart';

import 'function_variable.dart';

class FunctionRow extends StatelessWidget {
  final List<Variable> _variables = [
    Variable(
      name: 'x1',
      value: Fraction.fromNumber(4),
    ),
    Variable(
      name: 'x2',
      value: Fraction.fromNumber(1),
    ),
    Variable(
      name: 'x3',
      value: Fraction.fromNumber(-1),
    ),
    Variable(
      name: 'x4',
      value: Fraction.fromNumber(-3),
    ),
    Variable(
      name: 'x5',
      value: Fraction.fromNumber(5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _createRowContent(),
      ),
    );
  }

  List<Widget> _createRowContent() {
    int index = 0;
    return <Widget>[
      Container(
        child: FunctionLetter(
          functionLetter: 'f',
          variableLetter: 'x',
        ),
        margin: EdgeInsets.only(
          left: 16,
        ),
      ),
      ..._variables
        .map((x) => _createVariable(
              variable: x,
              showSignForPositive: index++ > 0,
            ))
        .reduce((x, y) => x..addAll(y))
    ];
  }

  List<Widget> _createVariable({
    Variable variable,
    bool showSignForPositive = false,
  }) {
    var result = <Widget>[];
    if (showSignForPositive || variable.value.isNegative()) {
      result.add(Text(variable.value.isNegative() ? '-' : '+'));
    }

    result.add(FunctionVariable(
      name: variable.name,
      value: variable.value.abs(),
      onPressed: () {},
    ));
    return result;
  }
}
