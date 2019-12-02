import 'package:app/business/operations/extremum.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/widgets/primitives/accent_button.dart';
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

  const LinearTaskInfo({
    Key key,
    @required this.linearTask,
    @required this.onTargetFunctionChanged,
    @required this.onRestrictionsChanged,
    @required this.onExtremumChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        AccentButton(
          text: 'Solve',
          onPressed: () {},
        ),
      ],
    );
  }
}
