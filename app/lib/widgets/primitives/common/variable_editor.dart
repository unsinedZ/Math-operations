import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/primitives/common/variable.dart' as primitive;
import 'package:flutter/material.dart';

import 'overflow_safe_bottom_sheet_modal.dart';
import 'variable_form.dart';

class VariableEditor extends StatefulWidget {
  final Variable _variable;
  final ValueChanged<Variable> onVariableChanged;

  VariableEditor({
    @required Variable variable,
    @required this.onVariableChanged,
  }) : this._variable = variable;

  @override
  _VariableEditorState createState() => _VariableEditorState(_variable);
}

class _VariableEditorState extends State<VariableEditor> {
  Variable _variable;

  _VariableEditorState(Variable variable) : this._variable = variable;

  @override
  Widget build(BuildContext context) {
    return primitive.Variable(
      name: _variable.name,
      value: _variable.value.abs(),
      onPressed: () => _onFunctionVariablePressed(context),
    );
  }

  void _onFunctionVariablePressed(BuildContext context) {
    OverflowSafeBottomSheetModal(
      (_) => VariableForm(
        variable: _variable,
        onValueChanged: (x) {
          setState(() {
            _changeVariable(_variable.changeValue(x));
          });
        },
      ),
    ).show(context);
  }

  void _changeVariable(Variable newVariable) {
    _variable = newVariable;
    widget.onVariableChanged(newVariable);
  }
}
