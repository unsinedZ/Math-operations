import 'package:app/business/operations/entities/discrete_task.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'integers_message.dart';

class DiscreteTaskInfo extends LinearTaskInfo {
  DiscreteTask get discreteTask => linearTask as DiscreteTask;

  TargetFunction get targetFunction => discreteTask.targetFunction;
  Set<String> get integerVariableNames => discreteTask.integerVariableNames;

  DiscreteTaskInfo({
    Key key,
    @required DiscreteTask discreteTask,
    @required ValueChanged<DiscreteTask> onTaskChanged,
    @required VoidCallback onSolveClick,
    bool isReadOnly = false,
  }) : super(
          key: key,
          linearTask: discreteTask,
          onTaskChanged: (t) => onTaskChanged(t as DiscreteTask),
          onSolveClick: onSolveClick,
          isReadOnly: isReadOnly,
        );

  @override
  Iterable<Widget> buildMessages(BuildContext context) sync* {
    for (var message in super.buildMessages(context)) {
      yield message;
    }

    yield Visibility(
      visible: discreteTask.integerVariableNames.isNotEmpty,
      child: IntegersMessage(
        discreteTask: discreteTask,
      ),
    );
    // return VariablesSelector(
    //   title: 'Select integer variables:',
    //   variableSelection: _getVariableSelection(),
    //   onChangeSelection: _onChangeSelection,
    // );
  }

  void _onChangeSelection(String variableName, bool newSelection) {
    Set<String> newIntegers;

    bool shouldRemove = !newSelection &&
        discreteTask.integerVariableNames.contains(variableName);
    if (shouldRemove) {
      newIntegers = discreteTask.integerVariableNames
          .where(
            (x) => x != variableName,
          )
          .toSet();
    }

    bool shouldAdd = newSelection &&
        !discreteTask.integerVariableNames.contains(variableName);
    if (shouldAdd) {
      newIntegers = concat(
        [
          discreteTask.integerVariableNames,
          [variableName],
        ],
      ).toSet();
    }

    if (newIntegers != null) {
      onTaskChanged(
        discreteTask.changeIntegerVariables(
          newIntegers,
        ),
      );
    }
  }

  Map<String, bool> _getVariableSelection() {
    int index = 0;
    return Map.fromIterable(
      targetFunction.coefficients.map(
        (x) => Variable.wrapVariableName(
          '${targetFunction.variableLetter}${++index}',
        ),
      ),
      key: (x) => x,
      value: (x) => integerVariableNames.contains(x),
    );
  }
}
