import 'package:app/business/operations/linear_task.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';

class SimplexSolution extends StatelessWidget {
  final List<LinearTask> steps;

  const SimplexSolution({
    Key key,
    @required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Solution',
      content: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: 12,
        ),
        scrollDirection: Axis.vertical,
        child: Column(
          children: steps
              .map(
                (x) => BaseCard(
                  child: LinearTaskInfo(
                    linearTask: x,
                    onTargetFunctionChanged: null,
                    onRestrictionsChanged: null,
                    onExtremumChanged: null,
                    onSolveClick: null,
                    isReadOnly: true,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
