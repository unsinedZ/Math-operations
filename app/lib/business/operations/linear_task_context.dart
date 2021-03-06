import 'package:flutter/foundation.dart';

import 'entities/linear_task.dart';
import 'entities/restriction.dart';
import 'entities/target_function.dart';

class LinearTaskContext {
  final LinearTask linearTask;
  final List<int> additionalVariableIndices;
  final List<int> artificialVariableIndices;

  TargetFunction get targetFunction => linearTask.targetFunction;
  List<Restriction> get restrictions => linearTask.restrictions;

  LinearTaskContext({
    @required this.linearTask,
    this.additionalVariableIndices = const <int>[],
    this.artificialVariableIndices = const <int>[],
  });

  LinearTaskContext changeLinearTask(LinearTask newTask) {
    return LinearTaskContext(
      linearTask: newTask,
      additionalVariableIndices: this.additionalVariableIndices,
      artificialVariableIndices: this.artificialVariableIndices,
    );
  }

  LinearTaskContext changeAdditionalVariableIndexes(List<int> newIndexes) {
    return LinearTaskContext(
      linearTask: this.linearTask,
      additionalVariableIndices: newIndexes,
      artificialVariableIndices: this.artificialVariableIndices,
    );
  }

  LinearTaskContext changeArtificialVariableIndexes(List<int> newIndexes) {
    return LinearTaskContext(
      linearTask: this.linearTask,
      additionalVariableIndices: this.additionalVariableIndices,
      artificialVariableIndices: newIndexes,
    );
  }
}
