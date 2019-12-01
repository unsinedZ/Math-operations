import 'dart:async';

import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/primitives/common/arguments_count_form.dart';
import 'package:app/widgets/primitives/common/base_text.dart';
import 'package:app/widgets/primitives/common/overflow_safe_bottom_sheet_modal.dart';
import 'package:app/widgets/primitives/common/variable_editor.dart';
import 'package:rxdart/rxdart.dart';
import 'function_letter.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart' as quiver;

class FunctionRow extends StatefulWidget {
  final TargetFunction _targetFunction;
  final ValueChanged<TargetFunction> _onTargetFunctionChanged;

  const FunctionRow({
    Key key,
    @required TargetFunction targetFunction,
    @required ValueChanged<TargetFunction> onTargetFunctionChanged,
  })  : this._targetFunction = targetFunction,
        this._onTargetFunctionChanged = onTargetFunctionChanged,
        super(key: key);

  @override
  _FunctionRowState createState() => _FunctionRowState(
        _targetFunction,
        _onTargetFunctionChanged,
      );
}

class _FunctionRowState extends State<FunctionRow> {
  final ValueChanged<TargetFunction> _onTargetFunctionChanged;

  TargetFunction _targetFunction;
  BehaviorSubject<List<Variable>> _variablesSubject;
  StreamSubscription _variablesSubscription;
  List<Variable> _variables;
  Extremum _extremum = Extremum.min;

  _FunctionRowState(
    TargetFunction targetFunction,
    ValueChanged<TargetFunction> onTargetFunctionChanged,
  )   : this._targetFunction = targetFunction,
        this._onTargetFunctionChanged = onTargetFunctionChanged;

  @override
  void initState() {
    int index = 0;
    _variables = _targetFunction.coefficients
        .map((x) => Variable(
              name: '${_targetFunction.variableLetter}${++index}',
              value: x,
            ))
        .toList();

    _variablesSubject = BehaviorSubject<List<Variable>>();
    _variablesSubscription = _variablesSubject.stream.listen(
      _onVariablesChange,
    );
    super.initState();
  }

  @override
  void dispose() {
    _variablesSubscription.cancel();
    super.dispose();
  }

  void _onVariablesChange(List<Variable> variables) {
    setState(() {
      _variables = variables;
      _targetFunction = _updateFunctionWithVariables(variables);
      _onTargetFunctionChanged(_targetFunction);
    });
  }

  TargetFunction _updateFunctionWithVariables(List<Variable> variables) {
    return _targetFunction.changeCoefficients(
      variables.map((x) => x.value).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _createRowContent(context),
            ),
          ),
        ),
        Flexible(
          flex: 0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: Icon(Icons.arrow_forward),
              ),
              DropdownButton(
                value: _extremum,
                items: Extremum.values
                    .map(
                      (x) => DropdownMenuItem(
                        value: x,
                        child: BaseText(x.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: _onExtremumChange,
              ),
            ],
          ),
        ),
      ],
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
      BaseText('='),
      ..._variables
          .map((x) => _createVariable(
                context: context,
                variable: x,
                showSignForPositive: index++ > 0,
              ))
          .reduce(
            (x, y) => x..addAll(y),
          ),
    ];
  }

  void _onExtremumChange(Extremum newExtremum) {
    setState(() {
      _extremum = newExtremum;
    });
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
      onVariableChanged: (x) => _onFunctionVariableChange(variable, x),
    ));
    return result;
  }

  void _onFunctionLetterPressed(BuildContext context) {
    OverflowSafeBottomSheetModal(
      (x) => ArgumentsCountForm(
        initialValue: _variables.length,
        onValueChanged: _onFunctionVariablesCountChange,
      ),
    ).show(context);
  }

  void _onFunctionVariablesCountChange(int newValue) {
    if (newValue == _variables.length) {
      return;
    }

    List<Variable> newVariables;
    if (newValue < _variables.length) {
      newVariables = _variables.take(newValue).toList();
    } else {
      int expandSize = newValue - _variables.length;
      newVariables = quiver.concat(
        [
          _variables,
          List.generate(
            expandSize,
            (index) {
              int variableIndex = _variables.length + index + 1;
              return Variable(
                name: '${_targetFunction.variableLetter}$variableIndex',
                value: Fraction.fromNumber(1),
              );
            },
          ),
        ],
      ).toList();
    }

    _variablesSubject.add(newVariables);
  }

  void _onFunctionVariableChange(Variable variable, Variable newValue) {
    setState(() {
      _variables = _variables.map((v) {
        if (v == variable) return newValue;

        return v;
      }).toList();
    });
  }
}

enum Extremum {
  min,
  max,
}
