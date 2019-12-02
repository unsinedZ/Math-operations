import 'package:app/business/operations/extremum.dart';
import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

class DualSimplexMethod extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DualSimplexState();
  }
}

class _DualSimplexState extends State<DualSimplexMethod> {
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
          Fraction.fromNumber(-1),
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
      title: 'Dual simplex method',
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
          ),
        ),
      ),
    );
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
      List<Restriction> newRestrictions = _restrictions;
      if (_targetFunction.coefficients.length != newValue.coefficients.length) {
        newRestrictions = _restrictions
            .map(
              (x) => _fitRestriction(x, newValue),
            )
            .toList();
      }

      _linearTask = _linearTask
          .changeTargetFunction(newValue)
          .changeRestrictions(newRestrictions);
    });
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
