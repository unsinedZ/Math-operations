import 'package:app/business/operations/entities/discrete_task.dart';
import 'package:app/business/operations/entities/extremum.dart';
import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/business/operations/entities/variable.dart';
import 'package:app/widgets/dual_simplex/discrete_task_info.dart';
import 'package:app/widgets/layout/app_layout.dart';
import 'package:app/widgets/primitives/base_card.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

class GomoriMethod extends StatefulWidget {
  final String title;

  const GomoriMethod({Key key, this.title}) : super(key: key);

  @override
  _GomoriMethodState createState() => _GomoriMethodState();
}

class _GomoriMethodState extends State<GomoriMethod> {
  DiscreteTask _discreteTask;
  Map<String, bool> _variableSelection;

  TargetFunction get _targetFunction => _discreteTask.targetFunction;
  Set<String> get _integerVariableNames => _discreteTask.integerVariableNames;

  @override
  void initState() {
    _discreteTask = _createDefaultTask();
    _initVariables();

    super.initState();
  }

  void _initVariables() {
    int index = 0;
    _variableSelection = Map.fromIterable(
      _targetFunction.coefficients.map(
        (x) => Variable.wrapVariableName(
          '${_targetFunction.variableLetter}${++index}',
        ),
      ),
      key: (x) => x,
      value: (x) => _integerVariableNames.contains(x),
    );
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
            variableSelection: _variableSelection,
            onChangeSelection: (variableName, newSelection) {
              Set<String> newIntegers;

              bool shouldRemove = !newSelection &&
                  _discreteTask.integerVariableNames.contains(variableName);
              if (shouldRemove) {
                newIntegers = _discreteTask.integerVariableNames
                    .where(
                      (x) => x != variableName,
                    )
                    .toSet();
              }

              bool shouldAdd = newSelection &&
                  !_discreteTask.integerVariableNames.contains(variableName);
              if (shouldAdd) {
                newIntegers = concat(
                  [
                    _discreteTask.integerVariableNames,
                    [variableName],
                  ],
                ).toSet();
              }

              if (newIntegers != null) {
                setState(() {
                  _discreteTask = _discreteTask.changeIntegerVariables(
                    newIntegers,
                  );
                  _initVariables();
                });
              }
            },
          ),
        ),
      ),
    );
  }

  DiscreteTask _createDefaultTask() {
    return DiscreteTask(
      targetFunction: TargetFunction(
        coefficients: [
          Fraction.fromNumber(3),
          Fraction.fromNumber(1),
        ],
      ),
      extremum: Extremum.min,
      restrictions: [
        Restriction(
          coefficients: [
            Fraction.fromNumber(1),
            Fraction.fromNumber(3),
          ],
          comparison: ExpressionComparison.LowerOrEqual,
          freeMember: Fraction.fromNumber(5),
        ),
        Restriction(
          coefficients: [
            Fraction.fromNumber(3),
            Fraction.fromNumber(-2),
          ],
          comparison: ExpressionComparison.LowerOrEqual,
          freeMember: Fraction.fromNumber(6),
        ),
      ],
      integerVariableNames: [
        'x1',
        'x2',
      ].map(Variable.wrapVariableName).toSet(),
    );
  }
}
