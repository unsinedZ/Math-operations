import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/linear_task_solution.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:app/widgets/dual_simplex/simplex_table_info.dart';
import 'package:app/widgets/dual_simplex/solution_summary.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';

class SimplexSolution extends StatelessWidget {
  final TargetFunction targetFunction;
  final List<LinearTaskContext> adjustmentSteps;
  final List<SimplexTable> solutionSteps;
  final LinearTaskSolution solution;

  const SimplexSolution({
    Key key,
    @required this.targetFunction,
    @required this.adjustmentSteps,
    @required this.solutionSteps,
    @required this.solution,
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
                      linearTask: x.linearTask,
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
            BaseCard(
              child: SolutionSummary(
                solution: solution,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
