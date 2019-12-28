import 'package:app/business/operations/entities/discrete_task.dart';
import 'package:app/business/operations/entities/extremum.dart';
import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/entities/simplex_table.dart';
import 'package:app/business/operations/entities/solution_status.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/business/operations/simplex_solver.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:app/business/operations/stepped_solution_creator.dart';
import 'package:app/business/operations/strategies/base_clipping_method_strategy.dart';
import 'package:app/business/operations/strategies/base_simplex_method_strategy.dart';
import 'package:app/business/operations/strategies/dual_simplex_method_strategy.dart';
import 'package:app/business/operations/strategies/simplex_method_strategy.dart';
import 'package:app/business/operations/task_adjusters/dual_simplex_adjuster.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:app/business/operations/task_adjusters/simplex_adjuster.dart';
import 'package:app/business/operations/variables_adapter.dart';
import 'package:app/widgets/dual_simplex/discrete_task_info.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';

import 'simplex_solution.dart';

class GomoriMethod extends StatefulWidget {
  final String title;
  final BaseClippingMethodStrategy strategy;

  const GomoriMethod({
    Key key,
    @required this.title,
    @required this.strategy,
  }) : super(key: key);

  @override
  _GomoriMethodState createState() => _GomoriMethodState();
}

class _GomoriMethodState extends State<GomoriMethod> {
  static const int _MAX_CLIPPINGS = 5;

  DiscreteTask _discreteTask;

  @override
  void initState() {
    _discreteTask = _createDefaultTask();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: widget.title,
      content: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: 12,
        ),
        scrollDirection: Axis.vertical,
        child: BaseCard(
          child: DiscreteTaskInfo(
            discreteTask: _discreteTask,
            onTaskChanged: (newTask) {
              setState(() {
                _discreteTask = newTask;
              });
            },
            onSolveClick: _onSolveClicked,
            lockIntegers: widget.strategy.requiresAllIntegers,
          ),
        ),
      ),
    );
  }

  DiscreteTask _createDefaultTask() {
    return DiscreteTask(
      targetFunction: TargetFunction(
        coefficients: [
          Fraction.fromNumber(1),
          Fraction.fromNumber(2),
        ],
      ),
      extremum: Extremum.max,
      restrictions: [
        Restriction(
          coefficients: [
            Fraction.fromNumber(5),
            Fraction.fromNumber(7),
          ],
          comparison: ExpressionComparison.LowerOrEqual,
          freeMember: Fraction.fromNumber(21),
        ),
        Restriction(
          coefficients: [
            Fraction.fromNumber(-1),
            Fraction.fromNumber(3),
          ],
          comparison: ExpressionComparison.LowerOrEqual,
          freeMember: Fraction.fromNumber(8),
        ),
      ],
      integerVariableNames: [
        'x1',
        'x2',
      ].map(Variable.wrapVariableName).toSet(),
    );
  }

  void _onSolveClicked() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          // do not kill for this line
          var task = _discreteTask;
          bool isDualApplicable = _canUseDualSimplex();
          LinearTaskAdjuster supportAdjuster;
          BaseSimplexMethodStrategy supportStratery;
          if (isDualApplicable) {
            supportAdjuster = DualSimplexAdjuster();
            supportStratery = DualSimplexMethodStrategy();
          } else {
            supportAdjuster = SimplexAdjuster();
            supportStratery = SimplexMethodStrategy();
          }

          var s = SteppedSolutionCreator(
            adjuster: supportAdjuster,
            strategy: supportStratery,
          ).solveTask(task);
          var lastFunction = s.adjustmentSteps.last.targetFunction;
          if (s.solution.status == SolutionStatus.hasRoot) {
            var integerVars = VariablesAdapter()
                .adaptNamesIntoIndices(
                  task.integerVariableNames.toList(),
                )
                .map((x) => x - 1)
                .toList();

            var iTask = s.adjustmentSteps.first;
            int counter = 0;
            var dualStrategy = SimplexSolver(DualSimplexMethodStrategy());
            var gomoriStrategy = widget.strategy;
            do {
              var simplexTableContext = SimplexTableContext.create(
                simplexTable: s.solutionSteps.last,
                integerVariableIndices: integerVars,
              );
              var solutionStatus = gomoriStrategy.solve(simplexTableContext);
              if (solutionStatus != SolutionStatus.undefined) {
                break;
              }

              var clippedTable = gomoriStrategy
                  .addClipping(simplexTableContext)
                  .simplexTable
                  .makeAdjusted(
                    "Added clipping ${counter + 1}.",
                    solutionStatus,
                  );
              var newSteps = dualStrategy.getSolutionSteps(clippedTable);

              s = s.addSolutionSteps(newSteps).changeSolution(
                    SteppedSolutionCreator.createSolution(
                      gomoriStrategy,
                      iTask.linearTask,
                      SimplexTableContext.create(
                        simplexTable: newSteps.last,
                        integerVariableIndices: integerVars,
                      ),
                      iTask,
                    ),
                  );

              lastFunction = lastFunction.changeCoefficients(
                List.from(lastFunction.coefficients)
                  ..add(
                    Fraction.fromNumber(0),
                  ),
              );
            } while (++counter < _MAX_CLIPPINGS);
          }

          if (s.adjustmentSteps.isNotEmpty &&
              s.adjustmentSteps.last.linearTask.extremum !=
                  _discreteTask.extremum) {
            s = s.changeSolution(
              s.solution.changeFunctionValue(
                s.solution.functionValue * Fraction.fromNumber(-1),
              ),
            );
          }

          var finalSolution = s.solution;
          return SimplexSolution(
            solution: finalSolution,
            targetFunction: lastFunction,
            adjustmentSteps: s.adjustmentSteps,
            solutionSteps: s.solutionSteps,
          );
        },
      ),
    );
  }

  bool _canUseDualSimplex() {
    if (_discreteTask.extremum == Extremum.max) {
      return _discreteTask.targetFunction.coefficients
          .every((x) => !x.isPositive());
    }

    return _discreteTask.targetFunction.coefficients
        .every((x) => !x.isNegative());
  }
}
