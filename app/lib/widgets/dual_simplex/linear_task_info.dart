import 'package:app/business/operations/extremum.dart';
import 'package:app/business/operations/linear_task.dart';
import 'package:app/business/operations/restriction.dart';
import 'package:app/business/operations/target_function.dart';
import 'package:app/widgets/dual_simplex/greater_zero_message.dart';
import 'package:app/widgets/primitives/accent_button.dart';
import 'package:app/widgets/primitives/base_icon.dart';
import 'package:flutter/material.dart';

import 'comment_info.dart';
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
  final VoidCallback onAddRestriction;
  final ValueChanged<Restriction> onRestrictionRemoved;

  final bool isReadOnly;

  const LinearTaskInfo({
    Key key,
    @required this.linearTask,
    @required this.onTargetFunctionChanged,
    @required this.onRestrictionsChanged,
    @required this.onExtremumChanged,
    @required this.onSolveClick,
    @required this.onAddRestriction,
    @required this.onRestrictionRemoved,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String comment = this.linearTask is AdjustedLinearTask
        ? (this.linearTask as AdjustedLinearTask).comment
        : null;
    int index = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FunctionInfo(
          targetFunction: targetFunction,
          onFunctionChanged: onTargetFunctionChanged,
          extremum: extremum,
          onExtremumChanged: onExtremumChanged,
          isReadOnly: this.isReadOnly,
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
                isReadOnly: this.isReadOnly,
                onRemoveClick: isReadOnly || index++ == 0
                    ? null
                    : () => onRestrictionRemoved(x),
                hideZeroCoefficients: isReadOnly,
              ),
            )
            .toList(),
        Visibility(
          visible: !isReadOnly,
          child: Center(
            child: BaseIcon(
              icon: Icons.add_circle_outline,
              onPressed: onAddRestriction,
            ),
          ),
        ),
        Divider(),
        GreaterZeroMessage(
          targetFunction: targetFunction,
        ),
        CommentInfo(
          comment: comment,
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
