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

class GomoriMethod extends StatefulWidget {
  final String title;

  const GomoriMethod({Key key, this.title}) : super(key: key);

  @override
  _GomoriMethodState createState() => _GomoriMethodState();
}

class _GomoriMethodState extends State<GomoriMethod> {
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
            onSolveClick: () {},
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
