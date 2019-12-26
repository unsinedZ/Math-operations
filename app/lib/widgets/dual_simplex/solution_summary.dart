import 'package:app/business/operations/entities/solution_status.dart';
import 'package:app/business/operations/linear_task_solution.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:flutter/material.dart';

class SolutionSummary extends StatelessWidget {
  final LinearTaskSolution solution;

  const SolutionSummary({
    Key key,
    @required this.solution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BaseText(_getSolutionMessage()),
          Visibility(
            visible: solution.customMessage != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(),
                BaseText(solution.customMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSolutionMessage() {
    switch (solution.status) {
      case SolutionStatus.undefined:
        return 'Unable to solve task.';
      case SolutionStatus.noRoots:
        return 'Task solved. Multiplicity of available solutions is empty.';
      case SolutionStatus.hasRoot:
        return 'Task solved. Optimal solution was found. ${_getPointInfo()}. ${_getFunctionInfo()}.';
      default:
        throw Exception('Not supported');
    }
  }

  String _getPointInfo() {
    return '${solution.variableName}* = (${solution.variableCoefficients.join(',')})';
  }

  String _getFunctionInfo() {
    return '${solution.functionName}(${solution.variableName}*) = ${solution.functionValue}';
  }
}
