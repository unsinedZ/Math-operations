import 'package:flutter/foundation.dart';

import 'extremum.dart';
import 'target_function.dart';
import 'restriction.dart';

class LinearTask {
  final TargetFunction targetFunction;
  final List<Restriction> restrictions;
  final Extremum extremum;

  const LinearTask({
    @required this.targetFunction,
    @required this.extremum,
    @required this.restrictions,
  });

  LinearTask changeTargetFunction(TargetFunction newTargetFunction) {
    return LinearTask(
      targetFunction: newTargetFunction,
      restrictions: this.restrictions,
      extremum: this.extremum,
    );
  }

  LinearTask changeRestrictions(List<Restriction> newRestrictions) {
    return LinearTask(
      targetFunction: this.targetFunction,
      restrictions: newRestrictions,
      extremum: this.extremum,
    );
  }

  LinearTask changeExtremum(Extremum newExtremum) {
    return LinearTask(
      targetFunction: this.targetFunction,
      restrictions: this.restrictions,
      extremum: newExtremum,
    );
  }
}

class AdjustedLinearTask extends LinearTask {
  final String comment;

  const AdjustedLinearTask({
    @required TargetFunction targetFunction,
    @required Extremum extremum,
    @required List<Restriction> restrictions,
    @required this.comment,
  }) : super(
          targetFunction: targetFunction,
          extremum: extremum,
          restrictions: restrictions,
        );

  static AdjustedLinearTask wrap(LinearTask task, String comment) {
    return AdjustedLinearTask(
      comment: comment,
      targetFunction: task.targetFunction,
      extremum: task.extremum,
      restrictions: task.restrictions,
    );
  }
}
