import 'package:app/business/operations/entities/discrete_task.dart';
import 'package:app/widgets/dual_simplex/comment_info.dart';
import 'package:flutter/material.dart';

class IntegersMessage extends StatelessWidget {
  final DiscreteTask discreteTask;

  const IntegersMessage({
    Key key,
    @required this.discreteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommentInfo(
      comment: 'Integers: ${discreteTask.integerVariableNames.join(', ')}.',
      addDivider: false,
    );
  }
}
