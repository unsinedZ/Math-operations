import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/primitives/common/arguments_count_form.dart';
import 'package:app/widgets/primitives/common/base_text.dart';
import 'package:app/widgets/primitives/common/variable.dart' as primitive;
import 'package:app/widgets/primitives/common/variable_editor.dart';
import 'package:app/widgets/primitives/common/variable_form.dart';
import 'function_letter.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart' as quiver;

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
  final String functionLetter;
  final String variableLetter;
  List<Variable> _variables;

  _FunctionRowState(TargetFunction targetFunction)
      : this.functionLetter = targetFunction.functionLetter,
        this.variableLetter = targetFunction.variableLetter {
    int index = 0;
    _variables = targetFunction.coefficients
        .map((x) => Variable(
              name: '$variableLetter${++index}',
              value: x,
            ))
        .toList();
  }

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
        functionLetter: functionLetter,
        variableLetter: variableLetter,
        onPressed: () => _onFunctionLetterPressed(context),
      ),
      BaseText('='),
      ..._variables
          .map((x) => _createVariable(
                context: context,
                variable: x,
                showSignForPositive: index++ > 0,
              ))
          .reduce((x, y) => x..addAll(y))
    ];
  }

  List<Widget> _createVariable({
    BuildContext context,
    Variable variable,
    bool showSignForPositive = false,
  }) {
    var result = <Widget>[];
    if (showSignForPositive || variable.value.isNegative()) {
      result.add(BaseText(variable.value.isNegative() ? '-' : '+'));
    }

    result.add(VariableEditor(
      variable: variable,
      onVariableChanged: (x) => _onFunctionVariableChange(context, variable, x),
    ));
    return result;
  }

  void _onFunctionLetterPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (x) => ArgumentsCountForm(
        initialValue: _variables.length,
        onValueChanged: _onFunctionVariablesCountChange,
      ),
    );
  }

  void _onFunctionVariablesCountChange(int newValue) {
    if (newValue == _variables.length) {
      return;
    }

    setState(() {
      if (newValue < _variables.length) {
        _variables = _variables.take(newValue).toList();
      } else {
        int expandSize = newValue - _variables.length;
        _variables = quiver.concat(
          [
            _variables,
            List.generate(
              expandSize,
              (index) {
                return Variable(
                  name: '$variableLetter${_variables.length + index + 1}',
                  value: Fraction.fromNumber(1),
                );
              },
            ),
          ],
        ).toList();
      }
    });
  }

  void _onFunctionVariableChange(
    BuildContext context,
    Variable variable,
    Variable newValue,
  ) {
    setState(() {
      _variables = _variables.map((v) {
        if (v == variable) return newValue;

        return v;
      }).toList();
    });
  }
}
