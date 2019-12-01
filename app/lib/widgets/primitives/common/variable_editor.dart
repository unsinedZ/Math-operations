import 'package:app/business/operations/variable.dart';
import 'package:app/widgets/primitives/common/variable.dart' as primitive;
import 'package:flutter/material.dart';

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
    MediaQueryData query = MediaQuery.of(context);
    bool isScrollControlled = query.orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (x) => _makeConstrainted(
        shouldMake: isScrollControlled,
        widget: VariableForm(
          variable: _variable,
          onValueChanged: (x) {
            setState(() {
              _changeVariable(_variable.changeValue(x));
            });
          },
        ),
      ),
    );
  }

  Widget _makeConstrainted({
    Widget widget,
    bool shouldMake,
  }) {
    if (!shouldMake) return widget;

    MediaQueryData query = MediaQuery.of(context);
    BoxConstraints boxConstraints = BoxConstraints(
      maxHeight: query.size.height * .9,
    );
    return ConstrainedBox(
      constraints: boxConstraints,
      child: widget,
    );
  }

  void _changeVariable(Variable newVariable) {
    _variable = newVariable;
    widget.onVariableChanged(newVariable);
  }
}
