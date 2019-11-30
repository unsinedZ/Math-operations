import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/primitives/function_letter.dart';
import 'package:app/widgets/primitives/function_letter_form.dart';
import 'package:flutter/material.dart';

import 'function_text.dart';
import 'function_variable.dart';

class FunctionRow extends StatefulWidget {
  final TargetFunction _targetFunction;

  const FunctionRow({
    Key key,
    @required TargetFunction targetFunction,
  })  : this._targetFunction = targetFunction,
        super(key: key);

  @override
  _FunctionRowState createState() => _FunctionRowState(_targetFunction);
}

class _FunctionRowState extends State<FunctionRow> {
  TargetFunction _targetFunction;

  _FunctionRowState(this._targetFunction);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _createRowContent(context),
      ),
    );
  }

  List<Widget> _createRowContent(BuildContext context) {
    int index = 0;
    return <Widget>[
      FunctionLetter(
        functionLetter: _targetFunction.functionLetter,
        variableLetter: _targetFunction.variableLetter,
        onPressed: () => _onFunctionLetterPressed(context),
      ),
      FunctionText('='),
      ..._targetFunction.coefficients
          .map((x) => _createVariable(
                variable: Variable(
                  name: _targetFunction.variableLetter,
                  value: x,
                ),
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
      result.add(FunctionText(variable.value.isNegative() ? '-' : '+'));
    }

    result.add(FunctionVariable(
      name: variable.name,
      value: variable.value.abs(),
      onPressed: () {},
    ));
    return result;
  }

  void _onFunctionLetterPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (x) => Container(
        child: FunctionLetterForm(
          initialValue: _targetFunction.coefficients.length,
          onValueChanged: (num newValue) {
            setState(() {
              if (newValue == _targetFunction.coefficients.length) {
                return;
              }

              List<Fraction> newCoefficients;
              if (newValue < _targetFunction.coefficients.length) {
                newCoefficients = _targetFunction.coefficients.take(newValue).toList();
              } else {
                int expandSize = newValue - _targetFunction.coefficients.length;
                newCoefficients = _targetFunction.coefficients
                  ..addAll(
                    List.filled(expandSize, Fraction.fromNumber(1)),
                  );
              }

              _targetFunction =
                  _targetFunction.changeCoefficients(newCoefficients);
            });
          },
        ),
      ),
      useRootNavigator: true,
    );
  }
}
