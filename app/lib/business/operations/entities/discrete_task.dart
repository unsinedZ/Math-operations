import 'package:flutter/foundation.dart';

import 'linear_task.dart';
import 'variable.dart';

class DiscreteTask extends LinearTask {
  final List<Variable> integerVariables;

  const DiscreteTask({
    @required targetFunction,
    @required extremum,
    @required restrictions,
    this.integerVariables = const <Variable>[],
  }) : super(
          targetFunction: targetFunction,
          extremum: extremum,
          restrictions: restrictions,
        );

  DiscreteTask changeIntegerVariables(List<Variable> newIntegerVariables) {
    return getBuilder()
        .addPrototype(this)
        .change((x) => x.integerVariables = newIntegerVariables)
        .build();
  }

  @override
  DiscreteTaskBuilder getBuilder() => DiscreteTaskBuilder();
}

class DiscreteTaskBuilder extends LinearTaskBuilder {
  List<Variable> integerVariables;

  @override
  DiscreteTaskBuilder addPrototype(covariant DiscreteTask prototype) {
    super.addPrototype(prototype);
    this.integerVariables = prototype.integerVariables;
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
      integerVariables: this.integerVariables,
    );
  }
}
