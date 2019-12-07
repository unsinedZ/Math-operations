import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/simplex_table.dart';
import 'package:app/business/operations/simplex_table_context.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:app/widgets/dual_simplex/simplex_table_info.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';

class SimplexSolution extends StatelessWidget {
  final TargetFunction originalTargetFunction;
  final TargetFunction targetFunction;
  final List<LinearTask> adjustmentSteps;
  final List<SimplexTable> solutionSteps;

  const SimplexSolution({
    Key key,
    @required this.originalTargetFunction,
    @required this.targetFunction,
    @required this.adjustmentSteps,
    @required this.solutionSteps,
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
          children: [
            ...adjustmentSteps
                .map(
                  (x) => BaseCard(
                    child: LinearTaskInfo(
                      linearTask: x,
                      onTargetFunctionChanged: null,
                      onRestrictionsChanged: null,
                      onExtremumChanged: null,
                      onSolveClick: null,
                      isReadOnly: true,
                      onAddRestriction: null,
                      onRestrictionRemoved: null,
                    ),
                  ),
                )
                .toList(),
            ...solutionSteps
                .map(
                  (x) => BaseCard(
                    child: SimplexTableInfo(
                      targetFunction: targetFunction,
                      simplexTableContext: SimplexTableContext.create(
                        simplexTable: x,
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
