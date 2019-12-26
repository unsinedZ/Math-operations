import 'package:app/widgets/dual_simplex/linear_task_info.dart';
import 'package:flutter/material.dart';

import 'variables_selector.dart';

class DiscreteTaskInfo extends LinearTaskInfo {
  final Map<String, bool> variableSelection;
  final void Function(String, bool) onChangeSelection;

  DiscreteTaskInfo({
    @required this.variableSelection,
    @required this.onChangeSelection,
  });

  @override
  Widget build(BuildContext context) {
    return VariablesSelector(
      title: 'Select integer variables:',
      variableSelection: variableSelection,
      onChangeSelection: onChangeSelection,
    );
  }
}
