import 'package:app/widgets/primitives/base_text.dart';
import 'package:flutter/material.dart';

class VariablesSelector extends StatelessWidget {
  final String title;
  final Map<String, bool> variableSelection;
  final void Function(String, bool) onChangeSelection;

  const VariablesSelector({
    Key key,
    @required this.title,
    @required this.variableSelection,
    @required this.onChangeSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BaseText(title),
          ),
          ...variableSelection.keys.map(
            (variableName) {
              return _VariableRow(
                variableName: variableName,
                isSelected: variableSelection[variableName],
                onChanged: (newSelection) => onChangeSelection(
                  variableName,
                  newSelection,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _VariableRow extends StatelessWidget {
  final String variableName;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const _VariableRow({
    Key key,
    @required this.variableName,
    @required this.isSelected,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(variableName),
      value: isSelected,
      onChanged: onChanged,
    );
  }
}
