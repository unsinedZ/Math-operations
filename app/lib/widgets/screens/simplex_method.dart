import 'package:app/business/operations/entities/extremum.dart';
import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/business/operations/stepped_solution_creator.dart';
import 'package:app/business/operations/strategies/base_simplex_method_strategy.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';

import 'simplex_solution.dart';

class SimplexMethod extends StatefulWidget {
  final String title;
  final LinearTaskAdjuster taskAdjuster;
  final BaseSimplexMethodStrategy simplexMethodStrategy;

  const SimplexMethod({
    Key key,
    @required this.title,
    @required this.taskAdjuster,
    @required this.simplexMethodStrategy,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DualSimplexState();
  }
}

class _DualSimplexState extends State<SimplexMethod> {
  LinearTask _linearTask;

  static LinearTask _createDefaultTask() {
    return LinearTask(
      targetFunction: _createDefaultFunction(),
      restrictions: _createDefaultRestrictions(),
      extremum: Extremum.min,
    );
  }

  static TargetFunction _createDefaultFunction() {
    return TargetFunction(
      coefficients: [
        Fraction.fromNumber(2),
        Fraction.fromNumber(3),
      ],
    );
  }

  static List<Restriction> _createDefaultRestrictions() {
    return <Restriction>[
      Restriction(
        coefficients: [
          Fraction.fromNumber(1),
          Fraction.fromNumber(-1),
        ],
        comparison: ExpressionComparison.LowerOrEqual,
        freeMember: Fraction.fromNumber(2),
      ),
      Restriction(
        coefficients: [
          Fraction.fromNumber(2),
          Fraction.fromNumber(3),
        ],
        comparison: ExpressionComparison.GreaterOrEqual,
        freeMember: Fraction.fromNumber(5),
      ),
      Restriction(
        coefficients: [
          Fraction.fromNumber(-4),
          Fraction.fromNumber(2),
        ],
        comparison: ExpressionComparison.LowerOrEqual,
        freeMember: Fraction.fromNumber(-3),
      ),
    ];
  }

  @override
  void initState() {
    _linearTask = _createDefaultTask();
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
          child: LinearTaskInfo(
            linearTask: _linearTask,
            onTaskChanged: (newTask) {
              setState(() {
                _linearTask = newTask;
              });
            },
            onSolveClick: _onSolveClicked,
          ),
        ),
      ),
    );
  }

  void _onSolveClicked() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          var s = SteppedSolutionCreator(
            adjuster: widget.taskAdjuster,
            strategy: widget.simplexMethodStrategy,
          ).solveTask(_linearTask);
          if (s.adjustmentSteps.isNotEmpty &&
              s.adjustmentSteps.last.linearTask.extremum !=
                  _linearTask.extremum) {
            s = s.changeSolution(
              s.solution.changeFunctionValue(
                s.solution.functionValue * Fraction.fromNumber(-1),
              ),
            );
          }
          return SimplexSolution(
            solution: s.solution,
            targetFunction: s.adjustmentSteps.last.targetFunction,
            adjustmentSteps: s.adjustmentSteps,
            solutionSteps: s.solutionSteps,
          );
        },
      ),
    );
  }
}
