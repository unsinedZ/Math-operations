import 'package:app/business/operations/linear_task.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:flutter/material.dart';

class TaskSequence extends StatelessWidget {
  final List<LinearTask> derivativeTasks;

  TaskSequence({
    Key key,
    @required this.derivativeTasks,
  }) : super(key: key) {
    if (derivativeTasks.isEmpty) throw Exception('No derivative tasks.');
  }

  @override
  Widget build(BuildContext context) {
    var onChangedStub = (_) {};
    var voidStub = () {};
    return Column(
      children: derivativeTasks.map((x) {
        return LinearTaskInfo(
          linearTask: x,
          onExtremumChanged: onChangedStub,
          onRestrictionsChanged: onChangedStub,
          onSolveClick: voidStub,
          onTargetFunctionChanged: onChangedStub,
          isReadOnly: true,
          onAddRestriction: voidStub,
          onRestrictionRemoved: onChangedStub,
        );
      }).toList(),
    );
  }
}
