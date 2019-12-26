import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:flutter/material.dart';

class VariablesSelector extends StatelessWidget {
  final String title;
  final Map<Variable, bool> variableSelection;
  final void Function(Variable, bool) onChangeSelection; 

  const VariablesSelector({
    Key key,
    @required this.title,
    @required this.variableSelection,
    @required this.onChangeSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BaseText(title),
          ),
          ...variableSelection.keys.map(
            (variable) {
              return _VariableRow(
                variable: variable,
                isSelected: variableSelection[variable],
                onChanged: (newSelection) => onChangeSelection(variable, newSelection),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _VariableRow extends StatelessWidget {
  final Variable variable;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const _VariableRow({
    Key key,
    @required this.variable,
    @required this.isSelected,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(variable.name),
      value: isSelected,
      onChanged: onChanged,
    );
  }
}
