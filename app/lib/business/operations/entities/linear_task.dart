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
    return getBuilder()
        .addPrototype(this)
        .change((x) => x.targetFunction = newTargetFunction)
        .build();
  }

  LinearTask changeRestrictions(List<Restriction> newRestrictions) {
    return getBuilder()
        .addPrototype(this)
        .change((x) => x.restrictions = newRestrictions)
        .build();
  }

  LinearTask changeExtremum(Extremum newExtremum) {
    return getBuilder()
        .addPrototype(this)
        .change((x) => x.extremum = newExtremum)
        .build();
  }

  LinearTaskBuilder getBuilder() => LinearTaskBuilder();
}

class LinearTaskBuilder {
  @protected
  TargetFunction targetFunction;

  @protected
  List<Restriction> restrictions;

  @protected
  Extremum extremum;

  LinearTaskBuilder addPrototype(LinearTask prototype) {
    this.targetFunction = prototype.targetFunction;
    this.extremum = prototype.extremum;
    this.restrictions = prototype.restrictions;
    return this;
  }

  LinearTaskBuilder change(void Function(LinearTaskBuilder) makeChange) {
    makeChange(this);
    return this;
  }

  LinearTask build() {
    return LinearTask(
      targetFunction: this.targetFunction,
      extremum: this.extremum,
      restrictions: this.restrictions,
    );
  }
}

class AdjustedLinearTask extends LinearTask {
  final String comment;
  final List<int> artificialVariableIndices;

  const AdjustedLinearTask({
    @required TargetFunction targetFunction,
    @required Extremum extremum,
    @required List<Restriction> restrictions,
    @required this.comment,
    this.artificialVariableIndices,
  }) : super(
          targetFunction: targetFunction,
          extremum: extremum,
          restrictions: restrictions,
        );

  static AdjustedLinearTask wrap(LinearTask task, String comment,
      [List<int> artificialVariableIndices]) {
    List<int> artificialVariableIndices =
        task is AdjustedLinearTask ? task.artificialVariableIndices : null;
    return AdjustedLinearTask(
      comment: comment,
      targetFunction: task.targetFunction,
      extremum: task.extremum,
      restrictions: task.restrictions,
      artificialVariableIndices: artificialVariableIndices,
    );
  }
}
