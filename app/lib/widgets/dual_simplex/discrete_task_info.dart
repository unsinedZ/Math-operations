import 'package:app/business/operations/entities/discrete_task.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:flutter/material.dart';

import 'integers_message.dart';

class DiscreteTaskInfo extends LinearTaskInfo {
  final bool lockIntegers;
  
  DiscreteTask get discreteTask => linearTask as DiscreteTask;

  DiscreteTaskInfo({
    Key key,
    @required DiscreteTask discreteTask,
    @required ValueChanged<DiscreteTask> onTaskChanged,
    @required VoidCallback onSolveClick,
    bool isReadOnly = false,
    this.lockIntegers = false,
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

    yield IntegersMessage(
      discreteTask: discreteTask,
      onTaskChanged: onTaskChanged,
      isReadOnly: isReadOnly || lockIntegers,
    );
  }
}
