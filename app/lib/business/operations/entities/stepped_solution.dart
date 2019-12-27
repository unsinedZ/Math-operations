import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/linear_task_solution.dart';
import 'package:flutter/foundation.dart';

class SteppedSolution {
  final List<LinearTaskContext> adjustmentSteps;
  final List<SimplexTable> solutionSteps;
  final LinearTaskSolution solution;

  SteppedSolution({
    @required this.adjustmentSteps,
    @required this.solutionSteps,
    @required this.solution,
  });

  SteppedSolution addSolutionSteps(List<SimplexTable> steps) {
    return SteppedSolution(
      adjustmentSteps: this.adjustmentSteps,
      solution: this.solution,
      solutionSteps: List.of(solutionSteps)..addAll(steps),
    );
  }

  SteppedSolution changeSolution(LinearTaskSolution newSolution) {
    return SteppedSolution(
      adjustmentSteps: this.adjustmentSteps,
      solution: newSolution,
      solutionSteps: this.solutionSteps,
    );
  }
}
