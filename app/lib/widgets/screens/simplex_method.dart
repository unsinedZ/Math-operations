import 'package:app/business/operations/entities/extremum.dart';
import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/entities/solution_status.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/linear_task_solution.dart';
import 'package:app/business/operations/simplex_solver.dart';
import 'package:app/business/operations/simplex_table/simplex_table_builder.dart';
import 'package:app/business/operations/simplex_table/simplex_table_context.dart';
import 'package:app/business/operations/strategies/base_simplex_method_strategy.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

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

  TargetFunction get _targetFunction => _linearTask.targetFunction;
  List<Restriction> get _restrictions => _linearTask.restrictions;

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
        Fraction.fromNumber(1),
        Fraction.fromNumber(1),
      ],
    );
  }

  static List<Restriction> _createDefaultRestrictions() {
    return <Restriction>[
      Restriction(
        coefficients: [
          Fraction.fromNumber(1),
          Fraction.fromNumber(-2),
        ],
        comparison: ExpressionComparison.LowerOrEqual,
        freeMember: Fraction.fromNumber(4),
      ),
      Restriction(
        coefficients: [
          Fraction.fromNumber(3),
          Fraction.fromNumber(-1),
        ],
        comparison: ExpressionComparison.LowerOrEqual,
        freeMember: Fraction.fromNumber(-1),
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
            onTargetFunctionChanged: _onTargetFunctionChanged,
            onRestrictionsChanged: _onRestrictionsChanged,
            onExtremumChanged: _onExtremumChanged,
            onSolveClick: _onSolveClick,
            onAddRestriction: _onAddRestriction,
            onRestrictionRemoved: _onRestrictionRemoved,
          ),
        ),
      ),
    );
  }

  void _onAddRestriction() {
    setState(() {
      Restriction lastRestriction = _restrictions.last;
      _linearTask = _linearTask.changeRestrictions(
        concat(
          [
            _restrictions,
            [
              lastRestriction.changeCoefficients(
                lastRestriction.coefficients
                    .map(
                      (x) => Fraction.fromNumber(1),
                    )
                    .toList(),
              )
            ],
          ],
        ).toList(),
      );
    });
  }

  void _onRestrictionRemoved(Restriction restriction) {
    setState(() {
      int index = 0;
      _linearTask = _linearTask.changeRestrictions(
        _restrictions
            .where(
              (x) => index++ == 0 || x != restriction,
            )
            .toList(),
      );
    });
  }

  void _onSolveClick() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          var taskContext = LinearTaskContext(
            linearTask: AdjustedLinearTask.wrap(
              _linearTask,
              "Initial task.",
            ),
          );
          var adjustmentSteps =
              widget.taskAdjuster.getAdjustmentSteps(taskContext)
                ..insert(
                  0,
                  taskContext,
                );
          var adjustedTask = adjustmentSteps.last;
          var simplexTable =
              SimplexTableBuilder().createSimplexTable(adjustedTask.linearTask);
          var solutionSteps = new SimplexSolver(widget.simplexMethodStrategy)
              .getSolutionSteps(simplexTable);
          var finalContext =
              SimplexTableContext.create(simplexTable: solutionSteps.last);
          return SimplexSolution(
            solution: _getSolution(finalContext, adjustedTask),
            targetFunction: adjustedTask.linearTask.targetFunction,
            adjustmentSteps: adjustmentSteps,
            solutionSteps: solutionSteps,
          );
        },
      ),
    );
  }

  LinearTaskSolution _getSolution(
      SimplexTableContext context, LinearTaskContext taskContext) {
    SolutionStatus status = widget.simplexMethodStrategy.canBeApplied(context)
        ? widget.simplexMethodStrategy.solve(context)
        : SolutionStatus.undefined;
    LinearTaskSolution solution = LinearTaskSolution.create(
      status,
      _targetFunction,
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

    return solution.shortenTo(_targetFunction.coefficients.length);
  }

  void _onExtremumChanged(Extremum newExtremum) {
    setState(() {
      _linearTask = _linearTask.changeExtremum(newExtremum);
    });
  }

  void _onRestrictionsChanged(List<Restriction> newRestrictions) {
    setState(() {
      _linearTask = _linearTask.changeRestrictions(newRestrictions);
    });
  }

  void _onTargetFunctionChanged(TargetFunction newValue) {
    setState(() {
      _linearTask = _changeLinearTask(_linearTask, newValue);
    });
  }

  LinearTask _changeLinearTask(
      LinearTask linearTask, TargetFunction newFunction) {
    List<Restriction> newRestrictions = _restrictions;
    if (_targetFunction.coefficients.length !=
        newFunction.coefficients.length) {
      newRestrictions = _restrictions
          .map(
            (x) => _fitRestriction(x, newFunction),
          )
          .toList();
    }

    return linearTask
        .changeTargetFunction(newFunction)
        .changeRestrictions(newRestrictions);
  }

  Restriction _fitRestriction(
    Restriction restriction,
    TargetFunction targetFunction,
  ) {
    int rCoefficients = restriction.coefficients.length;
    int fCoefficients = targetFunction.coefficients.length;
    if (rCoefficients > fCoefficients) {
      return restriction.changeCoefficients(
        restriction.coefficients.take(fCoefficients).toList(),
      );
    }

    return restriction.changeCoefficients(
      concat(
        [
          restriction.coefficients,
          List.generate(
            fCoefficients - rCoefficients,
            (_) => Fraction.fromNumber(1),
          )
        ],
      ).toList(),
    );
  }
}
