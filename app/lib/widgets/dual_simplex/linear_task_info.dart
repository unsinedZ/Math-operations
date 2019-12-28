import 'package:app/business/operations/entities/extremum.dart';
import 'package:app/business/operations/entities/fraction.dart';
import 'package:app/business/operations/entities/linear_task.dart';
import 'package:app/business/operations/entities/restriction.dart';
import 'package:app/business/operations/entities/target_function.dart';
import 'package:app/widgets/dual_simplex/greater_zero_message.dart';
import 'package:app/widgets/primitives/accent_button.dart';
import 'package:app/widgets/primitives/base_icon.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'comment_info.dart';
import 'restriction_info.dart';
import 'function_info.dart';

class LinearTaskInfo extends StatelessWidget {
  final LinearTask linearTask;

  TargetFunction get targetFunction => linearTask.targetFunction;
  List<Restriction> get restrictions => linearTask.restrictions;
  Extremum get extremum => linearTask.extremum;

  final ValueChanged<LinearTask> onTaskChanged;
  final VoidCallback onSolveClick;

  final bool isReadOnly;

  const LinearTaskInfo({
    Key key,
    @required this.linearTask,
    @required this.onTaskChanged,
    @required this.onSolveClick,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildContent(context).toList(),
    );
  }

  @protected
  Iterable<Widget> buildContent(BuildContext context) sync* {
    yield FunctionInfo(
      targetFunction: targetFunction,
      onFunctionChanged: (newFunction) {
        var newTask = linearTask.changeTargetFunction(newFunction);
        if (targetFunction.coefficients.length !=
            newFunction.coefficients.length) {
          newTask = newTask.changeRestrictions(
            restrictions
                .map(
                  (x) => _fitRestriction(x, newFunction),
                )
                .toList(),
          );
        }

        onTaskChanged(newTask);
      },
      extremum: extremum,
      onExtremumChanged: (newExtremum) => onTaskChanged(
        linearTask.changeExtremum(newExtremum),
      ),
      isReadOnly: this.isReadOnly,
    );

    yield Divider();

    for (var restriction in buildRestrictions(context)) {
      yield restriction;
    }

    yield Visibility(
      visible: !isReadOnly,
      child: Center(
        child: BaseIcon(
          icon: Icons.add_circle_outline,
          onPressed: () {
            Restriction lastRestriction = restrictions.last;
            onTaskChanged(
              linearTask.changeRestrictions(
                concat(
                  [
                    restrictions,
                    [
                      lastRestriction.changeCoefficients(
                        lastRestriction.coefficients,
                      )
                    ],
                  ],
                ).toList(),
              ),
            );
          },
        ),
      ),
    );

    yield Divider();

    for (var message in buildMessages(context)) {
      yield message;
    }

    yield Visibility(
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
    );
  }

  @protected
  Iterable<Widget> buildRestrictions(BuildContext context) {
    return restrictions.map(
      (x) => RestrictionInfo(
        restriction: x,
        variableLetter: targetFunction.variableLetter,
        onChanged: (newRestriction) {
          onTaskChanged(
            linearTask.changeRestrictions(
              restrictions.map((z) {
                if (z == x) {
                  return newRestriction;
                }

                return z;
              }).toList(),
            ),
          );
        },
        isReadOnly: this.isReadOnly,
        onRemoveClick: () {
          onTaskChanged(
            linearTask.changeRestrictions(
              restrictions.where((z) => z != x).toList(),
            ),
          );
        },
        isRemovable: !isReadOnly && restrictions.length > 1,
        hideZeroCoefficients: isReadOnly,
      ),
    );
  }

  @protected
  Iterable<Widget> buildMessages(BuildContext context) sync* {
    yield GreaterZeroMessage(
      targetFunction: targetFunction,
    );

    String comment = this.linearTask is AdjustedLinearTask
        ? (this.linearTask as AdjustedLinearTask).comment
        : null;

    yield CommentInfo(
      comment: comment,
    );
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
