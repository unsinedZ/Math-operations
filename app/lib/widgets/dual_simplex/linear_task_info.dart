import 'package:app/business/operations/extremum.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/widgets/dual_simplex/greater_zero_message.dart';
import 'package:app/widgets/primitives/accent_button.dart';
import 'package:app/widgets/primitives/base_text.dart';
import 'package:flutter/material.dart';

import 'restriction_info.dart';
import 'function_info.dart';

class LinearTaskInfo extends StatelessWidget {
  final LinearTask linearTask;

  TargetFunction get targetFunction => linearTask.targetFunction;
  List<Restriction> get restrictions => linearTask.restrictions;
  Extremum get extremum => linearTask.extremum;

  final ValueChanged<TargetFunction> onTargetFunctionChanged;
  final ValueChanged<List<Restriction>> onRestrictionsChanged;
  final ValueChanged<Extremum> onExtremumChanged;
  final VoidCallback onSolveClick;

  final bool isReadOnly;

  const LinearTaskInfo({
    Key key,
    @required this.linearTask,
    @required this.onTargetFunctionChanged,
    @required this.onRestrictionsChanged,
    @required this.onExtremumChanged,
    @required this.onSolveClick,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String comment = this.linearTask is AdjustedLinearTask
        ? (this.linearTask as AdjustedLinearTask).comment
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FunctionInfo(
          targetFunction: targetFunction,
          onFunctionChanged: onTargetFunctionChanged,
          extremum: extremum,
          onExtremumChanged: onExtremumChanged,
        ),
        Divider(),
        ...restrictions
            .map(
              (x) => RestrictionInfo(
                restriction: x,
                variableLetter: targetFunction.variableLetter,
                onChanged: (newRestriction) {
                  onRestrictionsChanged(
                    restrictions.map((z) {
                      if (z == x) return newRestriction;

                      return z;
                    }).toList(),
                  );
                },
              ),
            )
            .toList(),
        Divider(),
        GreaterZeroMessage(
          targetFunction: targetFunction,
        ),
        Visibility(
          visible: comment != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BaseText(comment),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !isReadOnly,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              Center(
                child: AccentButton(
                  text: 'Solve',
                  onPressed: onSolveClick,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
