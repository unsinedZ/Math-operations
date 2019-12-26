import 'package:flutter/foundation.dart';

import 'linear_task.dart';

class DiscreteTask extends LinearTask {
  final Set<String> integerVariableNames;

  const DiscreteTask({
    @required targetFunction,
    @required extremum,
    @required restrictions,
    @required this.integerVariableNames,
  }) : super(
          targetFunction: targetFunction,
          extremum: extremum,
          restrictions: restrictions,
        );

  DiscreteTask changeIntegerVariables(Set<String> newIntegerVariableNames) {
    return getBuilder()
        .addPrototype(this)
        .change((x) => x.integerVariableNames = newIntegerVariableNames)
        .build();
  }

  @override
  DiscreteTaskBuilder getBuilder() => DiscreteTaskBuilder();
}

class DiscreteTaskBuilder extends LinearTaskBuilder {
  Set<String> integerVariableNames;

  @override
  DiscreteTaskBuilder addPrototype(covariant DiscreteTask prototype) {
    super.addPrototype(prototype);
    this.integerVariableNames = prototype.integerVariableNames;
    return this;
  }

  @override
  DiscreteTaskBuilder change(void Function(DiscreteTaskBuilder) makeChange) {
    makeChange(this);
    return this;
  }

  @override
  DiscreteTask build() {
    return DiscreteTask(
      targetFunction: this.targetFunction,
      extremum: this.extremum,
      restrictions: this.restrictions,
      integerVariableNames: this.integerVariableNames,
    );
  }
}
