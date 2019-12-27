import 'package:app/business/operations/entities/extremum.dart';
import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/editors/scroll_integer_editor.dart';
import 'package:app/widgets/editors/variable_editor.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:app/widgets/primitives/overflow_safe_bottom_sheet_modal.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'function_letter.dart';

class FunctionInfo extends StatefulWidget {
  final TargetFunction targetFunction;
  final ValueChanged<TargetFunction> onFunctionChanged;
  final Extremum extremum;
  final ValueChanged<Extremum> onExtremumChanged;
  final bool isReadOnly;

  const FunctionInfo({
    Key key,
    @required this.targetFunction,
    @required this.onFunctionChanged,
    @required this.onExtremumChanged,
    this.extremum = Extremum.min,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  _FunctionInfoState createState() => _FunctionInfoState();
}

class _FunctionInfoState extends State<FunctionInfo> {
  List<Variable> _variables;

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  void didUpdateWidget(FunctionInfo oldWidget) {
    if (oldWidget.targetFunction != widget.targetFunction) {
      _init();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    int index = 0;
    _variables = widget.targetFunction.coefficients
        .map(
          (x) => Variable(
            name: '${widget.targetFunction.variableLetter}${++index}',
            value: x,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                FunctionLetter(
                  functionLetter: widget.targetFunction.functionLetter,
                  variableLetter: widget.targetFunction.variableLetter,
                  onPressed: () => _onFunctionLetterPressed(context),
                ),
                BaseText('='),
                ..._variables
                    .map(
                      (x) => VariableEditor(
                        variable: x,
                        onChanged: _checkReadOnly(
                          (v) => this._onFunctionVariableChanged(x, v),
                        ),
                        showSignForPositive: index++ > 0,
                      ),
                    )
                    .toList(),
              ],
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
                value: widget.extremum,
                items: Extremum.values
                    .map(
                      (x) => DropdownMenuItem(
                        value: x,
                        child: BaseText(x.toString().split('.').last),
                      ),
                    )
                    .toList(),
                onChanged: _checkReadOnly(widget.onExtremumChanged),
                disabledHint:
                    BaseText(widget.extremum.toString().split('.').last),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onFunctionLetterPressed(BuildContext context) {
    if (widget.isReadOnly) {
      return;
    }

    OverflowSafeBottomSheetModal(
      (x) => ScrollIntegerEditor(
        text: 'Select number of arguments:',
        initialValue: _variables.length,
        minValue: 2,
        maxValue: 10,
        onChanged: _onFunctionVariablesCountChange,
      ),
    ).show(context);
  }

  void _onFunctionVariablesCountChange(int newValue) {
    if (newValue == _variables.length) {
      return;
    }

    List<Fraction> newCoefficients;
    if (newValue < _variables.length) {
      newCoefficients =
          widget.targetFunction.coefficients.take(newValue).toList();
    } else {
      int expandSize = newValue - _variables.length;
      newCoefficients = concat(
        [
          widget.targetFunction.coefficients,
          List.generate(
            expandSize,
            (_) => Fraction.fromNumber(1),
          ),
        ],
      ).toList();
    }

    widget.onFunctionChanged(
        widget.targetFunction.changeCoefficients(newCoefficients));
  }

  void _onFunctionVariableChanged(Variable variable, Variable newValue) {
    setState(() {
      _variables = _variables.map((v) {
        if (v == variable) {
          return newValue;
        }

        return v;
      }).toList();
      widget.onFunctionChanged(widget.targetFunction.changeCoefficients(
        _variables.map((x) => x.value).toList(),
      ));
    });
  }

  T _checkReadOnly<T>(T value) {
    if (widget.isReadOnly) {
      return null;
    }

    return value;
  }
}
