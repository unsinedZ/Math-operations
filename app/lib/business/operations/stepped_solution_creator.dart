import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/strategies/base_simplex_method_strategy.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:flutter/foundation.dart';

import 'entities/solution_status.dart';
import 'entities/stepped_solution.dart';
import 'linear_task_context.dart';
import 'linear_task_solution.dart';
import 'simplex_solver.dart';
import 'simplex_table/simplex_table_builder.dart';
import 'simplex_table/simplex_table_context.dart';
import 'strategies/isolver.dart';

class SteppedSolutionCreator {
  final LinearTaskAdjuster adjuster;
  final BaseSimplexMethodStrategy strategy;

  SteppedSolutionCreator({
    @required this.adjuster,
    @required this.strategy,
  });

  SteppedSolution solveTask(LinearTask linearTask) {
    var taskContext = LinearTaskContext(
      linearTask: linearTask.makeAdjusted("Initial task."),
    );
    var adjustmentSteps = adjuster.getAdjustmentSteps(taskContext)
      ..insert(
        0,
        taskContext,
      );
    var adjustedTask = adjustmentSteps.last;
    var simplexTable =
        SimplexTableBuilder().createSimplexTable(adjustedTask.linearTask);
    var solutionSteps = SimplexSolver(strategy).getSolutionSteps(simplexTable);
    var finalContext =
        SimplexTableContext.create(simplexTable: solutionSteps.last);
    var solution = createSolution(
      strategy,
      linearTask,
      finalContext,
      adjustedTask,
    );
    return SteppedSolution(
      adjustmentSteps: adjustmentSteps,
      solutionSteps: solutionSteps,
      solution: solution,
    );
  }

  static LinearTaskSolution createSolution(
    ISolver<SimplexTableContext> solver,
    LinearTask initialTask,
    SimplexTableContext context,
    LinearTaskContext taskContext,
  ) {
    SolutionStatus status = solver.canBeApplied(context)
        ? solver.solve(context)
        : SolutionStatus.undefined;
    LinearTaskSolution solution = LinearTaskSolution.create(
      status,
      initialTask.targetFunction,
      SimplexTableContext.create(
        simplexTable: context.simplexTable,
      ),
    );

    if (status == SolutionStatus.hasRoot &&
        taskContext.artificialVariableIndices.isNotEmpty) {
      bool hasNonZeroArtificialCoefficient = false;
      for (int index in taskContext.artificialVariableIndices) {
        if (!solution.variableCoefficients[index].equalsNumber(0)) {
          hasNonZeroArtificialCoefficient = true;
          break;
        }
      }

      if (hasNonZeroArtificialCoefficient) {
        return LinearTaskSolution.message(
          status: SolutionStatus.noRoots,
          customMessage: 'Artificial coefficient equals 0.',
        );
      }
    }

    return solution.shortenTo(initialTask.targetFunction.coefficients.length);
  }
}
