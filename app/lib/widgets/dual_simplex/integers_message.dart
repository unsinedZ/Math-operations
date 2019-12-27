import 'package:app/business/operations/entities/discrete_task.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/business/operations/variables_adapter.dart';
import 'package:app/widgets/editors/integers_form.dart';
import 'package:app/widgets/primitives/base_button.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:app/widgets/primitives/overflow_safe_bottom_sheet_modal.dart';
import 'package:flutter/material.dart';

class IntegersMessage extends StatelessWidget {
  final DiscreteTask discreteTask;
  final ValueChanged<DiscreteTask> onTaskChanged;
  final bool isReadOnly;

  const IntegersMessage({
    Key key,
    @required this.discreteTask,
    @required this.onTaskChanged,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sortedVariables = discreteTask.integerVariableNames.toList();
    var adapted = VariablesAdapter().adaptNamesIntoIndices(sortedVariables);
    int index = 0;
    sortedVariables = sortedVariables
      ..sort(
        (x, y) => adapted[index].compareTo(adapted[++index]),
      );
    var variables = '${sortedVariables.join(', ')}';
    return Row(
      children: <Widget>[
        Visibility(
          visible: !isReadOnly,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BaseButton(
              text: 'Integers:',
              onPressed: () => _onPressed(context),
            ),
          ),
          replacement: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BaseText('Integers:'),
          ),
        ),
        BaseText((variables.isNotEmpty ? variables : 'No integers') + '.'),
      ],
    );
  }

  void _onPressed(BuildContext context) {
    if (isReadOnly) {
      return;
    }

    OverflowSafeBottomSheetModal(
      (c) => IntegersForm(
        selection: _getVariableSelection(),
        onSelectionChanged: (x) {
          onTaskChanged(
            discreteTask.changeIntegerVariables(
              x.keys.where((z) => x[z]).toSet(),
            ),
          );
          Navigator.of(c).pop();
        },
      ),
    ).show(context);
  }

  Map<String, bool> _getVariableSelection() {
    int index = 0;
    return Map.fromIterable(
      discreteTask.targetFunction.coefficients.map(
        (x) => Variable.wrapVariableName(
          '${discreteTask.targetFunction.variableLetter}${++index}',
        ),
      ),
      key: (x) => x,
      value: (x) => discreteTask.integerVariableNames.contains(x),
    );
  }
}
